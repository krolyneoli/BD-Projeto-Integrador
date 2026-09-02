-- =========================================================
-- CATEGORIA
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
-- ENDEREÇO
-- =========================================================

INSERT INTO site.endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES
    ('Rua das Flores', 199, 'Centro', 'Extrema', 'MG', '37640-000', 'Apto 302'),
    ('Avenida Brasil', 553, 'Jardim América', 'Extrema', 'MG', '37640-010', NULL),
    ('Rua São José', 89, 'Vila Nova', 'Camanducaia', 'MG', '37650-000', 'Casa 2'),
    ('Rua XV de Novembro', 500, 'Centro', 'Itapeva', 'SP', '18400-000', NULL),
    ('Rua das Palmeiras', 10, 'Bela Vista', 'Extrema', 'RJ', '37640-020', 'Fundos'),
    ('Rua das Acácias', 125, 'Centro', 'Extrema', 'MG', '37640-030', NULL),
    ('Avenida Minas Gerais', 780, 'Jardim Europa', 'Extrema', 'MG', '37640-040', 'Apto 101'),
    ('Rua Tiradentes', 45, 'Centro', 'Camanducaia', 'MG', '37650-010', NULL),
    ('Rua São Paulo', 320, 'Vila Industrial', 'Itapeva', 'SP', '18400-020', 'Casa 1'),
    ('Rua dos Ipês', 88, 'Bela Vista', 'Extrema', 'MG', '37640-050', 'Fundos');


-- =========================================================
-- USUÁRIO
-- =========================================================

INSERT INTO site.usuario (nome, nome_social, email, senha, cpf, tel, tipo) VALUES
    ('Maria Oliveira Santos', NULL, 'maria.oliveira@email.com', 'senha_hash_123', '123.456.789-01', '(35) 99123-4567', 'cliente'),
    ('João Pedro Almeida', NULL, 'joao.almeida@email.com', 'senha_hash_456', '234.567.890-12', '(35) 98234-5678', 'cliente'),
    ('Ana Carolina Ferreira', 'Carol Ferreira', 'ana.ferreira@email.com', 'senha_hash_789', '345.678.901-23', '(35) 97345-6789', 'cliente'),
    ('Pedro Henrique Costa', NULL, 'pedro.costa@padaria.com', 'senha_hash_admin1', '456.789.012-34', '(35) 96456-7890', 'cliente'),
    ('Beatriz Souza Lima', NULL, 'beatriz.lima@padaria.com', 'senha_hash_admin2', '567.890.123-45', '(35) 95567-8901', 'cliente'), 
    ('Karolyne', NULL, 'karolyne@email.com', 'senha_hash_123', '678.901.234-56', '(35) 94456-7890', 'admin'), 
    ('Gabriel Gomes', NULL, 'gabriel.gomes@email.com', 'senha_hash_456', '789.012.378-67', '(35) 93345-6789', 'admin'), 
    ('Matheus Amaral', NULL, 'matheus.amaral@email.com', 'senha_hash_789', '890.123.749-78', '(35) 92234-5678', 'admin'), 
    ('Lara', NULL, 'lara@email.com', 'senha_hash_789', '890.123.546-78', '(14) 92234-5678', 'admin'),
    ('Camily', NULL, 'camily@email.com', 'senha_hash_459', '890.123.132-78', '(35) 92234-5652', 'admin');


-- =========================================================
-- CUPOM
-- =========================================================

INSERT INTO adm.cupom (nome, tipo_desconto, valor, data_inicio, data_fim, valor_minimo, ativo) VALUES
    ('BEMVINDO10', 'percentual', 10.00, '2026-01-01 00:00:00-03', '2026-12-31 23:59:59-03', 30.00, TRUE),
    ('FRETEGRATIS', 'fixo', 15.00, '2026-03-01 00:00:00-03', '2026-03-31 23:59:59-03', 50.00, TRUE),
    ('PADARIA20', 'percentual', 20.00, '2026-02-01 00:00:00-03', '2026-02-28 23:59:59-03', 0.00, TRUE),
    ('BLACKFRIDAY', 'percentual', 50.00, '2026-11-25 00:00:00-03', '2026-11-30 23:59:59-03', 100.00, FALSE),
    ('DOCE5', 'fixo', 5.00, '2026-01-01 00:00:00-03', '2026-06-30 23:59:59-03', 20.00, TRUE);


-- =========================================================
-- FORNECEDOR
-- =========================================================

