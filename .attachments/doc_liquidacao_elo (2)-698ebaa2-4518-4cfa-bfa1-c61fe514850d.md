# Liquidação Elo

Para realizar a liquidação, é necessário ter acesso a algumas ferramentas, são elas:

* **SGR**: para processamento do arquivo de liquidação e gerar o arquivo de retorno;
* **PIER**: onde em alguns caso será feito a contestação;

Também são necessários alguns scripts que serão mostrados nas seções abaixo, mas dentre os scripts, um é usado em todos os casos que é o ***liquidacao.sql***, nele contém as procedures que são executadas para processar o arquivo.

> Todos os arquivos **.sql** estão disponibilizados no repositório.

## Passos padrões em todos os casos

## Nomear o arquivo para importação

Caso o arquivo não venha nomeado corretamente, nomeá-lo da seguinte maneira. Vá até a base do emissor que está fazendo a liquidação e execute a query abaixo.

```sql
SELECT * FROM parametrosemissores
	WHERE codigo IN (
		'CODBANDEIRAELO', -- posição 1
		'CODBANCEMISSORCARTAO', -- posição 2
		'CODELODAPROCESSADORA' -- posição 3
	)
		ORDER BY codigo
```

Você precisa pegar os valores da coluna *descricao* e de acordo com a posição descrita na query. Abaixo está um exemplo de como tem que ficar esta primeira parte.

```
00709543106
```

Após isso, colocar uma letra, nesse caso **C**, a data referente as transações seguindo o padrão **YYYYMMDD** e por último um número sequencial. O nome do arquivo ficará como exemplo abaixo.

```
00709543106C2020093001.txt
```

Com o arquivo renomeado, será necessário importá-lo usando o **SGR**, para importar precisa deixar o arquivo no seguinte caminho:

```
/sgr/importacao/conciliação new elo/builderjobimportararquivoincoming/
```

Agora basta ir no **SGR**, no menu ***Execuções*** e depois em ***Executar Rotinas***, na página você irá colocar as seguintes informações:

```json
Aplicação: Conciliação NEW ELO
Base de Dados: "a base que deseja importar o arquivo"
Rotinas: Importar Arquivo Incoming
Data: "mesma data que você colocou no nome do arquivo"
```

Depois basta clicar no botão *Executar* e acompanhar se já foi importado o seu arquivo em **Execuções** -> **Histórico**. Quando ele estiver com status *100%*, você pode ir na base e verificar se ele foi importado e as transações que vieram no arquivo, usando a seguinte query.

```sql
-- Para visualizar se o arquivo foi importado
SELECT TOP 100 * FROM ArquivoIncomingElo 
    ORDER BY 1 DESC

-- Para visualizar as transações que vieram no arquivo
SELECT * FROM incomingelo 
    WHERE id_arquivo = id_arquivo_que_deseja_procurar 
    ORDER BY 1 DESC
```

Sempre é bom olhar se as transações que foram importadas nesse arquivo estão na tabela **EventosExternosComprasNaoProcessados**.

Agora, para processar o arquivo na base, basta executar as procedures que estão no arquivo ***liquidacao.sql***, são elas:

```
SPR_Batch_ConciliacaoELO
SPR_ProcessamentoPagamentos
SPR_processacompras
```

Após executar as 3 procedures, olhar se as transações foram para a tabela **EventosExternosComprasProcessados**. Caso elas não tenham ido, debugar a procedure *SPR_processacompras* e encontrar o porque de não ter sido processada as transações e quando encontrar o porque, reexecutar as 3 procedures citadas acima alterando as datas.

> Todas as queries que foram citadas acima estão no arquivo liquidacao.sql, contendo lá também alguns comentários de como executá-las.

> Após olhar todos os tópicos com o nome Liquidação, olhar o tópico GERAR ARQUIVO OUTGOING

Os passos a seguir, só poderão ser executados após executar as 3 procedures e tudo tiver ocorrido ok.

