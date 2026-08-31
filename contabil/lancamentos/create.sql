CREATE TABLE contabil.lancamentos (
    id SERIAL,
    data_lancamento DATE NOT NULL,
    historico VARCHAR(255),

    valor DECIMAL(15,2) NOT NULL,
    id_pagamento INTEGER,

    conta_debito_id INTEGER NOT NULL,
    conta_credito_id INTEGER NOT NULL,

    CONSTRAINT pk_lancamentos
        PRIMARY KEY (id),

    CONSTRAINT fk_lancamento_pagamento
        FOREIGN KEY (id_pagamento)
        REFERENCES adm.pagamento(id),

    CONSTRAINT fk_conta_debito
        FOREIGN KEY (conta_debito_id)
        REFERENCES contabil.plano_contas(id),

    CONSTRAINT fk_conta_credito
        FOREIGN KEY (conta_credito_id)
        REFERENCES contabil.plano_contas(id),

    CONSTRAINT ck_lancamento_valor
        CHECK (valor > 0)
);