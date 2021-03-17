Para visualizar as transações que estão sendo executadas no autorizador, basta realizar a consulta na base do emissor em que deseja visualizar as transações:


```
select top 10 *
from mensagensentrada me
inner join mensagenssaida ms on me.id_mensagem = ms.id_mensagem
order by me.id_mensagem desc
```
