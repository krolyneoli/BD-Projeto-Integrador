CREATE TABLE adm.usuario_cupom (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL,
    cupom_id INTEGER NOT NULL,
    utilizado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_cupom_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES site.usuario(id),

    CONSTRAINT fk_usuario_cupom_cupom
        FOREIGN KEY (cupom_id)
        REFERENCES adm.cupom(id),

    CONSTRAINT uk_usuario_cupom
        UNIQUE (usuario_id, cupom_id)
);
