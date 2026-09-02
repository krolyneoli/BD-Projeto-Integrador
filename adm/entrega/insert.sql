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
    -- Venda 1 → Rua das Flores
    (
        'entregue',
        '2026-08-28 14:00:00',
        '2026-08-28 13:45:00',
        1,
        'Rua das Flores',
        199,
        'Centro',
        'Extrema',
        'MG',
        '37640-000',
        'Apto 302'
    ),
    -- Venda 2 → Avenida Brasil
    (
        'em trânsito',
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
    -- Venda 3 → Rua São José
    (
        'entregue',
        '2026-08-29 12:00:00',
        '2026-08-29 11:50:00',
        3,
        'Rua São José',
        89,
        'Vila Nova',
        'Camanducaia',
        'MG',
        '37650-000',
        'Casa 2'
    ),
    -- Venda 4 → Rua XV de Novembro
    (
        'cancelada',
        '2026-09-01 15:00:00',
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
    -- Venda 5 → Rua das Palmeiras
    (
        'entregue',
        '2026-08-30 17:00:00',
        '2026-08-30 16:40:00',
        5,
        'Rua das Palmeiras',
        10,
        'Bela Vista',
        'Extrema',
        'RJ',
        '37640-020',
        'Fundos'
    );