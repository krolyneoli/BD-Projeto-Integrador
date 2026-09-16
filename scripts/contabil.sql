-- =========================================================
-- SCHEMA
-- =========================================================

CREATE SCHEMA contabil;


-- =========================================================
-- ENUMS
-- =========================================================

CREATE TYPE contabil.tipo_conta_enum AS ENUM (
    'ativo',
    'passivo',
    'patrimônio líquido',
    'receita',
    'despesa'
);

CREATE TYPE contabil.natureza_conta_enum AS ENUM (
    'devedora',
    'credora'
);


-- =========================================================
-- PLANO CONTAS
-- =========================================================

CREATE TABLE contabil.plano_contas (
    id SERIAL,
    codigo VARCHAR(40) NOT NULL,
    nome_conta VARCHAR(255) NOT NULL,
    tipo_conta contabil.tipo_conta_enum NOT NULL,
    natureza_conta contabil.natureza_conta_enum NOT NULL DEFAULT 'devedora',

    CONSTRAINT pk_plano_contas
        PRIMARY KEY (id)
);


-- =========================================================
-- LANÇAMENTOS
-- =========================================================

CREATE TABLE contabil.lancamentos (
    id SERIAL,
    data_lancamento DATE NOT NULL,
    historico VARCHAR(255),
    valor DECIMAL(15,2) NOT NULL,
    id_pagamento INTEGER,
    conta_debito_id INTEGER,
    conta_credito_id INTEGER,

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
