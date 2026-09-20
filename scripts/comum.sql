-- =========================================================
-- SCHEMA
-- =========================================================

CREATE SCHEMA comum;


-- =========================================================
-- ENUM
-- =========================================================

CREATE TYPE comum.tipo_usuario_enum AS ENUM (
    'admin',
    'cliente'
);


-- =========================================================
-- TABELA DE USUÁRIO
-- =========================================================

CREATE TABLE comum.usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nome_social VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    tel VARCHAR(20) NOT NULL,
    tipo comum.tipo_usuario_enum NOT NULL DEFAULT 'cliente',
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- TABELA DE ENDEREÇO
-- =========================================================

CREATE TABLE comum.endereco (
    id SERIAL PRIMARY KEY,
    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    complemento VARCHAR(100)
);


-- =========================================================
-- TABELA DE ENDEREÇOS DO USUÁRIO
-- =========================================================

CREATE TABLE comum.usuario_endereco (
    id_usuario INTEGER NOT NULL,
    id_endereco INTEGER NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (id_usuario, id_endereco),

    CONSTRAINT fk_usuario_endereco_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES comum.usuario(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_endereco_endereco
        FOREIGN KEY (id_endereco)
        REFERENCES comum.endereco(id)
        ON DELETE CASCADE
);


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE USUÁRIO
-- =========================================================

INSERT INTO comum.usuario (nome, nome_social, email, senha, cpf, tel, tipo) VALUES
    ('Maria Oliveira Santos', NULL, 'maria.oliveira@email.com', 'senha_hash_123', '123.456.789-01', '(35) 99123-4567', 'cliente'),
    ('João Pedro Almeida', NULL, 'joao.almeida@email.com', 'senha_hash_456', '234.567.890-12', '(35) 98234-5678', 'cliente'),
    ('Ana Carolina Ferreira', 'Carol Ferreira', 'ana.ferreira@email.com', 'senha_hash_789', '345.678.901-23', '(35) 97345-6789', 'cliente'),
    ('Pedro Henrique Costa', NULL, 'pedro.costa@padaria.com', 'senha_hash_admin1', '456.789.012-34', '(35) 96456-7890', 'cliente'),
    ('Beatriz Souza Lima', NULL, 'beatriz.lima@padaria.com', 'senha_hash_admin2', '567.890.123-45', '(35) 95567-8901', 'cliente'), 
    ('Karolyne', NULL, 'karolyne@email.com', 'senha_hash_123', '678.901.234-56', '(35) 94456-7890', 'admin'), 
    ('Gabriel Gomes', NULL, 'gabriel.gomes@email.com', 'senha_hash_456', '789.012.378-67', '(35) 93345-6789', 'admin'), 
    ('Matheus Amaral', NULL, 'matheus.amaral@email.com', 'senha_hash_789', '890.123.749-78', '(35) 92234-5678', 'admin'), 
    ('Lara', NULL, 'lara@email.com', 'senha_hash_789', '890.123.546-78', '(14) 92234-5678', 'admin'),
    ('Camily', NULL, 'camily@email.com', 'senha_hash_459', '890.123.132-78', '(35) 92234-5652', 'admin');


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE ENDEREÇO
-- =========================================================

INSERT INTO comum.endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES
    ('Rua das Flores', 199, 'Centro', 'Extrema', 'MG', '37640-000', 'Apto 302'),
    ('Avenida Brasil', 553, 'Jardim América', 'Extrema', 'MG', '37640-010', NULL),
    ('Rua São José', 89, 'Vila Nova', 'Camanducaia', 'MG', '37650-000', 'Casa 2'),
    ('Rua XV de Novembro', 500, 'Centro', 'Itapeva', 'SP', '18400-000', NULL),
    ('Rua das Palmeiras', 10, 'Bela Vista', 'Extrema', 'RJ', '37640-020', 'Fundos'),
    ('Rua das Acácias', 125, 'Centro', 'Extrema', 'MG', '37640-030', NULL),
    ('Avenida Minas Gerais', 780, 'Jardim Europa', 'Extrema', 'MG', '37640-040', 'Apto 101'),
    ('Rua Tiradentes', 45, 'Centro', 'Camanducaia', 'MG', '37650-010', NULL),
    ('Rua São Paulo', 320, 'Vila Industrial', 'Itapeva', 'SP', '18400-020', 'Casa 1'),
    ('Rua dos Ipês', 88, 'Bela Vista', 'Extrema', 'MG', '37640-050', 'Fundos');


-- =========================================================
-- INSERÇÃO DE DADOS NA TABELA DE ENDEREÇOS DO USUÁRIO
-- =========================================================

INSERT INTO comum.usuario_endereco (id_usuario, id_endereco, principal)
VALUES
    -- Maria Oliveira Santos → Rua das Flores
    (1, 1, TRUE),
    -- João Pedro Almeida → Avenida Brasil
    (2, 2, TRUE),
    -- Ana Carolina Ferreira → Rua São José
    (3, 3, TRUE),
    -- Pedro Henrique Costa → Rua XV de Novembro
    (4, 4, TRUE),
    -- Beatriz Souza Lima → Rua das Palmeiras
    (5, 5, TRUE),
    -- Karolyne → Rua das Acácias
    (6, 6, TRUE),
    -- Gabriel Gomes → Avenida Minas Gerais
    (7, 7, TRUE),
    -- Matheus Amaral → Rua Tiradentes
    (8, 8, TRUE),
    -- Lara → Rua São Paulo
    (9, 9, TRUE),
    -- Camily → Rua dos Ipês
    (10, 10, TRUE);
