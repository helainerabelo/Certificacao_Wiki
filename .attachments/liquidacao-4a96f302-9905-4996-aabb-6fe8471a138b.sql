use cateno

/*
############################################################################################################
#####	Para versões do sgr < do que a com final 12, usar esses update's abaixo para atualizar token	####
#####	do cipher para o sgr descriptografar o cartão, olhar na base controleacesso_new na tabela   	####
#####	plataformas_token com o id_emissor que deseja qual o token do cipher usado.						####
#####																									####
#####	OBS: O SGR de homolog já está em uma versão com final maior que a 12, falar com alguém do SGR   ####
#####	para saber como configurar a url e o token do cipher.											####
#####																									####
############################################################################################################
*/

update parametrosemissores
	set descricao = 'http://10.75.30.90:8080' -- URL do cipher usada no momento que foi disponibilizado esse script
	where codigo = 'URLCIPHER'

update parametrosemissores
	set descricao = 'bf83e8bd445249efb0db3c11f264ae18' --exemplo de token
	where codigo = 'TOKENCIPHER'

/*
############################################################################################################
#####	Como renomear o arquivo de liquidação caso não esteja nomeado certo, seguindo a ordem abaixo	####
#####	CODBANDEIRAELO 1																				####
#####	CODBANCEMISSORCARTAO 2																			####
#####	CODELODAPROCESSADORA 3																			####
#####																									####
#####	Após esses 3 parâmetros, vem um letra: C -> crédito, D -> Débito								####
#####	Por último a data yyyyMMDD seguindo de um número por exemplo 01									####
#####	Exemplo: 00709543106C2020092401																	####
#####																									####
#####	Executar a query abaixo para visualizar os parâmetros citados acima								####
############################################################################################################
*/

select * from parametrosemissores
	where codigo in (
		'CODBANDEIRAELO',
		'CODBANCEMISSORCARTAO',
		'CODELODAPROCESSADORA'
	)
		order by descricao

/*
####################################################################################################
####	Após importar o arquivo no SGR, verificar nas tabelas abaixo se o arquivo foi importado	####
####	e quais as transações contidas no arquivo												####
####	OBS: colocar o id do arquivo que você quer visualizar na incomingelo					####
####################################################################################################
*/
select top 100 * from ArquivoIncomingElo order by 1 desc

select * from incomingelo where id_arquivo = id_arquivo

-- Caso queria visualizar os detalhes da transação, olhar a eventosexternoscomprasnaoprocessados
-- id_autorizacaoo pode ser visualizado na tabela incomingelo, na query já possui um exemplo de como 
-- colocar o id_autorizacao
	
select top 100 id_autorizacao, id_conta, codigoautorizacao, status, id_incoming, ID_OPERACAO, valorCompra, * 
	from EventosExternosComprasNaoProcessados as a where id_autorizacao in(
	1405163,
	1405158
	) order by a.id_autorizacao

/*
####################################################################################################
####	Para processar, é necessário executar as 3 procedures abaixo uma de cada vez			####
####	seguindo a ordem.																		####
####																							####
####	Os parâmetros são os seguintes:															####
####	dataMovimento -> ex.: '2020-09-25'														####
####	vencimentoPadrao -> ex.: '2020-09-25'													####
####	idContaInicial -> ex.: 0																####
####	idContaFinal -> ex.: 9999999															####
####																							####
####	OBS: as datas é bom colocar o do dia que está executando as procedures,					####
####	caso ocorra algum erro com a data, ir avançando ela até conseguir executar				####
####																							####
####	OBS2: é possível que exista um idConta maior que o do parâmetro idContaFinal,			####
####	verificar o id_conta das transações antes de executar									####
####																							####
####	OBS3: as procedures estão comentadas para não serem executadas sem querer				####
####################################################################################################
*/


-- Caso queira visualizar qual foi o último dia que foi feito o processamento
-- antes de executar as procedures
   SELECT *    
	FROM dbo.MOVIMENTOSCOMPRAS 
	order by 1 desc

--exec SPR_Batch_ConciliacaoELO '2020-10-29','2020-10-29',0,99999999

--exec SPR_ProcessamentoPagamentos '2020-10-29','2020-10-29',0,99999999

--exec spr_processacompras '2020-10-29','2020-10-29',0,99999999

/*
#####################################################################################################
####	Após executar as queries e tudo ocorrer sem erro, visualizar se as transações			 ####
####	foram para a eventosexternoscomprasprocessados seguindo como foi feito com				 ####
####	eventosexternoscomprasnaoprocessados													 ####
#####################################################################################################
*/

select top 1000 status, id_conta, Id_Estabelecimento, Id_Incoming,Id_Autorizacao, ID_OPERACAO, * from EventosExternosComprasProcessados 
where 1=1
and id_autorizacao in (
1405163,
1405158
)

/*
####################################################################################################
####	Essa query é usada para pegar o registro para realizar TE15, TE35, TE40, TE55			####
####	Nela você verá o código de autorização e o registro(que é usado no script de chargeback)####
####################################################################################################
*/

