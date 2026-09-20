-- =========================================================
-- SCHEMAS
-- =========================================================

CREATE SCHEMA site;


-- =========================================================
-- TABELA DE CARRINHO
-- =========================================================

CREATE TABLE site.carrinho (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL UNIQUE,
    id_cupom INTEGER,

    CONSTRAINT fk_carrinho_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES comum.usuario(id),

    CONSTRAINT fk_carrinho_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id)
);


-- =========================================================
-- TABELA DE ITENS DO CARRINHO
-- =========================================================

CREATE TABLE site.item (
    id SERIAL PRIMARY KEY,
    id_carrinho INTEGER NOT NULL,
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
-- INSERÇÃO DE DADOS NA TABELA DE CARRINHO
-- =========================================================

INSERT INTO site.carrinho (id_usuario, id_cupom) VALUES
    (1, 1),
    (2, NULL),
    (3, 3),
    (4, NULL),
    (5, 2),
    (6, NULL),
    (7, 5),
    (8, NULL),
    (9, NULL),
    (10, NULL);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE ITENS DO CARRINHO
-- =========================================================

INSERT INTO site.item (id_carrinho, id_produto, quant)
VALUES
    (1, 1, 2),
    (2, 2, 1),
    (3, 3, 1),
    (4, 4, 3),
    (5, 5, 2),
    (6, 6, 1),
    (7, 7, 1),
    (8, 8, 2),
    (9, 1, 1),
    (10, 2, 2);
