-- =========================================================
-- SCHEMAS
-- =========================================================

CREATE SCHEMA adm;
CREATE SCHEMA site;
CREATE SCHEMA contabil;


-- =========================================================
-- ENUMS
-- =========================================================

CREATE TYPE adm.stts_estoque_enum AS ENUM (
    'disponivel',
    'atencao',
    'critico',
    'indisponivel'
);

CREATE TYPE adm.forma_pagamento_enum AS ENUM (
    'credito',
    'debito',
    'pix'
);

CREATE TYPE adm.stts_pagamento_enum AS ENUM (
    'aguardando pagamento',
    'pago',
    'expirado',
    'cancelado'
);

CREATE TYPE adm.tipo_desconto_cupom_enum AS ENUM (
    'percentual',
    'fixo'
);

CREATE TYPE adm.stts_pagamento_venda_enum AS ENUM (
    'aguardando pagamento',
    'pago'
);

CREATE TYPE adm.stts_venda_enum AS ENUM (
    'em preparação',
    'concluída',
    'cancelada'
);

CREATE TYPE adm.stts_entrega_enum AS ENUM (
    'aguardando envio',
    'em transporte',
    'entregue',
    'cancelada'
);

CREATE TYPE site.tipo_usuario_enum AS ENUM (
    'admin',
    'cliente'
);

CREATE TYPE contabil.tipo_conta_enum AS ENUM (
    'ativo',
    'passivo',
    'patrimônio líquido',
    'receita',
    'despesa'
);

CREATE TYPE contabil.natureza_conta_enum AS ENUM (
    'devedora',
    'credora'
);


-- =========================================================
-- ENDEREÇO
-- =========================================================

CREATE TABLE site.endereco (
    id SERIAL PRIMARY KEY,
    rua VARCHAR(100) NOT NULL,

    -- ALTERADO:
    -- era INTEGER; agora permite valores como "120-A" e "S/N"
    numero VARCHAR(20) NOT NULL,

    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,

    -- ALTERADO:
    -- guarda apenas a sigla, como MG, RJ, SP
    estado CHAR(2) NOT NULL,

    cep VARCHAR(9) NOT NULL,
    complemento VARCHAR(100)
);


-- =========================================================
-- USUÁRIO
-- =========================================================

CREATE TABLE site.usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nome_social VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    tel VARCHAR(20) NOT NULL,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo site.tipo_usuario_enum NOT NULL DEFAULT 'cliente'
);


-- =========================================================
-- ENDEREÇOS DO USUÁRIO
-- =========================================================

CREATE TABLE site.usuario_endereco (
    id_usuario INTEGER NOT NULL,
    id_endereco INTEGER NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (id_usuario, id_endereco),

    CONSTRAINT fk_usuario_endereco_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES site.usuario(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_endereco_endereco
        FOREIGN KEY (id_endereco)
        REFERENCES site.endereco(id)
        ON DELETE CASCADE
);


-- =========================================================
-- FORNECEDOR
-- =========================================================

CREATE TABLE adm.fornecedor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nome_social VARCHAR(255),
    nome_fantasia VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    tel VARCHAR(20) NOT NULL,
    documento VARCHAR(18) NOT NULL UNIQUE,
    id_endereco INTEGER NOT NULL,

    CONSTRAINT fk_fornecedor_endereco
        FOREIGN KEY (id_endereco)
        REFERENCES site.endereco(id)
);


-- =========================================================
-- CATEGORIA
-- =========================================================

CREATE TABLE adm.categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);


-- =========================================================
-- CUPOM
-- =========================================================

CREATE TABLE adm.cupom (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    tipo_desconto adm.tipo_desconto_cupom_enum NOT NULL,
    valor DECIMAL(15,2) NOT NULL,
    data_inicio TIMESTAMPTZ NOT NULL,
    data_fim TIMESTAMPTZ NOT NULL,
    valor_minimo DECIMAL(15,2) DEFAULT 0,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT ck_cupom_valor
        CHECK (
            valor >= 0
            AND (
                (tipo_desconto = 'percentual' AND valor <= 100)
                OR
                (tipo_desconto = 'fixo')
            )
        ),

    CONSTRAINT ck_cupom_valor_minimo
        CHECK (valor_minimo >= 0),

    CONSTRAINT ck_cupom_data_fim_data_inicio
        CHECK (data_fim > data_inicio)
);


-- =========================================================
-- PRODUTO
-- =========================================================

