CREATE TABLE site.endereco (
    id SERIAL PRIMARY KEY,
    rua VARCHAR(100) NOT NULL,
    numero INTEGER NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
	estado VARCHAR(100) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    complemento VARCHAR(100),

	CONSTRAINT ck_usuario_numero
        CHECK (numero > 0)
);