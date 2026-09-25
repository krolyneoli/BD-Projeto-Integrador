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
-- TABELA DE FORNECEDOR
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

    CONSTRAINT chk_fornecedor_tel
        CHECK (length(tel) >= 10),

    CONSTRAINT fk_fornecedor_endereco
        FOREIGN KEY (id_endereco)
        REFERENCES comum.endereco(id)
        ON DELETE RESTRICT
);


-- =========================================================
-- TABELA DE CATEGORIA
-- =========================================================

CREATE TABLE adm.categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);


-- =========================================================
-- TABELA DE CUPOM
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
-- TABELA DE PRODUTO
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
-- TABELA DE FORNECEDORES DO PRODUTO
-- =========================================================

CREATE TABLE adm.produto_fornecedor (
    id_produto INTEGER,
    id_fornecedor INTEGER,

    PRIMARY KEY (id_produto, id_fornecedor),

    CONSTRAINT fk_produto_fornecedor_produto
        FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_produto_fornecedor_fornecedor
        FOREIGN KEY (id_fornecedor)
        REFERENCES adm.fornecedor(id)
        ON DELETE CASCADE
);


-- =========================================================
-- TABELA DE ESTOQUE
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
        REFERENCES adm.produto(id)
         ON DELETE CASCADE
         ON UPDATE CASCADE,

    CONSTRAINT ck_estoque_quant
        CHECK (quant >= 0),

    CONSTRAINT ck_estoque_valor_atencao
        CHECK (valor_atencao >= 0)
);


-- =========================================================
-- TABELA DE VENDA
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
        REFERENCES comum.usuario(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_venda_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id)
        ON DELETE CASCADE,

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
-- TABELA DE ITENS DA VENDA
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
-- TABELA DE PAGAMENTO
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
        REFERENCES adm.venda(id)
        ON DELETE CASCADE,

    CONSTRAINT ck_pagamento_valor
        CHECK (valor >= 0)
        
);


-- =========================================================
-- TABELA DE NOTA FISCAL
-- =========================================================

CREATE TABLE adm.nota_fiscal (
    id SERIAL PRIMARY KEY,
    numero_nota VARCHAR(9) NOT NULL UNIQUE,
    valor DECIMAL(15,2) NOT NULL,
    id_venda INTEGER NOT NULL UNIQUE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_nota_fiscal_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id)
        ON DELETE RESTRICT,

    CONSTRAINT ck_nota_fiscal_valor
        CHECK (valor >= 0)
);


-- =========================================================
-- TABELA DE ENTREGA
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
	estado CHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    complemento VARCHAR(100),

    CONSTRAINT fk_entrega_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id)
         ON DELETE RESTRICT,

    CONSTRAINT ck_entrega_data_hora_entrega
        CHECK (
            data_hora_entrega IS NULL
            OR data_hora_entrega >= criado_em
        )
);


-- =========================================================
-- TABELA DE CUPONS DO USUÁRIO
-- =========================================================

CREATE TABLE adm.usuario_cupom (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_cupom INTEGER NOT NULL,
    utilizado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_cupom_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES comum.usuario(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_usuario_cupom_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id)
        ON DELETE RESTRICT,

    CONSTRAINT uk_usuario_cupom
        UNIQUE (id_usuario, id_cupom)
);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE FORNECEDOR
-- =========================================================

INSERT INTO adm.fornecedor (nome, nome_social, nome_fantasia, email, tel, documento, id_endereco) VALUES
    ('Distribuidora de Farinhas Ltda', NULL, 'FarinhasBR', 'contato@farinhasbr.com', '(35) 3435-1000', '12.345.678/0001-90', 1),
    ('Laticínios Vale Verde', NULL, 'Vale Verde', 'vendas@valeverde.com', '(35) 3435-2000', '23.456.789/0001-01', 2),
    ('Chocolates & Cia', NULL, 'ChocoCia', 'comercial@chococia.com', '(35) 3435-3000', '34.567.890/0001-12', 3),
    ('Embalagens Sul Minas', NULL, 'Sul Minas Embalagens', 'contato@sulminas.com', '(35) 3435-4000', '45.678.901/0001-23', 4);

    
