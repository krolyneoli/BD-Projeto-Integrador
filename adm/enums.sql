CREATE TYPE adm.stts_estoque_enum AS ENUM (
    'disponivel',
    'atencao',
    'critico',
    'indisponivel'
);

CREATE TYPE adm.forma_pagamento_enum AS ENUM (
    'credito',
    'debito',
    'pix'
);

CREATE TYPE adm.stts_pagamento_enum AS ENUM (
    'aguardando pagamento',
    'pago',
    'expirado',
    'cancelado'
);

CREATE TYPE adm.tipo_desconto_cupom_enum AS ENUM (
	'percentual',
	'fixo'
);

CREATE TYPE adm.stts_pagamento_venda_enum AS ENUM (
	'aguardando pagamento',
    'pago'
);

CREATE TYPE adm.stts_venda_enum AS ENUM (
    'em preparação',
    'concluída',
    'cancelada'
);

CREATE TYPE adm.stts_entrega_enum AS ENUM (
    'aguardando envio',
    'em transporte',
    'entregue',
    'cancelada'
);