CREATE TABLE adm.produto (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    preco DECIMAL(15,2) NOT NULL,
    id_categoria INTEGER NOT NULL,
    preco_promocional DECIMAL(15,2),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES adm.categoria(id),

    CONSTRAINT ck_produto_preco
        CHECK (preco >= 0),

    CONSTRAINT ck_produto_preco_promocional
        CHECK (
            preco_promocional IS NULL
            OR (
                preco_promocional >= 0
                AND preco_promocional < preco
            )
        )
);


-- =========================================================
-- FORNECEDORES DO PRODUTO
-- =========================================================

CREATE TABLE adm.produto_fornecedor (
    id_produto INTEGER NOT NULL,
    id_fornecedor INTEGER NOT NULL,

    PRIMARY KEY (id_produto, id_fornecedor),

    FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    FOREIGN KEY (id_fornecedor)
        REFERENCES adm.fornecedor(id)
);


-- =========================================================
-- ESTOQUE
-- =========================================================

CREATE TABLE adm.estoque (
    id SERIAL PRIMARY KEY,
    id_produto INTEGER NOT NULL UNIQUE,
    quant INTEGER NOT NULL DEFAULT 0,
    stts adm.stts_estoque_enum NOT NULL DEFAULT 'disponivel',
    valor_atencao INTEGER NOT NULL DEFAULT 5,
    editado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_estoque_produto
        FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    CONSTRAINT ck_estoque_quant
        CHECK (quant >= 0),

    CONSTRAINT ck_estoque_valor_atencao
        CHECK (valor_atencao >= 0)
);


-- =========================================================
-- CARRINHO
-- =========================================================

CREATE TABLE site.carrinho (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_cupom INTEGER,

    -- ALTERADO:
    -- removemos "total".
    -- O total do carrinho será calculado a partir dos itens.

    CONSTRAINT fk_carrinho_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES site.usuario(id),

    CONSTRAINT fk_carrinho_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id)
);


-- =========================================================
-- ITEM DO CARRINHO
-- =========================================================

-- ALTERADO:
-- antes: site.item
-- agora: site.item_carrinho

CREATE TABLE site.item_carrinho (
    id SERIAL PRIMARY KEY,
    id_carrinho INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quant INTEGER NOT NULL,

    -- ALTERADO:
    -- removemos "total".
    -- O valor é calculado usando quantidade x preço do produto.

    CONSTRAINT fk_item_carrinho
        FOREIGN KEY (id_carrinho)
        REFERENCES site.carrinho(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_carrinho_produto
        FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    CONSTRAINT ck_item_carrinho_quant
        CHECK (quant > 0),

    CONSTRAINT uk_item_carrinho_produto
        UNIQUE (id_carrinho, id_produto)
);


-- =========================================================
-- VENDA
-- =========================================================

CREATE TABLE adm.venda (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_cupom INTEGER,
    subtotal DECIMAL(15,2) NOT NULL,
    valor_desconto DECIMAL(15,2) NOT NULL DEFAULT 0,
    valor_frete DECIMAL(15,2) NOT NULL DEFAULT 0,

    -- AQUI O TOTAL CONTINUA.
    -- A venda é um registro histórico já concluído.
    total DECIMAL(15,2) NOT NULL,

    stts_pagamento adm.stts_pagamento_venda_enum
        NOT NULL DEFAULT 'aguardando pagamento',

    stts adm.stts_venda_enum NOT NULL,

    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_venda_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES site.usuario(id),

    CONSTRAINT fk_venda_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id),

    CONSTRAINT ck_venda_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT ck_venda_valor_desconto
        CHECK (valor_desconto >= 0),

    CONSTRAINT ck_venda_valor_frete
        CHECK (valor_frete >= 0),

    CONSTRAINT ck_venda_total
        CHECK (total = subtotal - valor_desconto + valor_frete)
);


-- =========================================================
-- ITEM DA VENDA
-- =========================================================

CREATE TABLE adm.item_venda (
    id SERIAL PRIMARY KEY,
    id_venda INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quant INTEGER NOT NULL,
    preco_unitario DECIMAL(15,2) NOT NULL,

    -- O TOTAL CONTINUA AQUI.
    -- Diferente do carrinho, a venda precisa preservar
    -- os valores históricos daquele momento.
    total DECIMAL(15,2) NOT NULL,

    CONSTRAINT fk_item_venda_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_venda_produto
        FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    CONSTRAINT uk_item_venda_produto
        UNIQUE (id_venda, id_produto),

    CONSTRAINT ck_item_venda_quant
        CHECK (quant > 0),

    CONSTRAINT ck_item_venda_preco
        CHECK (preco_unitario >= 0),

    CONSTRAINT ck_item_venda_total
        CHECK (total = quant * preco_unitario)
);


