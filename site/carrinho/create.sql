CREATE TABLE site.carrinho (
    id SERIAL PRIMARY KEY,
    total DECIMAL(15,2) NOT NULL DEFAULT 0,
    id_usuario INTEGER NOT NULL,
    id_cupom INTEGER,

    CONSTRAINT fk_carrinho_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES site.usuario(id),

    CONSTRAINT fk_carrinho_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES adm.cupom(id),

    CONSTRAINT ck_carrinho_total
        CHECK (total >= 0)

);