## Liquidação TE01

Para TE01, é necessário pegar o id_autorizacao ou id_incoming através do código autorização indicado pela ELO. Para pegar esses id's basta executar o query abaixo.

```sql
SELECT ID_INCOMING,ID_AUTORIZACAO, * 
	FROM EVENTOSEXTERNOSCOMPRASPROCESSADOS 
		WHERE 1=1
		AND CODIGOAUTORIZACAO IN (codigo_autorizacao_que_deseja_procurar)
```

Após pegar o id_autorizacao ou id_incoming, basta apenas executar a query abaixo colocando a codigoNegacao indicado pela ELO.

```sql
UPDATE incomingelo
	SET flagErro = 1,
	codigoNegacao = 'codigo_indicado_pela_ELO'
	WHERE 1=1
	AND id_autorizacao IN (id_autorizacao) -- caso tenha o id_autorizacao, usar essa linha
	AND id_incoming IN (id_incoming) -- caso tenha o id_incoming, usar essa linha
```

## Liquidação TE15

Para TE15, é necessário usar o script ***contestação de compra.sql***.

Para executar esse script é necessário ter 3 valores:

* @descricao: no caso da TE15 o valor é 'Chargeback', lembrando que no script disponibilizado já possui o valor necessário, sendo necessário somente descomentar caso esteja comentado;
* @Data: data equivalente a data que está no nome do arquivo;
* @referenceNumber: esse valor vai ser obtido de acordo com a transação que a elo passar no email. Para visualizar o valor de acordo com o código de processamento, basta executar o script que será disponibilizado abaixo e pegar o valor da coluna *valor*.

```sql
SELECT 
	SUBSTRING(REGISTRO,150,6) AS codigo,
	SUBSTRING(REGISTRO,77,12) AS valor ,
	SUBSTRING(registro,27,23) AS registro,  
	* FROM  InformacaoRegistroElo 
		WHERE Id_ArquivoIncomingElo = id_do_arquivo
			AND subcodigo = '00' 
			--Caso queira filtrar direto pelo código de processamento
			--usar a query junto com a condição abaixo
			AND SUBSTRING(REGISTRO,150,6) IN (
			'841861' -- exemplo de código de processamento
			)
			ORDER BY 1
```

Após obter os 3 valores, colocá-los nos seus respectivos lugares e executar o script ***contestação de compra.sql***.

> Quando é executado esse script, é mostrado 3 select's, caso não saia os 3, debugar o script para saber o que está faltando.

Caso a elo solicite para alterar o motivo da TE15, executar o script abaixo colocando o motivo solicitado.

```sql
UPDATE controlechargebacks
	SET id_codigochargeback = motivo_solicitado_pela_elo
	WHERE 1=1 
	AND id_incoming IN (
	id_incoming_transacao -- id_incoming que deseja alterar o id_codigochargeback
	) 
	AND status = 0
```

> Em alguns casos, foi solicitado para usar o motivo 99 e não tinhamos cadastrado na base, então o sgr não colocou no arquivo esse motivo.

## Liquidação TE16

Para fazer a liquidação para TE16, é necessário o uso da ferramenta **PIER**, a partir dela que será realizada a contestação de crédito.

Primeiro passo, é pegar o id_eventopagamento da transação usando a query abaixo

```sql
SELECT Id_EventoPagamento, Id_Operacao, Id_Estabelecimento, * 
	FROM EventosExternosPagamentos
	WHERE CODIGOAUTORIZACAO = codigo_autorizacao
```

> Checar se o evento possui Id_Estabelecimento, caso não possuir, incluir um Id_Estabelecimento válido para a bandeira ELO.

Após pegar o Id_EventoPagamento, é necessário dois endpoints do **PIER** para poder dar o chargeback crédito.

