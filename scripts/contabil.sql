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
    codigo VARCHAR(40) NOT NULL UNIQUE,
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
    valor NUMERIC(14,2) NOT NULL,
    id_pagamento INTEGER,
    conta_debito_id INTEGER NOT NULL,
    conta_credito_id INTEGER NOT NULL,

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
    ('1.1.01', 'Caixa',                          'ativo',              'devedora'),
    ('1.1.02', 'Bancos - Conta Movimento',       'ativo',              'devedora'),
    ('1.1.04', 'Estoque de Mercadorias',         'ativo',              'devedora'),
    ('2.1.01', 'Fornecedores a Pagar',           'passivo',            'credora'),
    ('3.1.01', 'Capital Social',                 'patrimônio líquido', 'credora'),
    ('4.1.01', 'Receita de Vendas',              'receita',            'credora'),
    ('5.1.01', 'Custo das Mercadorias Vendidas', 'despesa',            'devedora'),
    ('5.1.03', 'Despesas com Aluguel',           'despesa',            'devedora');


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE LANÇAMENTOS (anteriores ao trigger)
-- Débito em Bancos - Conta Movimento, crédito em Receita de Vendas.
-- Não entram no cálculo dos saldos, que partem de zero.
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
    ('2026-01-05', 'Venda realizada - pagamento via PIX',     110.00, 1,
        (SELECT id FROM contabil.plano_contas WHERE codigo = '1.1.02'),
        (SELECT id FROM contabil.plano_contas WHERE codigo = '4.1.01')),
    ('2026-02-01', 'Venda realizada - pagamento aguardando',  195.00, 2,
        (SELECT id FROM contabil.plano_contas WHERE codigo = '1.1.02'),
        (SELECT id FROM contabil.plano_contas WHERE codigo = '4.1.01')),
    ('2026-02-10', 'Venda realizada - pagamento via débito',  120.00, 3,
        (SELECT id FROM contabil.plano_contas WHERE codigo = '1.1.02'),
        (SELECT id FROM contabil.plano_contas WHERE codigo = '4.1.01')),
    ('2026-02-01', 'Venda cancelada - pagamento via PIX',      92.00, 4,
        (SELECT id FROM contabil.plano_contas WHERE codigo = '1.1.02'),
        (SELECT id FROM contabil.plano_contas WHERE codigo = '4.1.01')),
    ('2026-03-20', 'Venda realizada - pagamento via crédito', 315.00, 5,
        (SELECT id FROM contabil.plano_contas WHERE codigo = '1.1.02'),
        (SELECT id FROM contabil.plano_contas WHERE codigo = '4.1.01'));


-- =========================================================
-- PRÁTICA 05 - TRIGGER E FUNÇÃO DE BANCO
-- =========================================================

-- 1. Coluna valor: já criada em contabil.lancamentos como
--    NUMERIC(14,2) com CHECK (valor > 0) (ck_lancamento_valor).

-- 2. Tabela de saldos por conta
CREATE TABLE contabil.saldo_contas (
    id SERIAL,
    conta_id INTEGER NOT NULL,
    saldo NUMERIC(14,2) NOT NULL DEFAULT 0,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT now(),

    CONSTRAINT pk_saldo_contas
        PRIMARY KEY (id),

    CONSTRAINT fk_saldo_conta
        FOREIGN KEY (conta_id)
        REFERENCES contabil.plano_contas(id)
        ON DELETE RESTRICT
);

-- 3. Carga inicial: uma linha com saldo zero para cada conta
INSERT INTO contabil.saldo_contas (conta_id)
SELECT id
FROM contabil.plano_contas;

SELECT * FROM contabil.saldo_contas;

