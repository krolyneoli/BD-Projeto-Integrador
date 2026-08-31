CREATE TABLE site.usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nome_social VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    tel VARCHAR(20) NOT NULL,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo site.tipo_usuario_enum NOT NULL DEFAULT 'cliente'
);