-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE CATEGORIA
-- =========================================================

INSERT INTO adm.categoria (nome) VALUES
    ('Pães'),
    ('Bolos'),
    ('Doces'),
    ('Salgados'),
    ('Bebidas'),
    ('Cafés e Chás'),
    ('Tortas'),
    ('Biscoitos e Cookies');


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE CUPOM
-- =========================================================

INSERT INTO adm.cupom (nome, tipo_desconto, valor, data_hora_inicio, data_hora_fim, valor_minimo, ativo) VALUES
    ('BEMVINDO10', 'percentual', 10.00, '2026-01-01 00:00:00-03', '2026-12-31 23:59:59-03', 30.00, TRUE),
    ('FRETEGRATIS', 'fixo', 15.00, '2026-03-01 00:00:00-03', '2026-03-31 23:59:59-03', 50.00, TRUE),
    ('PADARIA20', 'percentual', 20.00, '2026-02-01 00:00:00-03', '2026-02-28 23:59:59-03', 0.00, TRUE),
    ('BLACKFRIDAY', 'percentual', 50.00, '2026-11-25 00:00:00-03', '2026-11-30 23:59:59-03', 100.00, FALSE),
    ('DOCE5', 'fixo', 5.00, '2026-01-01 00:00:00-03', '2026-06-30 23:59:59-03', 20.00, TRUE);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE PRODUTO
-- =========================================================

INSERT INTO adm.produto (nome, descricao, preco, id_categoria, preco_promocional, ativo) VALUES
    ('Pão Francês (kg)', 'Pão francês tradicional, crocante por fora e macio por dentro', 18.90, 1, NULL, TRUE),
    ('Pão de Queijo (dúzia)', 'Pão de queijo mineiro tradicional', 22.00, 1, 19.90, TRUE),
    ('Bolo de Cenoura com Chocolate', 'Bolo de cenoura com cobertura de chocolate', 35.00, 2, NULL, TRUE),
    ('Brigadeiro Gourmet (unidade)', 'Brigadeiro artesanal feito com chocolate belga', 4.50, 3, NULL, TRUE),
    ('Coxinha de Frango', 'Coxinha recheada com frango desfiado', 8.00, 4, 6.90, TRUE),
    ('Café Expresso', 'Café expresso tradicional', 6.00, 6, NULL, TRUE),
    ('Torta de Limão', 'Torta de limão com merengue', 45.00, 7, 39.90, TRUE),
    ('Cookie de Chocolate', 'Cookie artesanal com gotas de chocolate', 7.50, 8, NULL, FALSE);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE FORNECEDORES DO PRODUTO
-- =========================================================

INSERT INTO adm.produto_fornecedor (id_produto, id_fornecedor) VALUES
    (1, 1),
    (2, 1),
    (2, 2),
    (3, 2),
    (3, 3),
    (4, 3),
    (7, 3),
    (8, 3);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE ESTOQUE
-- =========================================================

INSERT INTO adm.estoque (id_produto, quant, stts, valor_atencao) VALUES
    (1, 150, 'disponivel', 20),
    (2, 40, 'disponivel', 15),
    (3, 8, 'atencao', 10),
    (4, 200, 'disponivel', 30),
    (5, 3, 'critico', 10),
    (6, 500, 'disponivel', 50),
    (7, 0, 'indisponivel', 5),
    (8, 25, 'disponivel', 10);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE VENDA
-- =========================================================

INSERT INTO adm.venda (id_usuario, id_cupom, subtotal, valor_desconto, valor_frete, total, stts_pagamento, stts) VALUES
    (1, NULL, 100.00, 0.00,  10.00, 110.00, 'pago', 'concluída'),
    (2, 1, 200.00, 20.00, 15.00, 195.00, 'aguardando pagamento', 'em preparação'),
    (3, 3, 150.00, 30.00, 0.00,  120.00, 'pago', 'concluída'),
    (1, NULL, 80.00,  0.00,  12.00, 92.00,  'aguardando pagamento', 'cancelada'),
    (5, 5, 300.00, 5.00,  20.00, 315.00, 'pago', 'concluída');


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE ITENS DA VENDA
-- =========================================================

