CREATE TABLE contabil.lancamentos(
	id SERIAL,
	data_lancamento DATE NOT NULL,
	historico VARCHAR(255),
	conta_debito_id INTEGER,
	conta_credito_id INTEGER,
	
	CONSTRAINT pk_lancamentos
		PRIMARY KEY(id),
	
	CONSTRAINT fk_conta_debito
		FOREIGN KEY(conta_debito_id)
		REFERENCES contabil.plano_contas(id),
		
	CONSTRAINT fk_conta_credito
		FOREIGN KEY(conta_credito_id)
		REFERENCES contabil.plano_contas(id)
);