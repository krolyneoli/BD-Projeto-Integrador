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