INSERT INTO adm.fornecedor (nome, nome_social, nome_fantasia, email, tel, documento, id_endereco) VALUES
    ('Distribuidora de Farinhas Ltda', NULL, 'FarinhasBR', 'contato@farinhasbr.com', '(35) 3435-1000', '12.345.678/0001-90', 1),
    ('Laticínios Vale Verde', NULL, 'Vale Verde', 'vendas@valeverde.com', '(35) 3435-2000', '23.456.789/0001-01', 2),
    ('Chocolates & Cia', NULL, 'ChocoCia', 'comercial@chococia.com', '(35) 3435-3000', '34.567.890/0001-12', 3),
    ('Embalagens Sul Minas', NULL, 'Sul Minas Embalagens', 'contato@sulminas.com', '(35) 3435-4000', '45.678.901/0001-23', 4);


-- =========================================================
-- PRODUTO
-- =========================================================

INSERT INTO adm.produto (nome, descricao, preco, id_categoria, preco_promocional, ativo) VALUES
    ('Pão Francês (kg)', 'Pão francês tradicional, crocante por fora e macio por dentro', 18.90, 1, NULL, TRUE),
    ('Pão de Queijo (dúzia)', 'Pão de queijo mineiro tradicional', 22.00, 1, 19.90, TRUE),
    ('Bolo de Cenoura com Chocolate', 'Bolo de cenoura com cobertura de chocolate', 35.00, 2, NULL, TRUE),
    ('Brigadeiro Gourmet (unidade)', 'Brigadeiro artesanal feito com chocolate belga', 4.50, 3, NULL, TRUE),
    ('Coxinha de Frango', 'Coxinha recheada com frango desfiado', 8.00, 4, 6.90, TRUE),
    ('Café Expresso', 'Café expresso tradicional', 6.00, 6, NULL, TRUE),
    ('Torta de Limão', 'Torta de limão com merengue', 45.00, 7, 39.90, TRUE),
    ('Cookie de Chocolate', 'Cookie artesanal com gotas de chocolate', 7.50, 8, NULL, FALSE);


-- =========================================================
-- FORNECEDORES DO PRODUTO
-- =========================================================

INSERT INTO adm.produto_fornecedor (id_produto, id_fornecedor) VALUES
    (1, 1),
    (2, 1),
    (2, 2),
    (3, 2),
    (3, 3),
    (4, 3),
    (7, 3),
    (8, 3);


-- =========================================================
-- ESTOQUE
-- =========================================================

INSERT INTO adm.estoque (id_produto, quant, stts, valor_atencao) VALUES
    (1, 150, 'disponivel', 20),
    (2, 40, 'disponivel', 15),
    (3, 8, 'atencao', 10),
    (4, 200, 'disponivel', 30),
    (5, 3, 'critico', 10),
    (6, 500, 'disponivel', 50),
    (7, 0, 'indisponivel', 5),
    (8, 25, 'disponivel', 10);


-- =========================================================
-- VENDA
-- =========================================================

INSERT INTO adm.venda (id_usuario, id_cupom, subtotal, valor_desconto, valor_frete, total, stts_pagamento, stts) VALUES
    (1, NULL, 100.00, 0.00,  10.00, 110.00, 'pago', 'concluída'),
    (2, 1, 200.00, 20.00, 15.00, 195.00, 'aguardando pagamento', 'em preparação'),
    (3, 3, 150.00, 30.00, 0.00,  120.00, 'pago', 'concluída'),
    (1, NULL, 80.00,  0.00,  12.00, 92.00,  'aguardando pagamento', 'cancelada'),
    (5, 5, 300.00, 5.00,  20.00, 315.00, 'pago', 'concluída');


-- =========================================================
-- ITENS DA VENDA
-- =========================================================

INSERT INTO adm.item_venda (id_venda, id_produto, quant, preco_unitario, total) VALUES
    (1, 1, 5, 18.90, 94.50),
    (1, 2, 1, 19.90, 19.90),
    (2, 3, 2, 35.00, 70.00),
    (2, 6, 3, 6.00, 18.00),
    (3, 4, 10, 4.50, 45.00),
    (3, 7, 1, 39.90, 39.90),
    (4, 5, 4, 6.90, 27.60),
    (5, 8, 6, 7.50, 45.00);


-- =========================================================
-- PAGAMENTO
-- =========================================================

INSERT INTO adm.pagamento (id_venda, forma, stts, valor, data_pagamento) VALUES
    (1, 'pix', 'pago', 110.00, '2026-01-05 14:30:00-03'),
    (2, 'credito', 'aguardando pagamento', 195.00, NULL),
    (3, 'debito', 'pago', 120.00, '2026-02-10 09:15:00-03'),
    (4, 'pix', 'cancelado', 92.00, NULL),
    (5, 'credito', 'pago', 315.00, '2026-03-20 18:45:00-03');


