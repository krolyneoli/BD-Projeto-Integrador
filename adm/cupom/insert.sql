INSERT INTO adm.cupom (nome, tipo_desconto, valor, data_inicio, data_fim, valor_minimo, ativo) VALUES
    ('BEMVINDO10',   'percentual', 10.00, '2026-01-01 00:00:00-03', '2026-12-31 23:59:59-03', 30.00,  TRUE),
    ('FRETEGRATIS',  'fixo',       15.00, '2026-03-01 00:00:00-03', '2026-03-31 23:59:59-03', 50.00,  TRUE),
    ('PADARIA20',    'percentual', 20.00, '2026-02-01 00:00:00-03', '2026-02-28 23:59:59-03', 0.00,   TRUE),
    ('BLACKFRIDAY',  'percentual', 50.00, '2026-11-25 00:00:00-03', '2026-11-30 23:59:59-03', 100.00, FALSE),
    ('DOCE5',        'fixo',       5.00,  '2026-01-01 00:00:00-03', '2026-06-30 23:59:59-03', 20.00,  TRUE);