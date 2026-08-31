CREATE TABLE site.carrinho (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_cupom INTEGER,

    CONSTRAINT fk_carrinho_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES site.usuario(id),

    CONSTRAINT fk_carrinho_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id),
);