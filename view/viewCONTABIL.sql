-- =========================================================
-- VIEW - SCHEMA comum.sql
-- =========================================================


-- =========================================================
-- Plano de contas
-- =========================================================

CREATE OR REPLACE VIEW contabil.vw_plano_contas AS
SELECT
    id,
    codigo,
    nome_conta,
    tipo_conta,
    natureza_conta
FROM contabil.plano_contas;



-- =========================================================
-- Contas de ativo
-- =========================================================

CREATE OR REPLACE VIEW contabil.vw_contas_ativo AS
SELECT
    id,
    codigo,
    nome_conta,
    natureza_conta
FROM contabil.plano_contas
WHERE tipo_conta = 'ativo';




-- =========================================================
-- Lançamentos por data
-- =========================================================
CREATE OR REPLACE VIEW contabil.vw_lancamentos_2026 AS
SELECT
    id,
    data_lancamento,
    historico,
    valor,
    id_pagamento
FROM contabil.lancamentos
WHERE data_lancamento >= '2026-01-01'
  AND data_lancamento < '2027-01-01';




-- =========================================================
-- Lançamentos com pagamento
-- =========================================================
  CREATE OR REPLACE VIEW contabil.vw_lancamentos_pagamentos AS
SELECT
    l.id AS id_lancamento,
    l.data_lancamento,
    l.historico,
    l.valor,
    p.id AS id_pagamento,
    p.forma AS forma_pagamento,
    p.stts AS status_pagamento
FROM contabil.lancamentos l
INNER JOIN adm.pagamento p
    ON l.id_pagamento = p.id;