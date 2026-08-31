CREATE TYPE contabil.tipo_conta_enum as ENUM (
	'ativo',
	'passivo',
	'patrimônio líquido',
	'receita',
	'despesa'
);

CREATE TYPE contabil.natureza_conta_enum as ENUM (
	'devedora',
	'credora'
);
