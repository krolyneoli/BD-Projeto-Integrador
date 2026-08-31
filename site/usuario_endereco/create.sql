CREATE TABLE site.usuario_endereco (
    id_usuario INTEGER NOT NULL,
    id_endereco INTEGER NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (id_usuario, id_endereco),

    CONSTRAINT fk_usuario_endereco_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES site.usuario(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_endereco_endereco
        FOREIGN KEY (id_endereco)
        REFERENCES site.endereco(id)
        ON DELETE CASCADE
);