select 
	SUBSTRING(REGISTRO,150,6) as codigo,
	SUBSTRING(REGISTRO,77,12) as valor ,
	SUBSTRING(registro,27,23) as registro,  
	* from  InformacaoRegistroElo 
		where Id_ArquivoIncomingElo = 1817
			and subcodigo = '00' 
			-- Esse último and, descomentar somente caso queira filtrar
			-- apenas pelo código processamento direto
			--and SUBSTRING(REGISTRO,150,6) in (
			--'576422'
			--)
			order by 1

-- Para ver as transações que foram dadas o chargeback
select * from controlechargebacks
select * from COMPRASCONTESTADAS

/*
	Algumas alterações que foram necessárias fazer durante a liquidação e também outras coisas
	que ainda vou organizar
*/

/*
######################################################################################
####	Coloca flagErro 1 com o códigoNegacao E16, fazer isso quando solicitado	  ####
####	no arquivo de liquidação pedindo TE01									  ####
######################################################################################
*/

update incomingelo
	set flagErro = 1,
	codigoNegacao = 'E18'
	where 1=1
	and id_autorizacao in (1152) 
	--and id_incoming = 295

/*
############################################################################################
####	Altera o CodigoCredenciadora para 7777 quando pedido na arquivo de liquidação	####
############################################################################################
*/
update transacoeselo
	set CodigoCredenciadora = '7777'
	where codigoautorizacao = '372372'

/*
#############################################################################################
####	Altera o id_codigochargeback quando no arquivo de liquidação pede alteração		 ####
####	no motivo do chargeback.														 ####
####																					 ####
####	OBS: os id_codigochargeback que pediram até agora foi 30 e 99					 ####
#############################################################################################
*/
update controlechargebacks
	set id_codigochargeback = motivo_pedido_pela_elo
	where 1=1 
	and id_incoming in (
	1294103
	) 
	and status = 0
select * from controlechargebacks where 1=1 
	and id_incoming in (
	1294103,
	1294105,
	1294102
	) 
select * from comprascontestadas
select * from CodigosChargeback
select * from ReportesFraude

-- Usado apenas quando não altera a flagConciliado pra 1 depois de rodar o batch
UPDATE ARQUIVOINCOMINGELO          
 SET FLAGCONCILIADO = 1          
 WHERE FLAGCONCILIADO = 0

/*
########################################################################################################
####	Alteração feita no md5 e na flagConciliado para poder enviar o arquivo de novo o arquivo,	####
####	feito porque ocorreu algum erro no processamento do arquivo.								####
####																								####
####	OBS: A alteração que faço no MD5 é basicamente somando 1 no valor,							####
####	lembrando que é hexadecimal.																####
########################################################################################################
*/
update ArquivoIncomingElo
	set md5 = '9f0569acf7aceac611b72571e16d4315', FlagConciliado = 1
	where id_arquivoincomingelo = 1
select top 100 *from ArquivoIncomingElo order by 1 desc


/*
####################################################################################################
####	Foi necessário fazer esse update em casos de arquivos de liquidação que continha saque  ####
####	que por algum motivo deixavam a flagErro = 1, com códigoNegacao e sem o id_autorizacao. ####
####	Para visualizar o id_autorização, foi olhado na eventosexternoscomprasnaoprocessados	####
####	e comparado com o codigoautorizacao e valor contidos no arquivo							####
####																							####
####	Também foi necessário atualizar, id_incoming, valores e status na						####
####	EventosExternosComprasNaoProcessados													####
####																							####
####################################################################################################
*/

-- São apenas exemplos de id's e valores nas duas queries
update incomingelo
	set Id_Autorizacao = 1405160
	where id_incoming = 1294106

update EventosExternosComprasNaoProcessados
	set Id_Incoming = 1294106, 
		valorCompra = '220.00', 
		valorParcela = '220.00',
		valorContrato = '220.00',
		PrimeiraParcela = '220.00',
		valorDestino = '220.00',
		ValorOrigem = '220.00'
	where Id_Autorizacao = 1405163

update EventosExternosComprasNaoProcessados
	set status = 0
	where id_autorizacao in (
	1405163,
	1405158
)

 -- Usado em uma base que estava com o setup incompleto
INSERT INTO statuscontestacao
VALUES
(44,	NULL,	'Finalizado'						,0	,0	,0	,0,  	1),
(45,	NULL,	'Credito enviado pela bandeira'		,1	,1	,0	,0,  	1),
(46,	NULL,	'Pré-Arbitragem FULL ELO'			,0	,0	,0	,0,  	1),
(47,	NULL,	'Pré-Arbitragem Parcial ELO'		,0	,0	,0	,0,  	1),
(48,	NULL,	'Retorno Pré-Arbitragem ELO'		,1	,1	,0	,0,  	1),
(56,	NULL,	'Pré-Arbitragem FULL Mastercard'	,0	,0	,0	,0,  	1),
(57,	NULL,	'Pré-Arbitragem Parcial Mastercard'	,0	,0	,0	,0,  	1),
(58,	NULL,	'Retorno Pré-Arbitragem Mastercard'	,1	,1	,0	,0,  	1)