INSERT INTO adm.item_venda (id_venda, id_produto, quant, preco_unitario, total) VALUES
    (1, 1, 5, 18.90, 94.50),
    (1, 2, 1, 19.90, 19.90),
    (2, 3, 2, 35.00, 70.00),
    (2, 6, 3, 6.00, 18.00),
    (3, 4, 10, 4.50, 45.00),
    (3, 7, 1, 39.90, 39.90),
    (4, 5, 4, 6.90, 27.60),
    (5, 8, 6, 7.50, 45.00);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE PAGAMENTO
-- =========================================================

INSERT INTO adm.pagamento (id_venda, forma, stts, valor, data_hora_pagamento) VALUES
    (1, 'pix', 'pago', 110.00, '2026-01-05 14:30:00-03'),
    (2, 'credito', 'aguardando pagamento', 195.00, NULL),
    (3, 'debito', 'pago', 120.00, '2026-02-10 09:15:00-03'),
    (4, 'pix', 'cancelado', 92.00, NULL),
    (5, 'credito', 'pago', 315.00, '2026-03-20 18:45:00-03');


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE NOTA FISCAL
-- =========================================================

INSERT INTO adm.nota_fiscal (numero_nota, valor, id_venda) VALUES
    ('000000001', 110.00, 1),
    ('000000002', 195.00, 2),
    ('000000003', 120.00, 3),
    ('000000004', 92.00, 4),
    ('000000005', 315.00, 5);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE ENTREGA
-- =========================================================

INSERT INTO adm.entrega (
    stts,
    data_hora_previsao_entrega,
    data_hora_entrega,
    id_venda,
    rua,
    numero,
    bairro,
    cidade,
    estado,
    cep,
    complemento
) VALUES
    (
        'entregue',
        '2026-09-28 14:00:00',
        '2026-09-28 13:45:00',
        1,
        'Rua das Flores',
        199,
        'Centro',
        'Extrema',
        'MG',
        '37640-000',
        'Apto 302'
    ),
    (
        'em transporte',
        '2026-09-03 16:00:00',
        NULL,
        2,
        'Avenida Brasil',
        553,
        'Jardim América',
        'Extrema',
        'MG',
        '37640-010',
        NULL
    ),
    (
        'entregue',
        '2026-09-29 12:00:00',
        '2026-09-29 11:50:00',
        3,
        'Rua São José',
        89,
        'Vila Nova',
        'Camanducaia',
        'MG',
        '37650-000',
        'Casa 2'
    ),
    (
        'cancelada',
        '2026-09-05 15:00:00',
        NULL,
        4,
        'Rua XV de Novembro',
        500,
        'Centro',
        'Itapeva',
        'SP',
        '18400-000',
        NULL
    ),
    (
        'entregue',
        '2026-09-30 17:00:00',
        '2026-09-30 16:40:00',
        5,
        'Rua das Palmeiras',
        10,
        'Bela Vista',
        'Extrema',
        'RJ',
        '37640-020',
        'Fundos'
    );  


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE CUPONS DO USUÁRIO 
-- =========================================================

INSERT INTO adm.usuario_cupom (id_usuario, id_cupom)
VALUES
    (1, 1), -- Maria → BEMVINDO10
    (2, 2), -- João → FRETEGRATIS
    (3, 3), -- Ana → PADARIA20
    (4, 1), -- Pedro → BEMVINDO10
    (5, 2), -- Beatriz → FRETEGRATIS
    (6, 4), -- Karolyne → BLACKFRIDAY
    (7, 5), -- Gabriel → DOCE5
    (8, 1), -- Matheus → BEMVINDO10
    (9, 3), -- Lara → PADARIA20
    (10, 5); -- Camily → DOCE5
