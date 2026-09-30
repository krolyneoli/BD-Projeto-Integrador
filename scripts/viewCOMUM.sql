-- =========================================================
-- VIEW - SCHEMA comum.sql
-- =========================================================


-- =========================================================
-- Usuários clientes
-- =========================================================

CREATE OR REPLACE VIEW comum.vw_usuarios_clientes AS
SELECT
    id,
    nome,
    nome_social,
    email,
    tel,
    tipo,
    criado_em
FROM comum.usuario
WHERE tipo = 'cliente';


-- =========================================================
-- Usuários admin 
-- =========================================================

CREATE OR REPLACE VIEW comum.vw_usuarios_admin AS
SELECT
    id,
    nome,
    email,
    tel,
    tipo,
    criado_em
FROM comum.usuario
WHERE tipo = 'admin';


-- =========================================================
-- usuários e seus endereços
-- =========================================================

CREATE OR REPLACE VIEW comum.vw_enderecos_principais AS
SELECT
    ue.id_usuario,
    ue.id_endereco,
    e.rua,
    e.numero,
    e.bairro,
    e.cidade,
    e.estado,
    e.cep,
    e.complemento
FROM comum.usuario_endereco ue
INNER JOIN comum.endereco e
    ON ue.id_endereco = e.id
WHERE ue.principal = TRUE;


-- =========================================================
-- Lista de usuarios
-- =========================================================

CREATE OR REPLACE VIEW comum.vw_lista_usuarios AS
SELECT
    id,
    nome,
    email,
    cpf,
    tel,
    tipo,
    criado_em
FROM comum.usuario;


-- =========================================================
-- Endereços de Minas Gerais, puxado pelo "MG"
-- =========================================================

CREATE OR REPLACE VIEW comum.vw_enderecos_mg AS
SELECT
    id,
    rua,
    numero,
    bairro,
    cidade,
    cep,
    complemento
FROM comum.endereco
WHERE estado = 'MG';