-- =========================================================
-- NOTA FISCAL
-- =========================================================

INSERT INTO adm.nota_fiscal (numero_nota, valor, id_venda) VALUES
    ('000000001', 110.00, 1),
    ('000000002', 195.00, 2),
    ('000000003', 120.00, 3),
    ('000000004', 92.00, 4),
    ('000000005', 315.00, 5);


-- =========================================================
--  ENTREGA
-- =========================================================

INSERT INTO adm.entrega (
    stts,
    data_hora_previsao_entrega,
    data_hora_entrega,
    id_venda,
    rua,
    numero,
    bairro,
    cidade,
    estado,
    cep,
    complemento
) VALUES
    (
        'entregue',
        '2026-09-28 14:00:00',
        '2026-09-28 13:45:00',
        1,
        'Rua das Flores',
        199,
        'Centro',
        'Extrema',
        'MG',
        '37640-000',
        'Apto 302'
    ),
    (
        'em transporte',
        '2026-09-03 16:00:00',
        NULL,
        2,
        'Avenida Brasil',
        553,
        'Jardim América',
        'Extrema',
        'MG',
        '37640-010',
        NULL
    ),
    (
        'entregue',
        '2026-09-29 12:00:00',
        '2026-09-29 11:50:00',
        3,
        'Rua São José',
        89,
        'Vila Nova',
        'Camanducaia',
        'MG',
        '37650-000',
        'Casa 2'
    ),
    (
        'cancelada',
        '2026-09-05 15:00:00',
        NULL,
        4,
        'Rua XV de Novembro',
        500,
        'Centro',
        'Itapeva',
        'SP',
        '18400-000',
        NULL
    ),
    (
        'entregue',
        '2026-09-30 17:00:00',
        '2026-09-30 16:40:00',
        5,
        'Rua das Palmeiras',
        10,
        'Bela Vista',
        'Extrema',
        'RJ',
        '37640-020',
        'Fundos'
    );  


-- =========================================================
-- CARRINHO
-- =========================================================

INSERT INTO site.carrinho (id_usuario, id_cupom) VALUES
    (1, 1),
    (2, NULL),
    (3, 3),
    (4, NULL),
    (5, 2),
    (6, NULL),
    (7, 5),
    (8, NULL),
    (9, NULL),
    (10, NULL);


-- =========================================================
-- ITENS DO CARRINHO
-- =========================================================

INSERT INTO site.item (id_carrinho, id_produto, quant)
VALUES
    (1, 1, 2),
    (2, 2, 1),
    (3, 3, 1),
    (4, 4, 3),
    (5, 5, 2),
    (6, 6, 1),
    (7, 7, 1),
    (8, 8, 2),
    (9, 1, 1),
    (10, 2, 2);


-- =========================================================
-- ENDEREÇOS DO USUÁRIO
-- =========================================================

INSERT INTO site.usuario_endereco (id_usuario, id_endereco, principal)
VALUES
    -- Maria Oliveira Santos → Rua das Flores
    (1, 1, TRUE),
    -- João Pedro Almeida → Avenida Brasil
    (2, 2, TRUE),
    -- Ana Carolina Ferreira → Rua São José
    (3, 3, TRUE),
    -- Pedro Henrique Costa → Rua XV de Novembro
    (4, 4, TRUE),
    -- Beatriz Souza Lima → Rua das Palmeiras
    (5, 5, TRUE),
    -- Karolyne → Rua das Acácias
    (6, 6, TRUE),
    -- Gabriel Gomes → Avenida Minas Gerais
    (7, 7, TRUE),
    -- Matheus Amaral → Rua Tiradentes
    (8, 8, TRUE),
    -- Lara → Rua São Paulo
    (9, 9, TRUE),
    -- Camily → Rua dos Ipês
    (10, 10, TRUE);



-- =========================================================
-- PLANO DE CONTAS
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
-- LANÇAMENTOS
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


-- =========================================================
-- CUPONS DO USUÁRIO 
-- =========================================================

INSERT INTO adm.usuario_cupom (usuario_id, cupom_id)
VALUES
    (1, 1), -- Maria → BEMVINDO10
    (2, 2), -- João → FRETEGRATIS
    (3, 3), -- Ana → PADARIA20
    (4, 1), -- Pedro → BEMVINDO10
    (5, 2), -- Beatriz → FRETEGRATIS
    (6, 4), -- Karolyne → BLACKFRIDAY
    (7, 5), -- Gabriel → DOCE5
    (8, 1), -- Matheus → BEMVINDO10
    (9, 3), -- Lara → PADARIA20
    (10, 5); -- Camily → DOCE5
