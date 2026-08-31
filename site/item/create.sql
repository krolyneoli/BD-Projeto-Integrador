CREATE TABLE site.item (
    id SERIAL PRIMARY KEY,
    id_carrinho INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quant INTEGER NOT NULL,
    total DECIMAL(15,2) NOT NULL,

    CONSTRAINT fk_item_carrinho
        FOREIGN KEY (id_carrinho)
        REFERENCES site.carrinho(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    CONSTRAINT ck_item_quant
        CHECK (quant > 0),

    CONSTRAINT ck_item_total
        CHECK (total >= 0),

    CONSTRAINT uk_item_carrinho_produto
        UNIQUE (id_carrinho, id_produto)
);
