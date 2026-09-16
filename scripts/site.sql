-- =========================================================
-- SCHEMA
-- =========================================================

CREATE SCHEMA site;


-- =========================================================
-- ENUM
-- =========================================================

CREATE TYPE site.tipo_usuario_enum AS ENUM (
    'admin',
    'cliente'
);


-- =========================================================
-- ENDEREÇO
-- =========================================================

CREATE TABLE site.endereco (
    id SERIAL PRIMARY KEY,
    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
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
    tipo site.tipo_usuario_enum NOT NULL DEFAULT 'cliente',
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
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
-- CARRINHO
-- =========================================================

CREATE TABLE site.carrinho (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_cupom INTEGER,

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

CREATE TABLE site.item (
    id SERIAL PRIMARY KEY,
    id_carrinho INTEGER NOT NULL UNIQUE,
    id_produto INTEGER NOT NULL,
    quant INTEGER NOT NULL,

    CONSTRAINT fk_item_carrinho
        FOREIGN KEY (id_carrinho)
        REFERENCES site.carrinho(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    CONSTRAINT ck_item_quant
        CHECK (quant > 0),

    CONSTRAINT uk_item_produto
        UNIQUE (id_carrinho, id_produto)
);


-- =========================================================
-- CUPONS DO USUÁRIO
-- =========================================================

CREATE TABLE site.usuario_cupom (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_cupom INTEGER NOT NULL,
    utilizado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_cupom_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES site.usuario(id),

    CONSTRAINT fk_usuario_cupom_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id),

    CONSTRAINT uk_usuario_cupom
        UNIQUE (id_usuario, id_cupom)
);
