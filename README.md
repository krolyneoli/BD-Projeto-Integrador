# Padaria Artesanal Delícias

## Banco de Dados do Projeto Integrador

Este repositório reúne o script SQL do banco de dados desenvolvido para o ecommerce da **Padaria Artesanal Delícias**. A proposta do modelo é representar, de forma organizada e consistente, os principais processos de uma aplicação comercial, contemplando cadastro de usuários, gestão de produtos, controle de estoque, carrinho de compras, vendas, pagamentos e entregas.

## Objetivo

O objetivo deste banco de dados é fornecer uma estrutura relacional capaz de sustentar as operações essenciais de um ecommerce, preservando integridade, rastreabilidade e padronização dos dados. O projeto foi elaborado com foco acadêmico, servindo como base para demonstração de modelagem, normalização e aplicação de restrições de integridade em PostgreSQL.

## Escopo do sistema

A solução foi organizada em dois schemas, cada um responsável por um conjunto específico de informações:

- `site`: dados relacionados ao cliente e às funcionalidades de navegação e compra.
- `adm`: dados operacionais e comerciais do ecommerce.

Outro schema relevante foi o fornecido pelo professor da disciplina:
- `contabil`: estrutura destinada ao controle contábil e aos lançamentos financeiros.

O script principal do projeto está concentrado em `CREATE_COMPLETO.sql`, que reúne a definição dos schemas, enums, tabelas, chaves primárias, chaves estrangeiras e demais restrições.

## Organização lógica do banco

### Schema `site`

O schema `site` contempla as entidades ligadas ao usuário e ao processo de compra.

- `endereco`: armazena os dados de localização.
- `usuario`: registra clientes e administradores.
- `usuario_endereco`: estabelece a relação entre usuários e endereços.
- `carrinho`: representa o carrinho associado ao usuário.
- `item`: registra os produtos adicionados ao carrinho.

### Schema `adm`

O schema `adm` concentra as entidades responsáveis pela operação comercial.

- `fornecedor`: cadastro de fornecedores.
- `categoria`: classificação dos produtos.
- `cupom`: cupons promocionais e regras de desconto.
- `produto`: catálogo de produtos da padaria.
- `produto_fornecedor`: relacionamento entre produtos e fornecedores.
- `estoque`: controle quantitativo e situacional dos produtos.
- `venda`: registro das transações comerciais.
- `item_venda`: composição detalhada de cada venda.
- `pagamento`: informações referentes ao pagamento da venda.
- `nota_fiscal`: emissão e vinculação da nota fiscal.
- `entrega`: dados logísticos e endereço de entrega.

### Schema `contabil`

O schema `contabil` contempla o arquivo .sql do trabalho 1 entregue pelo professor.

- `plano_contas`: estrutura de classificação contábil.
- `lancamentos`: registros de débitos e créditos.

## Tipos enumerados

Foram utilizados enums para reduzir inconsistências e padronizar os valores aceitos pelo sistema. Entre os principais tipos definidos, destacam-se:

- status de estoque
- forma de pagamento
- status de pagamento
- tipo de desconto de cupom
- status de pagamento da venda
- status da venda
- status da entrega
- tipo de usuário
- tipo de conta contábil
- natureza da conta contábil

## Regras de integridade

O modelo incorpora restrições de domínio e validações que fortalecem a consistência dos dados:

- valores monetários e quantidades não podem assumir valores negativos.
- o preço promocional deve ser inferior ao preço original do produto.
- cupons do tipo percentual não podem ultrapassar 100%.
- a data de término do cupom deve ser posterior à data de início.
- itens de carrinho e de venda devem possuir quantidade superior a zero.
- o total da venda é calculado a partir de subtotal, desconto e frete.
- a data efetiva de entrega não pode ser anterior à data de criação do registro.

## Relacionamentos relevantes

O banco de dados foi modelado com relacionamentos que refletem o fluxo real do ecommerce:

- um usuário pode possuir múltiplos endereços.
- um endereço pode estar associado a mais de um usuário.
- um carrinho pertence a um usuário específico.
- um carrinho pode conter diversos itens.
- um produto pertence a uma categoria.
- um produto pode ser fornecido por mais de um fornecedor.
- uma venda pertence a um usuário e pode estar vinculada a um cupom.
- uma venda pode possuir itens, pagamento, nota fiscal e entrega associados.

## Tecnologias e SGBD

O script foi desenvolvido para **PostgreSQL**, utilizando recursos como schemas, tipos enumerados, constraints, chaves primárias e chaves estrangeiras. Essa escolha permite maior controle sobre a integridade dos dados e maior aderência a práticas usuais de modelagem relacional.

## Estrutura dos arquivos

- `CREATE_COMPLETO.sql`: script de criação consolidado do banco de dados.
- `SCHEMAS.sql`: criação isolada dos schemas.
- `adm/`: scripts do módulo administrativo.
- `site/`: scripts do módulo do site e do cliente.
- `contabil/`: scripts do módulo contábil passados pelo professor.

## Considerações finais

O banco de dados foi concebido para representar o funcionamento de um ecommerce de padaria artesanal, servindo como base acadêmica para demonstrar conceitos de modelagem relacional, integridade referencial e organização de dados em um cenário realista de projeto integrador.