-- 4. Função de trigger que atualiza o saldo das contas do lançamento
CREATE OR REPLACE FUNCTION contabil.fn_atualiza_saldo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Sem valor não há o que somar ou subtrair
    IF NEW.valor IS NULL THEN
        RETURN NEW;
    END IF;

    -- Conta de débito: devedora aumenta, credora diminui
    IF NEW.conta_debito_id IS NOT NULL THEN
        UPDATE contabil.saldo_contas AS sc
        SET saldo = sc.saldo + CASE
                WHEN pc.natureza_conta = 'devedora' THEN NEW.valor
                ELSE -NEW.valor
            END,
            data_atualizacao = now()
        FROM contabil.plano_contas AS pc
        WHERE sc.conta_id = NEW.conta_debito_id
          AND pc.id = NEW.conta_debito_id;
    END IF;

    -- Conta de crédito: credora aumenta, devedora diminui
    IF NEW.conta_credito_id IS NOT NULL THEN
        UPDATE contabil.saldo_contas AS sc
        SET saldo = sc.saldo + CASE
                WHEN pc.natureza_conta = 'credora' THEN NEW.valor
                ELSE -NEW.valor
            END,
            data_atualizacao = now()
        FROM contabil.plano_contas AS pc
        WHERE sc.conta_id = NEW.conta_credito_id
          AND pc.id = NEW.conta_credito_id;
    END IF;

    RETURN NEW;
END;
$$;

-- 5. Trigger disparado após cada lançamento inserido
CREATE TRIGGER trg_atualiza_saldo
AFTER INSERT ON contabil.lancamentos
FOR EACH ROW
EXECUTE FUNCTION contabil.fn_atualiza_saldo();

-- 6. Lançamentos de teste (ids das contas obtidos por subconsulta)
INSERT INTO contabil.lancamentos (
    data_lancamento,
    historico,
    valor,
    conta_debito_id,
    conta_credito_id
)
VALUES
    ('2026-04-01', 'Aporte de capital dos sócios', 30000.00,
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Bancos - Conta Movimento'),
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Capital Social')),
    ('2026-04-02', 'Compra de mercadorias à vista', 8000.00,
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Estoque de Mercadorias'),
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Bancos - Conta Movimento')),
    ('2026-04-03', 'Venda de mercadorias à vista', 5000.00,
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Caixa'),
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Receita de Vendas')),
    ('2026-04-03', 'Baixa do custo da mercadoria vendida', 3000.00,
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Custo das Mercadorias Vendidas'),
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Estoque de Mercadorias')),
    ('2026-04-05', 'Pagamento de aluguel do mês', 1500.00,
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Despesas com Aluguel'),
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Bancos - Conta Movimento')),
    ('2026-04-06', 'Compra de mercadorias a prazo', 4000.00,
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Estoque de Mercadorias'),
        (SELECT id FROM contabil.plano_contas WHERE nome_conta = 'Fornecedores a Pagar'));

-- 7. Saldo de cada conta, ordenado pelo código
SELECT
    pc.codigo,
    pc.nome_conta,
    pc.natureza_conta,
    sc.saldo
FROM contabil.plano_contas pc
INNER JOIN contabil.saldo_contas sc
    ON sc.conta_id = pc.id
ORDER BY pc.codigo;

-- 8. Soma dos saldos por natureza da conta
SELECT
    pc.natureza_conta,
    SUM(sc.saldo) AS total_saldo
FROM contabil.plano_contas pc
INNER JOIN contabil.saldo_contas sc
    ON sc.conta_id = pc.id
GROUP BY pc.natureza_conta;

-- Por que os dois totais são iguais (R$ 39.000,00)?
-- Pelo método das partidas dobradas, todo lançamento debita uma conta e
-- credita outra pelo mesmo valor. Uma conta devedora sobe quando debitada
-- e uma credora sobe quando creditada; ou seja, cada lançamento soma o
-- valor uma vez ao total das devedoras e uma vez ao total das credoras
-- (ou subtrai dos dois, quando a conta tem o movimento contrário).
-- Assim, a diferença entre os totais permanece sempre zero.

-- 9. E se um lançamento for excluído ou alterado?
-- O trigger só dispara em INSERT. Se um lançamento for excluído ou tiver
-- valor/contas alterados, o saldo_contas continua com o efeito do lançamento
-- antigo e fica incorreto (diferente da soma real dos lançamentos).
-- Para mantê-lo correto seria preciso:
--   * um trigger AFTER DELETE que desfaz o efeito de OLD (inverte a regra);
--   * um trigger AFTER UPDATE que desfaz o efeito de OLD e aplica o de NEW;
--   * ou recalcular o saldo a partir de todos os lançamentos.
