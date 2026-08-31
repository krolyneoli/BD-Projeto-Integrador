CREATE TABLE adm.entrega (
    id SERIAL PRIMARY KEY,
    stts adm.stts_entrega_enum NOT NULL DEFAULT 'aguardando envio',
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_hora_previsao_entrega TIMESTAMPTZ NOT NULL,
    data_hora_entrega TIMESTAMPTZ,
    id_venda INTEGER NOT NULL UNIQUE,
	rua VARCHAR(100) NOT NULL,
    numero INTEGER NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
	estado VARCHAR(100) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    complemento VARCHAR(100),

    CONSTRAINT fk_entrega_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id),

	CONSTRAINT ck_entrega_numero
        CHECK (numero > 0),

	CONSTRAINT ck_entrega_data_hora_entrega
        CHECK (
		    data_hora_entrega IS NULL
		    OR data_hora_entrega >= criado_em
		)
);