-- =========================================================
-- 1) adm.categoria (sem FK)
-- =========================================================
INSERT INTO adm.categoria (nome) VALUES
    ('Pães'),
    ('Bolos'),
    ('Doces'),
    ('Salgados'),
    ('Bebidas'),
    ('Cafés e Chás'),
    ('Tortas'),
    ('Biscoitos e Cookies');


-- =========================================================
-- 2) site.endereco (sem FK)
-- =========================================================
INSERT INTO site.endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES
    ('Rua das Flores', 120, 'Centro', 'Extrema', 'Minas Gerais', '37640-000', 'Apto 302'),
    ('Avenida Brasil', 45, 'Jardim América', 'Extrema', 'Minas Gerais', '37640-010', NULL),
    ('Rua São José', 88, 'Vila Nova', 'Camanducaia', 'Minas Gerais', '37650-000', 'Casa 2'),
    ('Rua XV de Novembro', 250, 'Centro', 'Itapeva', 'São Paulo', '18400-000', NULL),
    ('Rua das Palmeiras', 15, 'Bela Vista', 'Extrema', 'Minas Gerais', '37640-020', 'Fundos');


-- =========================================================
-- 3) site.usuario (sem FK)
-- =========================================================
INSERT INTO site.usuario (nome, nome_social, email, senha, cpf, tel, tipo) VALUES
    ('Maria Oliveira Santos', NULL, 'maria.oliveira@email.com', 'senha_hash_123', '123.456.789-01', '(35) 99123-4567', 'cliente'),
    ('João Pedro Almeida', NULL, 'joao.almeida@email.com', 'senha_hash_456', '234.567.890-12', '(35) 98234-5678', 'cliente'),
    ('Ana Carolina Ferreira', 'Carol Ferreira', 'ana.ferreira@email.com', 'senha_hash_789', '345.678.901-23', '(35) 97345-6789', 'cliente'),
    ('Pedro Henrique Costa', NULL, 'pedro.costa@padaria.com', 'senha_hash_admin1', '456.789.012-34', '(35) 96456-7890', 'cliente'),
    ('Beatriz Souza Lima', NULL, 'beatriz.lima@padaria.com', 'senha_hash_admin2', '567.890.123-45', '(35) 95567-8901', 'cliente'), 
    ('Karolyne', NULL, 'karolyne@email.com', 'senha_hash_123', '678.901.234-56', '(35) 94456-7890', 'admin'), 
    ('Gabriel Gomes', NULL, 'gabriel.gomes@email.com', 'senha_hash_456', '789.012.345-67', '(35) 93345-6789', 'admin'), 
    ('Matheus Amaral', NULL, 'matheus.amaral@email.com', 'senha_hash_789', '890.123.456-78', '(35) 92234-5678', 'admin'), 
    ('Lara', NULL, 'lara@email.com', 'senha_hash_789', '890.123.456-78', '(14) 92234-5678', 'admin'),
    ('Camily', NULL, 'camily@email.com', 'senha_hash_459', '890.123.456-78', '(35) 92234-5652', 'admin');


-- ===============================
-- 4) adm.cupom 
-- =============================
INSERT INTO adm.cupom (nome, tipo_desconto, valor, data_inicio, data_fim, valor_minimo, ativo) VALUES
    ('BEMVINDO10',   'percentual', 10.00, '2026-01-01 00:00:00-03', '2026-12-31 23:59:59-03', 30.00,  TRUE),
    ('FRETEGRATIS',  'fixo',       15.00, '2026-03-01 00:00:00-03', '2026-03-31 23:59:59-03', 50.00,  TRUE),
    ('PADARIA20',    'percentual', 20.00, '2026-02-01 00:00:00-03', '2026-02-28 23:59:59-03', 0.00,   TRUE),
    ('BLACKFRIDAY',  'percentual', 50.00, '2026-11-25 00:00:00-03', '2026-11-30 23:59:59-03', 100.00, FALSE),
    ('DOCE5',        'fixo',       5.00,  '2026-01-01 00:00:00-03', '2026-06-30 23:59:59-03', 20.00,  TRUE);


-- =========================
-- 5) adm.fornecedor 
-- =========================
INSERT INTO adm.fornecedor (nome, nome_social, nome_fantasia, email, tel, documento, id_endereco) VALUES
    ('Distribuidora de Farinhas Ltda', NULL, 'FarinhasBR', 'contato@farinhasbr.com', '(35) 3435-1000', '12.345.678/0001-90', 1),
    ('Laticínios Vale Verde', NULL, 'Vale Verde', 'vendas@valeverde.com', '(35) 3435-2000', '23.456.789/0001-01', 2),
    ('Chocolates & Cia', NULL, 'ChocoCia', 'comercial@chococia.com', '(35) 3435-3000', '34.567.890/0001-12', 3),
    ('Embalagens Sul Minas', NULL, 'Sul Minas Embalagens', 'contato@sulminas.com', '(35) 3435-4000', '45.678.901/0001-23', 4);


