CREATE TABLE adm.pagamento (
    id SERIAL PRIMARY KEY,
    id_venda INTEGER NOT NULL UNIQUE,
    forma adm.forma_pagamento_enum NOT NULL,
    stts adm.stts_pagamento_enum NOT NULL DEFAULT 'aguardando pagamento',
    valor DECIMAL(15,2) NOT NULL,
    data_pagamento TIMESTAMPTZ,

    CONSTRAINT fk_pagamento_venda
        FOREIGN KEY (id_venda)
        REFERENCES adm.venda(id),

    CONSTRAINT ck_pagamento_valor
        CHECK (valor >= 0)
);