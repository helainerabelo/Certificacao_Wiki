Ao ser apresentado o erro de "OPERACAO_NAO_ENCONTRADA":

- Verificar se a base já possui a tabela temp_odin_debug:
```
select * from dbo.temp_odin_debug;
```

-- Se tiver: Com o retorno da consulta, ver o registro da transação e pegar o CodigoProcessamento, o CodigoMCC (Código retornado é o convertido), Id_Estabelecimento e Id_Produto:

-- Se não: devemos atualizar a proc **SPR_ODIN_BUSCARDADOSTRANSACAO**. Tentar novamente a transação para que seja inserida na tabela e tenhamos as informações necessárias.

- Com o CodigoProcessamento e o CodigoMCC, rodar:
```
select distinct vo.Id_Estabelecimento, vo.Id_Produto, vo.Id_Operacao, tp.NomeOperacao, vo.CodigoProcessamento
from VinculosOperacoes vo
join TiposOperacoes tp on tp.Id_Operacao = vo.Id_Operacao
where 1=1 and vo.CodigoProcessamento = '011000' and CodigoMCC = '6011';
```

- Verificar se não possui esse vículosOperacao para o Id_Estabelecimento e Id_Produto retornado na consulta. 

-- Se já houver o vínculo para outro id_produto, pega o id_Operacão e roda a query **Parametrizacao de Operacoes** pasando também o id_estabelecimento, id_produto que deseja.  

-- Caso não seja retornado nenhum vínculo para o CodigoProcessamento e CodigoMCC, rodar consulta abaixo passando o código de processamento, para pegar o id_Operacao:
```
select * from TiposOperacoes to2 where CodigoProcessamento='011000';
```

- Com o id_Operacao, roda a query abaixo, pasando o id_Produto, id_estabelecimento e id_operacao que deseja cadastrar:

**Parametrizacao de Operacoes**
```
declare @idProduto int = 1, @id_estabelecimento int = 3, @id_operacao int = 10478
BEGIN	
    IF NOT EXISTS(SELECT TOP (1) 0 FROM ParametrosAcumuladoresTiposOperacoes WHERE id_produto = @idProduto and id_operacao=@id_operacao)
		INSERT INTO ParametrosAcumuladoresTiposOperacoes (ID_PRODUTO, ID_OPERACAO, QtdMaxDia, QtdMaxSemana, QtdMaxMes, ValorMaxDia, ValorMaxSemana, ValorMaxMes)
		Values(@idProduto, @id_operacao, 4, Null, Null, 2000, Null, Null)


		insert into vinculosoperacoescompacta  (
		                                        FlagAtivo,
			Id_Estabelecimento
			,Id_Produto
			,CodigoProcessamento
			,Id_Operacao
			,CodigoMCC)
			select
			       1,
			@id_estabelecimento
			,@idProduto
			,tpos.codigoprocessamento--'003000' -- compra
			,tpos.id_operacao      -- operacao 318
			,codigomcc from mcc
			outer apply (select id_operacao,codigoprocessamento from tiposoperacoes where Id_Operacao in (@id_operacao) ) tpos;
	END
```
-- Ao rodar a query acima, serão cadastrados todos os MCC, do id_produto preenchido para id_estabelecimento preenchido.