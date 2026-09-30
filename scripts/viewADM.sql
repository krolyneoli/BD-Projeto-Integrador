-- =========================================================
-- VIEW - SCHEMA ADM
-- =========================================================
-- =========================================================
-- comando para testar VIEW: 
-- SELECT * FROM tabela.(nome da view);
--EX: SELECT * FROM adm.vw_produtos_ativos;
-- =========================================================


-- =========================================================
-- PRODUTOS ATIVOS
-- =========================================================

CREATE OR REPLACE VIEW adm.vw_produtos_ativos AS
SELECT
    id,
    nome,
    descricao,
    preco,
    preco_promocional
FROM adm.produto
WHERE ativo = TRUE;


-- =========================================================
-- CATEGORIAS E SEUS PRODUTOS
-- =========================================================

CREATE OR REPLACE VIEW adm.vw_categorias_produtos AS
SELECT
    p.id AS id_produto,
    p.nome AS produto,
    c.id AS id_categoria,
    c.nome AS categoria,
    p.preco
FROM adm.produto p
INNER JOIN adm.categoria c
    ON p.id_categoria = c.id;


-- =========================================================
-- PRODUTOS E ESTOQUES
-- =========================================================

CREATE OR REPLACE VIEW adm.vw_produtos_estoque AS
SELECT
    p.id AS id_produto,
    p.nome AS produto,
    p.preco,
    e.quant AS quantidade_estoque,
    e.stts AS status_estoque,
    e.valor_atencao
FROM adm.produto p
INNER JOIN adm.estoque e
    ON p.id = e.id_produto;


-- =========================================================
-- FORNECEDORES E SEUS PRODUTOS
-- =========================================================

CREATE OR REPLACE VIEW adm.vw_fornecedores_produtos AS
SELECT
    p.id AS id_produto,
    p.nome AS produto,
    f.id AS id_fornecedor,
    f.nome_fantasia AS fornecedor,
    f.email,
    f.tel
FROM adm.produto_fornecedor pf
INNER JOIN adm.produto p
    ON pf.id_produto = p.id
INNER JOIN adm.fornecedor f
    ON pf.id_fornecedor = f.id;


-- =========================================================
-- PAGAMENTOS DAS VENDAS
-- =========================================================

CREATE OR REPLACE VIEW adm.vw_pagamentos_vendas AS
SELECT
    p.id AS id_pagamento,
    p.id_venda,
    p.forma AS forma_pagamento,
    p.stts AS status_pagamento,
    p.valor,
    p.data_hora_pagamento,
    v.stts AS status_venda,
    v.total AS total_venda,
    v.criado_em
FROM adm.pagamento p
INNER JOIN adm.venda v
    ON p.id_venda = v.id;
    