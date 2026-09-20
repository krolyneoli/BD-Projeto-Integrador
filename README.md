# Padaria Artesanal Delícias

## Banco de Dados do Projeto Integrador

Este repositório reúne os scripts SQL do banco de dados desenvolvido para o ecommerce da **Padaria Artesanal Delícias**. O modelo representa os principais processos de uma aplicação comercial, contemplando cadastro de usuários, gestão de produtos, controle de estoque, carrinho de compras, vendas, pagamentos, entregas e lançamentos contábeis.

## Objetivo

O banco de dados foi criado para sustentar as operações essenciais de um ecommerce, preservando integridade, rastreabilidade e padronização dos dados. O projeto também serve como base acadêmica para demonstração de modelagem relacional, normalização e uso de restrições de integridade no PostgreSQL.

## Estrutura do projeto

O modelo está organizado em quatro schemas:

- `comum`: dados compartilhados que não têm um dono único.
- `adm`: dados operacionais e comerciais do ecommerce.
- `site`: funcionalidades de navegação e compra.
- `contabil`: controle contábil e lançamentos financeiros.

Os arquivos principais ficam em `scripts/`:

- `comum.sql`
- `adm.sql`
- `site.sql`
- `contabil.sql`

Cada script já contém a criação dos objetos e as inserções de dados correspondentes ao seu schema.

### Regra de dependência

As dependências vão sempre em uma direção, sem ciclos. O `comum` é a base e não referencia nenhum outro schema. Cada dado fica no schema de quem o gerencia: o `adm` é dono do catálogo e das vendas, e o `site` apenas consome. Isso permite criar as tabelas em ordem (`comum` → `adm` → `site` e `contabil`) e conceder permissões por schema.

## Passo a passo para executar

1. Instale e abra o **PostgreSQL**.
2. Crie um banco de dados vazio para o projeto.
3. Execute os scripts nesta ordem, porque há dependências entre os schemas:
   1. `scripts/comum.sql`
   2. `scripts/adm.sql`
   3. `scripts/site.sql`
   4. `scripts/contabil.sql`
4. Verifique se todos os comandos foram executados sem erro.

Se preferir executar pelo terminal com `psql`, o fluxo fica assim:

```bash
psql -U seu_usuario -d seu_banco -f scripts/comum.sql
psql -U seu_usuario -d seu_banco -f scripts/adm.sql
psql -U seu_usuario -d seu_banco -f scripts/site.sql
psql -U seu_usuario -d seu_banco -f scripts/contabil.sql
```

## Observação importante

Os scripts criam schemas, tipos e tabelas sem usar `IF NOT EXISTS`. Por isso, o ideal é executá-los em um banco limpo ou remover os objetos anteriores antes de rodar novamente.

## Organização lógica do banco

### Schema `comum`

- `endereco`: armazena os dados de localização.
- `usuario`: registra clientes e administradores.
- `usuario_endereco`: estabelece a relação entre usuários e endereços.

### Schema `adm`

- `fornecedor`: cadastro de fornecedores.
- `categoria`: classificação dos produtos.
- `cupom`: cupons promocionais e regras de desconto.
- `usuario_cupom`: controle de uso de cupom por cliente.
- `produto`: catálogo de produtos da padaria.
- `produto_fornecedor`: relacionamento entre produtos e fornecedores.
- `estoque`: controle quantitativo e situacional dos produtos.
- `venda`: registro das transações comerciais.
- `item_venda`: composição detalhada de cada venda.
- `pagamento`: informações referentes ao pagamento da venda.
- `nota_fiscal`: emissão e vinculação da nota fiscal.
- `entrega`: dados logísticos e endereço de entrega.

### Schema `site`

- `carrinho`: representa o carrinho associado ao usuário.
- `item`: registra os produtos adicionados ao carrinho.

### Schema `contabil`

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

- `docs/`: diagramas lógicos dos schemas `adm`, `comum`, `contabil` e `site`.
- `scripts/`: scripts de criação das tabelas e inserção de dados dos schemas `adm`, `comum`, `contabil` e `site`.

## Considerações finais

O banco de dados foi concebido para representar o funcionamento de um ecommerce de padaria artesanal, servindo como base acadêmica para demonstrar conceitos de modelagem relacional, integridade referencial e organização de dados em um cenário realista de projeto integrador.
