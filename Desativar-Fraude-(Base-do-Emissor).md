**Deve ser executado na base do emissor, para desativar os parâmetros de fraude.**



```
update parametrosemissores
set
logico = 0
where codigo like '%ODIN_FRAUDE%'
select * from parametrosemissores where codigo like '%ODIN_FRAUDE%'
```



Obs.: Para identificar que esse parâmetro está impactando as transações, pode ser visualizado no log do autorizador que os campos são apresentados como Null, e no decorrer do log, exibe algumas informações sobre com o descrito apontando "fraude".


Exemplo:
```
{
  "uuid" : "b75fb74f-8455-48ef-8341-f1c877e1f0c4",
  "emissor" : "105",
  "nomeEmissor" : null,
  "versao" : "1.66.0",
  "profile" : "cert",
  "ipATF" : "10.19.21.167",
  "ipServico" : "10.76.9.5",
  "origem" : "OrigemTecban",
  "evento" : null,
  "motivoResposta" : null,
  "nomeEstabelecimento" : null,
  "valorTransacao" : null,
  "valorContrato" : null,
  "codigoMoedaOrigem" : null,
  "latitude" : null,
  "longitude" : null,
  "failover" : false,
  "salvamentoSincrono" : false,
  "cartao" : null,
  "codigoMotivoAdvice" : null,
  "motivoAdvice" : null,
  "codigoRespostaAdvice" : null,
  "possuiLimiteImobilizado" : false,
  "modoConsultaDados" : null,
  "modoEntrada" : null,
.../
}
```
