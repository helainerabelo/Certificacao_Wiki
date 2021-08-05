## 1 - Consultar emissor:
-- Roda na base do emissor para saber qual o id e nome do emissor quando este emissor não está cadastrado no odin

```
select
   id_emissor,
   Emissor,
   ipservidor
from ControleAcesso_NEW..emissores
where emissor like '%capella%'
```

## 2 -  CONSULTA CARTÃO REAL 
-- Roda na base do emissor para saber os dados do cartão
`SELECT * FROM cartoes where cartaohash = HASHBYTES('MD5', '4179583062511615')`

## 3 - Consultar BINS
-- Roda na base do emissor e na base do Odin
`Select * from BINS where bin in (529479, 536832);`

-- Roda na base do Odin
`Select * from BINS where ID_EMISSOR = 54;`

## 4 - Habilitar cartão para uso
-- Desbloquear CARTÃO  (HABILITAR O CARTÃO PARA USO) - Roda na base do emissor

```
UPDATE CARTOES SET STATUS = 1, QtdSenhasIncorretas = 0, Estagio = 6
     where cartaohash = HASHBYTES('MD5', '5067070188858340') -- colocar o número do cartão real
```

## 5 - Adicionar limite ao cartão
-- ADICIONA LIMITE (Roda na base do emissor)

```
update limitesdisponibilidades
 set LimiteSaqueNacPeriodo        = 500000
,LimiteSaqueNacGlobal            = 500000
,LimiteCompraNac                = 500000
,LimiteParceladoNac                = 500000
,LimiteGlobalCredito            = 500000
,DisponibSaqueNacGlobal            = 500000
,DisponibCompraNac                = 500000
,DisponibParceladoNac            = 500000
,DisponibParcelasNac            = 500000
,DisponibGlobalCredito            = 500000
,LimiteParcelasNac                = 500000
where id_conta = 803 -- mudar o id_conta. É possível pegar com a consulta do cartão real.
```

## 6 - Zerar limite cartão
-- Rodar na base do emissor

```
update limitesdisponibilidades
 set LimiteSaqueNacPeriodo        = 000000
,LimiteSaqueNacGlobal            = 000000
,LimiteCompraNac                = 000000
,LimiteParceladoNac                = 000000
,LimiteGlobalCredito            = 000000
,DisponibSaqueNacGlobal            = 000000
,DisponibCompraNac                = 000000
,DisponibParceladoNac            = 000000
,DisponibParcelasNac            = 000000
,DisponibGlobalCredito            = 000000
,LimiteParcelasNac                = 000000
where id_conta = 274 -- mudar o id_conta. É possível pegar com a consulta do cartão real.
```

## 7 - Consultar chaves atreladas aos bins
-- consultar chaves atreladas aos bins (Roda na base do emissor)

```
select b.id_binschaves, b.bin , b.chave, b.checkvalue, t.descricao, *
from binschaves b join tipochave t on b.id_tipochave=t.id_tipochave
where bin in (509259) -- mudar para o bin desejado
order by b.bin asc
```

