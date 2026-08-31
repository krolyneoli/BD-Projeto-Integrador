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