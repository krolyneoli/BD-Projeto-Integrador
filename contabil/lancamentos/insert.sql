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