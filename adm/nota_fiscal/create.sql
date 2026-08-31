CREATE TABLE adm.nota_fiscal (
    id SERIAL PRIMARY KEY,
    numero_nota VARCHAR(9) NOT NULL UNIQUE,
    valor DECIMAL(15,2) NOT NULL,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_venda INTEGER NOT NULL UNIQUE,

    CONSTRAINT fk_nota_fiscal_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id),

    CONSTRAINT ck_nota_fiscal_valor
        CHECK (valor >= 0)
);