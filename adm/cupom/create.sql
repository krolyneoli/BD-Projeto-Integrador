CREATE TABLE adm.cupom (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
	tipo_desconto adm.tipo_desconto_cupom_enum NOT NULL,
    valor DECIMAL(15,2) NOT NULL,
    data_inicio TIMESTAMPTZ NOT NULL,
    data_fim TIMESTAMPTZ NOT NULL,
    valor_minimo DECIMAL(15,2) DEFAULT 0,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT ck_cupom_valor
        CHECK (
            valor >= 0
            AND (
                (tipo_desconto = 'percentual' AND valor <= 100)
                OR
                (tipo_desconto = 'fixo')
            )
        ),

	CONSTRAINT ck_cupom_valor_minimo
        CHECK (valor_minimo >= 0),

	CONSTRAINT ck_cupom_data_fim_data_inicio
        CHECK (data_fim > data_inicio)
);