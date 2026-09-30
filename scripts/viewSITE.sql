-- =========================================================
-- VIEWS - Schema - site
-- =========================================================


-- =========================================================
-- CARRINHOS
-- =========================================================

CREATE OR REPLACE VIEW site.vw_carrinhos AS
SELECT
    ca.id,
    ca.id_usuario,
    u.nome AS nome_usuario,
    ca.id_cupom,
    cp.nome AS nome_cupom,
    cp.tipo_desconto,
    cp.valor
FROM site.carrinho ca
INNER JOIN comum.usuario u
    ON ca.id_usuario = u.id
LEFT JOIN adm.cupom cp
    ON ca.id_cupom = cp.id;


-- =========================================================
-- ITENS DOS CARRINHOS
-- =========================================================

CREATE OR REPLACE VIEW site.vw_itens_carrinho AS
SELECT
    id,
    id_carrinho,
    id_produto,
    quant
FROM site.item;


-- =========================================================
-- CARRINHOS COM CUPOM
-- =========================================================

CREATE OR REPLACE VIEW site.vw_carrinhos_com_cupom AS
SELECT
    id,
    id_usuario,
    id_cupom
FROM site.carrinho
WHERE id_cupom IS NOT NULL;


-- =========================================================
-- ITENS COM QUANTIDADE MAIOR QUE 1
-- =========================================================

CREATE OR REPLACE VIEW site.vw_itens_quantidade_maior_um AS
SELECT
    id AS id_item,
    id_carrinho,
    id_produto,
    quant
FROM site.item
WHERE quant > 1;


-- =========================================================
-- CARRINHOS COM DADOS DO USUARIO
-- =========================================================

CREATE OR REPLACE VIEW site.vw_carrinhos_usuarios AS
SELECT
    c.id AS id_carrinho,
    c.id_usuario,
    u.nome AS usuario,
    u.email,
    u.tipo,
    c.id_cupom
FROM site.carrinho c
INNER JOIN comum.usuario u
    ON c.id_usuario = u.id;


-- =========================================================
-- ITENS COM DADOS DO PRODUTO
-- =========================================================

CREATE OR REPLACE VIEW site.vw_itens_produtos AS
SELECT
    i.id AS id_item,
    i.id_carrinho,
    i.id_produto,
    p.nome AS produto,
    p.preco,
    i.quant
FROM site.item i
INNER JOIN adm.produto p
    ON i.id_produto = p.id;
