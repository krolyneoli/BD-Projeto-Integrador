CREATE TABLE adm.venda (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
	id_cupom INTEGER,
    subtotal DECIMAL(15,2) NOT NULL,
	valor_desconto DECIMAL(15,2) NOT NULL DEFAULT 0,
	valor_frete DECIMAL(15,2) NOT NULL DEFAULT 0,
	total DECIMAL(15,2) NOT NULL,
	stts_pagamento adm.stts_pagamento_venda_enum NOT NULL DEFAULT 'aguardando pagamento',
    stts adm.stts_venda_enum NOT NULL,
	criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_venda_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES site.usuario(id),

	CONSTRAINT fk_venda_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id),

	CONSTRAINT ck_venda_subtotal
        CHECK (subtotal >= 0),

	CONSTRAINT ck_venda_valor_desconto
        CHECK (valor_desconto >= 0),

	CONSTRAINT ck_venda_valor_frete
        CHECK (valor_frete >= 0),

	CONSTRAINT ck_venda_total
		CHECK (total = subtotal - valor_desconto + valor_frete)
);
