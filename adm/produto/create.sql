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