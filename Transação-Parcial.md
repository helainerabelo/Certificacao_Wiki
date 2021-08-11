##Transação com Compra parcialmente aprovada e saque aprovado
- Bit 60 subcampo 2 deve ser preenchido com 1 (Aprovação Parcial suportado: Compras podem ser aprovadas parcialmente. Cash Over pode ser aprovado parcialmente.);

- Desativar a regra LIMITE_APROVA_PARCIAL e ativar a LIMITE_APROVA_PARCIAL_COMPRA_SAQUE

- Realizar o insert do parâmetro VALORPARCIALMINIMO caso não esteja na base


```
INSERT INTO ParametrosEmissores 
( Id_emissor, DataValidade, Codigo, Descricao, Tipo, Numerico, Percentual, Logico, Data, FlagDefault)
VALUES 
(1,1905-07-01,'VALORPARCIALMINIMO','Valor mínimo que pode ser aprovado parcialmente','N',100,0,0,NULL,1);
```


- Alterar o limite da conta para um valor menor que o solicitado na transação


```
UPDATE LimitesDisponibilidades SET DisponibGlobalCredito = X WHERE Id_Conta = X
```