-- =========================================================
-- PAGAMENTO
-- =========================================================

CREATE TABLE adm.pagamento (
    id SERIAL PRIMARY KEY,
    id_venda INTEGER NOT NULL UNIQUE,
    forma adm.forma_pagamento_enum NOT NULL,

    stts adm.stts_pagamento_enum
        NOT NULL DEFAULT 'aguardando pagamento',

    valor DECIMAL(15,2) NOT NULL,

    -- NOVO:
    -- registra quando o pagamento efetivamente aconteceu.
    -- Pode ser NULL enquanto estiver aguardando.
    data_pagamento TIMESTAMPTZ,

    CONSTRAINT fk_pagamento_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id),

    CONSTRAINT ck_pagamento_valor
        CHECK (valor >= 0)
);


-- =========================================================
-- NOTA FISCAL
-- =========================================================

-- MANTIDA como estava no código original.

CREATE TABLE adm.nota_fiscal (
    id SERIAL PRIMARY KEY,
    numero_nota VARCHAR(9) NOT NULL UNIQUE,
    valor DECIMAL(15,2) NOT NULL,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_venda INTEGER NOT NULL UNIQUE,

    CONSTRAINT fk_nota_fiscal_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id),

    CONSTRAINT ck_nota_fiscal_valor
        CHECK (valor >= 0)
);


-- =========================================================
-- ENTREGA
-- =========================================================

CREATE TABLE adm.entrega (
    id SERIAL PRIMARY KEY,

    stts adm.stts_entrega_enum
        NOT NULL DEFAULT 'aguardando envio',

    criado_em TIMESTAMPTZ
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    data_hora_previsao_entrega TIMESTAMPTZ NOT NULL,
    data_hora_entrega TIMESTAMPTZ,

    id_venda INTEGER NOT NULL UNIQUE,

    -- NOVO:
    -- em vez de repetir rua, número, bairro, cidade etc.,
    -- a entrega referencia um endereço já cadastrado.
    id_endereco INTEGER NOT NULL,

    CONSTRAINT fk_entrega_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id),

    CONSTRAINT fk_entrega_endereco
        FOREIGN KEY (id_endereco)
        REFERENCES site.endereco(id),

    CONSTRAINT ck_entrega_data_hora_entrega
        CHECK (
            data_hora_entrega IS NULL
            OR data_hora_entrega >= criado_em
        )
);


-- =========================================================
-- PLANO CONTAS
-- =========================================================

CREATE TABLE contabil.plano_contas (
    id SERIAL,
    codigo VARCHAR(40) NOT NULL,
    nome_conta VARCHAR(255) NOT NULL,
    tipo_conta contabil.tipo_conta_enum NOT NULL,

    natureza_conta contabil.natureza_conta_enum
        NOT NULL DEFAULT 'devedora',

    CONSTRAINT pk_plano_contas
        PRIMARY KEY (id)
);


-- =========================================================
-- LANÇAMENTOS
-- =========================================================

CREATE TABLE contabil.lancamentos (
    id SERIAL,
    data_lancamento DATE NOT NULL,
    historico VARCHAR(255),

    -- NOVO:
    -- agora sabemos quanto foi movimentado.
    valor DECIMAL(15,2) NOT NULL,

    -- NOVO:
    -- faz a integração da Prática 01 com os pagamentos.
    id_pagamento INTEGER,

    conta_debito_id INTEGER,
    conta_credito_id INTEGER,

    CONSTRAINT pk_lancamentos
        PRIMARY KEY (id),

    -- NOVA FK:
    -- permite descobrir qual pagamento originou
    -- determinado lançamento contábil.
    CONSTRAINT fk_lancamento_pagamento
        FOREIGN KEY (id_pagamento)
        REFERENCES adm.pagamento(id),

    CONSTRAINT fk_conta_debito
        FOREIGN KEY (conta_debito_id)
        REFERENCES contabil.plano_contas(id),

    CONSTRAINT fk_conta_credito
        FOREIGN KEY (conta_credito_id)
        REFERENCES contabil.plano_contas(id),

    CONSTRAINT ck_lancamento_valor
        CHECK (valor > 0)
);