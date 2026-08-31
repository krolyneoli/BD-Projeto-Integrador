INSERT INTO adm.venda (id_usuario, id_cupom, subtotal, valor_desconto, valor_frete, total, stts_pagamento, stts) VALUES
    (1, NULL, 100.00, 0.00,  10.00, 110.00, 'pago',                  'concluída'),
    (2, 1,    200.00, 20.00, 15.00, 195.00, 'aguardando pagamento',  'em preparação'),
    (3, 3,    150.00, 30.00, 0.00,  120.00, 'pago',                  'concluída'),
    (1, NULL, 80.00,  0.00,  12.00, 92.00,  'aguardando pagamento',  'cancelada'),
    (5, 5,    300.00, 5.00,  20.00, 315.00, 'pago',                  'concluída');