-- =====================
-- 6) adm.produto 
-- ===================
INSERT INTO adm.produto (nome, descricao, preco, id_categoria, preco_promocional, ativo) VALUES
    ('Pão Francês (kg)', 'Pão francês tradicional, crocante por fora e macio por dentro', 18.90, 1, NULL, TRUE),
    ('Pão de Queijo (dúzia)', 'Pão de queijo mineiro tradicional', 22.00, 1, 19.90, TRUE),
    ('Bolo de Cenoura com Chocolate', 'Bolo de cenoura com cobertura de chocolate', 35.00, 2, NULL, TRUE),
    ('Brigadeiro Gourmet (unidade)', 'Brigadeiro artesanal feito com chocolate belga', 4.50, 3, NULL, TRUE),
    ('Coxinha de Frango', 'Coxinha recheada com frango desfiado', 8.00, 4, 6.90, TRUE),
    ('Café Expresso', 'Café expresso tradicional', 6.00, 6, NULL, TRUE),
    ('Torta de Limão', 'Torta de limão com merengue', 45.00, 7, 39.90, TRUE),
    ('Cookie de Chocolate', 'Cookie artesanal com gotas de chocolate', 7.50, 8, NULL, FALSE);


-- =====================
-- 7) adm.produto_fornecedor 
-- =====================
INSERT INTO adm.produto_fornecedor (id_produto, id_fornecedor) VALUES
    (1, 1),
    (2, 1),
    (2, 2),
    (3, 2),
    (3, 3),
    (4, 3),
    (7, 3),
    (8, 3);


-- ========
-- 8) adm.estoque 
-- ========
INSERT INTO adm.estoque (id_produto, quant, stts, valor_atencao) VALUES
    (1, 150, 'disponivel',   20),
    (2, 40,  'disponivel',   15),
    (3, 8,   'atencao',      10),
    (4, 200, 'disponivel',   30),
    (5, 3,   'critico',      10),
    (6, 500, 'disponivel',   50),
    (7, 0,   'indisponivel', 5),
    (8, 25,  'disponivel',   10);


-- =========================================================
-- 9) adm.venda 
-- =========================================================
INSERT INTO adm.venda (id_usuario, id_cupom, subtotal, valor_desconto, valor_frete, total, stts_pagamento, stts) VALUES
    (1, NULL, 100.00, 0.00,  10.00, 110.00, 'pago',                  'concluída'),
    (2, 1,    200.00, 20.00, 15.00, 195.00, 'aguardando pagamento',  'em preparação'),
    (3, 3,    150.00, 30.00, 0.00,  120.00, 'pago',                  'concluída'),
    (1, NULL, 80.00,  0.00,  12.00, 92.00,  'aguardando pagamento',  'cancelada'),
    (5, 5,    300.00, 5.00,  20.00, 315.00, 'pago',                  'concluída');


-- =========================================================
-- 10) adm.item_venda 
-- =========================================================
INSERT INTO adm.item_venda (id_venda, id_produto, quant, preco_unitario, total) VALUES
    (1, 1, 5, 18.90, 94.50),
    (1, 2, 1, 19.90, 19.90),
    (2, 3, 2, 35.00, 70.00),
    (2, 6, 3, 6.00,  18.00),
    (3, 4, 10, 4.50, 45.00),
    (3, 7, 1, 39.90, 39.90),
    (4, 5, 4, 6.90,  27.60),
    (5, 8, 6, 7.50,  45.00);


-- =========================================================
-- 11) adm.pagamento 
-- =========================================================
INSERT INTO adm.pagamento (id_venda, forma, stts, valor, data_pagamento) VALUES
    (1, 'pix',     'pago',                  110.00, '2026-01-05 14:30:00-03'),
    (2, 'credito', 'aguardando pagamento',  195.00, NULL),
    (3, 'debito',  'pago',                  120.00, '2026-02-10 09:15:00-03'),
    (4, 'pix',     'cancelado',             92.00,  NULL),
    (5, 'credito', 'pago',                  315.00, '2026-03-20 18:45:00-03');


-- =========================================================
-- 12) adm.nota_fiscal 
-- =========================================================
INSERT INTO adm.nota_fiscal (numero_nota, valor, id_venda) VALUES
    ('000000001', 110.00, 1),
    ('000000002', 195.00, 2),
    ('000000003', 120.00, 3),
    ('000000004', 92.00,  4),
    ('000000005', 315.00, 5);


-- =========================================================
-- AINDA FALTAM (não populadas nesta conversa):
--   site.usuario_endereco  (depende de usuario + endereco)
--   site.carrinho          (depende de usuario + cupom)
--   site.item_carrinho     (depende de carrinho + produto)
--   adm.entrega            (depende de venda + endereco)
--   contabil.plano_contas  (sem FK)
--   contabil.lancamentos   (depende de pagamento + plano_contas)
-- =========================================================