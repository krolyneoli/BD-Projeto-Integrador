CREATE TABLE contabil.plano_contas(
	id SERIAL,
	codigo VARCHAR(40) NOT NULL,
	nome_conta VARCHAR(255) NOT NULL,
	tipo_conta contabil.tipo_conta_enum NOT NULL,
	natureza_conta contabil.natureza_conta_enum NOT NULL DEFAULT 'devedora',
	
	CONSTRAINT pk_plano_contas
		PRIMARY KEY(id)
);