```json
POST - /api/cartoes/contestacoes/creditos

headers: 
	access_token: token_emissor_pier
	Content-Type: application/json

body: 
{
	"idEventoPagamento": idEventoPagemento,
	"responsavel": "nome.ad",
	"historico": "certificacao elo"
}
```

Logo em seguida, executar a query abaixo para verificar se inseriu na tabela **CREDITOSCONTESTADOS** e pegar o id para fazer requisição para o outro endpoint.

```sql
-- Buscar id para a contestação criada anteriormente, se basear pelo id_eventopagamento

SELECT * FROM CREDITOSCONTESTADOS
	WHERE Id_EventoPagamento = id_eventopagamento
```

> Substituir {id_creditocontestado} no endpoint pelo id da tabela CREDITOSCONTESTADOS.

Como é TE16, então o idStatusContestacao tem que ser 1, pois é o id para Chargeback.

No campo *idCodigoChargebackCredito*, colocar o motivo que a ELO pediu. É bom antes olhar se esse motivo está mapeado na base para a bandeira ELO.

```json
PUT - /api/cartoes/contestacoes/creditos/{id_creditocontestado}

headers: 
	access_token: token_emissor_pier
	Content-Type: application/json

body: 
{
    "idStatusContestacao": 1,
    "responsavel":"nome.ad",
    "historico":"certificacao elo",
    "idCodigoChargebackCredito": motivo_solicitado_elo, // exemplo é o 30
    "status": 2,
    "mensagemTextoEmissor":"SELF-TESTE - DESCRIÇÃO DA DISPUTA"
}
```

Após a requisição, verificar se foi inserido na tabela **ControleChargebacks_Creditos**

```sql
SELECT * FROM CONTROLECHARGEBACKS_CREDITOS
```

Caso queira checar se o **SGR** irá pegar a transação que foi dada o Chargeback, usar a query abaixo, caso a query não retorne nada, checar o porque, pois se não concertar, a transação não irá sair no arquivo de outgoing.

```sql
SELECT IR.*,
	COC.id as id_controle,
	CC.ID,
	CC.DataContestacao,
	COC.Id_codigoChargebackCredito,
	COC.MensagemTextoEmissor,
	1 as FlagEnviaDoc,
	CC.Id_StatusContestacao,
	EECP.DataPagamento,
	AUT.ModoEntrada,
	CT.Id_BinsChave,
	CT.CriptografiaHSM,
	CC.valorParcial
	FROM InformacaoRegistroElo IR (nolock)
	INNER JOIN IncomingElo IE (nolock) on IR.Id_IncomingElo = IE.Id_Incoming
	INNER JOIN ArquivoIncomingElo aie (nolock) on aie.Id_ArquivoIncomingElo = IE.Id_Arquivo
	INNER JOIN EventosExternosPagamentos (nolock) EECP on EECP.Id_Incoming = IE.Id_Incoming
	INNER JOIN Autorizacoes AUT (nolock) on AUT.Id_Autorizacao = EECP.Id_Autorizacao
	INNER JOIN CREDITOSCONTESTADOS CC (nolock) ON eecp.Id_EventoPagamento = cc.Id_EventoPagamento
	INNER JOIN ControleChargebacks_Creditos (nolock) COC  on COC.Id_creditoContestado = CC.Id
	INNER JOIN Estabelecimentos es (NOLOCK) ON es.Id_Estabelecimento = EECP.Id_Estabelecimento AND es.Id_Bandeira = 7
	INNER JOIN Cartoes CT (NOLOCK) ON CT.cartao = IE.cartao
	WHERE COC.status = 0 and aie.frente = 0 and IE.TE IN ('05', '06') and CC.Id_StatusContestacao IN (1)
	and aie.flagDebito = 0
	ORDER BY IR.id_incomingElo, IR.subCodigo
```

## Liquidação TE35

Os passos para TE35 são semelhantes ao passos da TE15, colocando os mesmos dados da TE15, trocando apenas o valor ***@descricao*** para *Reversao*. Vale destacar que é necessário apenas descomentar o trecho do script que tem esse valor.

