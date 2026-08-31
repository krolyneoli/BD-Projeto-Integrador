CREATE TABLE adm.estoque (
    id SERIAL PRIMARY KEY,
    id_produto INTEGER NOT NULL UNIQUE,
    quant INTEGER NOT NULL DEFAULT 0,
    stts adm.stts_estoque_enum NOT NULL DEFAULT 'disponivel',
    valor_atencao INTEGER NOT NULL DEFAULT 5,
    editado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_estoque_produto
        FOREIGN KEY (id_produto)
        REFERENCES adm.produto(id),

    CONSTRAINT ck_estoque_quant
        CHECK (quant >= 0),

    CONSTRAINT ck_estoque_valor_atencao
        CHECK (valor_atencao >= 0)
);