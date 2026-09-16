-- =========================================================
-- SCHEMA
-- =========================================================

CREATE SCHEMA adm;


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
    data_hora_inicio TIMESTAMPTZ NOT NULL,
    data_hora_fim TIMESTAMPTZ NOT NULL,
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

    CONSTRAINT ck_cupom_data_hora_fim_data_hora_inicio
        CHECK (data_hora_fim > data_hora_inicio)
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
    id_produto INTEGER,
    id_fornecedor INTEGER,

    PRIMARY KEY (id_produto, id_fornecedor),

    CONSTRAINT fk_produto_fornecedor_produto
        FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    CONSTRAINT fk_produto_fornecedor_fornecedor
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
-- VENDA
-- =========================================================

CREATE TABLE adm.venda (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_cupom INTEGER,
    subtotal DECIMAL(15,2) NOT NULL,
    valor_desconto DECIMAL(15,2) NOT NULL DEFAULT 0,
    valor_frete DECIMAL(15,2) NOT NULL DEFAULT 0,
    total DECIMAL(15,2) NOT NULL,
    stts_pagamento adm.stts_pagamento_venda_enum NOT NULL DEFAULT 'aguardando pagamento',
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
-- ITENS DA VENDA
-- =========================================================

CREATE TABLE adm.item_venda (
    id SERIAL PRIMARY KEY,
    id_venda INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quant INTEGER NOT NULL,
    preco_unitario DECIMAL(15,2) NOT NULL,
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
    stts adm.stts_pagamento_enum NOT NULL DEFAULT 'aguardando pagamento',
    valor DECIMAL(15,2) NOT NULL,
    data_hora_pagamento TIMESTAMPTZ,

    CONSTRAINT fk_pagamento_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id),

    CONSTRAINT ck_pagamento_valor
        CHECK (valor >= 0)
);


-- =========================================================
-- NOTA FISCAL
-- =========================================================

CREATE TABLE adm.nota_fiscal (
    id SERIAL PRIMARY KEY,
    numero_nota VARCHAR(9) NOT NULL UNIQUE,
    valor DECIMAL(15,2) NOT NULL,
    id_venda INTEGER NOT NULL UNIQUE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

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
    stts adm.stts_entrega_enum NOT NULL DEFAULT 'aguardando envio',
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_hora_previsao_entrega TIMESTAMPTZ NOT NULL,
    data_hora_entrega TIMESTAMPTZ,
    id_venda INTEGER NOT NULL UNIQUE,
	rua VARCHAR(100) NOT NULL,
    numero VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
	estado VARCHAR(100) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    complemento VARCHAR(100),

    CONSTRAINT fk_entrega_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id),

    CONSTRAINT ck_entrega_data_hora_entrega
        CHECK (
            data_hora_entrega IS NULL
            OR data_hora_entrega >= criado_em
        )
);
