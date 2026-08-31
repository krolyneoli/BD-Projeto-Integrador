CREATE TABLE adm.produto_fornecedor (
    id_produto INTEGER NOT NULL,
    id_fornecedor INTEGER NOT NULL,

    PRIMARY KEY (id_produto, id_fornecedor),

    FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    FOREIGN KEY (id_fornecedor)
        REFERENCES adm.fornecedor(id)
);