```sql
-- Exemplo de como tem que deixar no script contestação de compra.sql

--Declare @descricao varchar(30) = 'Pré-Arbitragem FULL ELO' -- te 55
Declare @descricao varchar(30) = 'Reversao' -- te 35
--Declare @descricao varchar(30) = 'Chargeback' -- te 15
```

> Lembrar de deixar a data igual a que foi dado o chargeback(TE15), pois é o que diz o manual, então caso tenha dado Chargeback para uma transação com o valor @data = '2020-10-21 09:00:00.000', por exemplo, a Reversão(TE35) deve ter o mesmo valor.

Caso peça para alterar o motivo, fazer do mesmo jeito da TE15.

## Liquidação TE36

Para TE36, como é uma reversão de um crédito contestado anteriormente, basta apenas executar essa query abaixo.

```sql
-- O id_statuscontestacao é 2, pois é o id referente a uma reversão na tabela STATUSCONTESTACAO

UPDATE ControleChargebacks_Creditos
	SET id_statuscontestacao = 2, status = 0
	WHERE id = id_creditocontestado -- Id do crédito contestado que deseja reverter

UPDATE CREDITOSCONTESTADOS
	SET id_statuscontestacao = 2,
	WHERE id = id_creditocontestado -- Id do crédito contestado que deseja reverter
```

Caso queira checar se o **SGR** irá pegar a transação que foi dada o Chargeback, usar a última query mostrada na seção da TE16 alterando o *Id_StatusContestacao* para 2, caso a query não retorne nada, checar o porque, pois se não concertar, a transação não irá sair no arquivo de outgoing.

## Liquidação TE40

Para a TE40, é necessário o script ***reporte fraude.sql***.

Para executar esse script é necessário ter 2 valores:

* @Data: data equivalente a data que está no nome do arquivo;
* @referenceNumber: esse valor vai ser obtido de acordo com a transação que a elo passar no email. Para visualizar o valor de acordo com o código de processamento, basta executar o script que será disponibilizado abaixo e pegar o valor da coluna *valor*.

```sql
SELECT 
	SUBSTRING(REGISTRO,150,6) AS codigo,
	SUBSTRING(REGISTRO,77,12) AS valor ,
	SUBSTRING(registro,27,23) AS registro,  
	* FROM  InformacaoRegistroElo 
		WHERE Id_ArquivoIncomingElo = id_do_arquivo
			AND subcodigo = '00' 
			--Caso queira filtrar direto pelo código de processamento
			--usar a query junto com a condição abaixo
			AND SUBSTRING(REGISTRO,150,6) IN (
			'841861' -- exemplo de código de processamento
			)
			ORDER BY 1
```

Após obter os 2 valores, colocá-los nos seus respectivos lugares e executar o script ***reporte fraude.sql***.

## Liquidação TE44

Nessa TE apenas geramos o arquivo de outgoing após executar as 3 procedures citadas no começo.

## Liquidação TE55

> Documentação futura

## Gerar Arquivo Outgoing

Após ter feito a liquidação para as TE's desejada, ir ao **SGR** e seguir o passos abaixo.

Clicar no menu ***Execuções*** e depois em ***Executar Rotinas***, na página você irá colocar as seguintes informações:

```json
Aplicação: Conciliação NEW ELO
Base de Dados: "a base que deseja gerar o arquivo outgoing"
Rotinas: Outgoing - CERT
Data: "mesma data que você colocou no nome do arquivo"
```

Depois basta clicar no botão *Executar* e acompanhar se já foi gerado o seu arquivo em **Execuções** -> **Histórico**. Quando ele estiver com status *100%*, você pode clicar no botão que é um olhinho e na próxima janela clicar para fazer o download.


### Contribuidores

- Edson Alves (edson.alves@conductor.com.br)