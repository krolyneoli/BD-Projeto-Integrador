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
-- TABELA DE PLANO DE CONTAS
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
-- TABELA DE LANÇAMENTOS
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
        REFERENCES adm.pagamento(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_conta_debito
        FOREIGN KEY (conta_debito_id)
        REFERENCES contabil.plano_contas(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_conta_credito
        FOREIGN KEY (conta_credito_id)
        REFERENCES contabil.plano_contas(id)
        ON DELETE RESTRICT,

    CONSTRAINT ck_lancamento_valor
        CHECK (valor > 0)
);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE PLANO DE CONTAS
-- =========================================================

INSERT INTO contabil.plano_contas (
    codigo,
    nome_conta,
    tipo_conta,
    natureza_conta
)
VALUES
    ('1.1', 'Caixa/Banco', 'ativo', 'devedora'),
    ('4.1', 'Receita de Vendas', 'receita', 'credora');

    
-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE LANÇAMENTOS
-- =========================================================

INSERT INTO contabil.lancamentos (
    data_lancamento,
    historico,
    valor,
    id_pagamento,
    conta_debito_id,
    conta_credito_id
)
VALUES
    -- Pagamento 1 → Caixa/Banco (débito) → Receita de Vendas (crédito)
    (
        '2026-01-05',
        'Venda realizada - pagamento via PIX',
        110.00,
        1,
        1,
        2
    ),
    -- Pagamento 2 → Caixa/Banco (débito) → Receita de Vendas (crédito)
    (
        '2026-02-01',
        'Venda realizada - pagamento aguardando',
        195.00,
        2,
        1,
        2
    ),
    -- Pagamento 3 → Caixa/Banco (débito) → Receita de Vendas (crédito)
    (
        '2026-02-10',
        'Venda realizada - pagamento via débito',
        120.00,
        3,
        1,
        2
    ),
    -- Pagamento 4 → Caixa/Banco (débito) → Receita de Vendas (crédito)
    (
        '2026-02-01',
        'Venda cancelada - pagamento via PIX',
        92.00,
        4,
        1,
        2
    ),
    -- Pagamento 5 → Caixa/Banco (débito) → Receita de Vendas (crédito)
    (
        '2026-03-20',
        'Venda realizada - pagamento via crédito',
        315.00,
        5,
        1,
        2
    );
	
