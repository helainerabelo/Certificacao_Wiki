Aqui encontra-se a lista de problemas já passados nas certificações anteriores e como foram resolvidos para que possa ajudar a toda a equipe:

## 1 - Cancelamento ou Desfazimento não encontrado - Valor Total:
Prestar atenção se o valor dos bits 2 (numero cartão), 4 (valor), 41 (terminal), 42 (estabelecimento), sendo que obrigatório são os 3 primeiros estarem iguais, pode ser visto na base do Odin a proc (SPR_ODIN_CANCELAR_TRANSACAO).

* Internacional
-> Para transações internacionais pode acontecer ainda que mesmo com os campos citados acima estarem iguais, ainda seja apresentada a mensagem. Dai é recomendado olhar o Bit 90, que deve vir com a informação dos bits 032 e 033. Bit 90 são os dados da transação original. - Ver no manual pág. 267

Obs.: Toda transação de cancelamento e desfazimento é precedida de uma transação de compra. Ou seja, para um cancelamento geralmente é enviada uma transação de compra e depois o envio do cancelamento da compra.


## 2 - Cancelamento parcial, sendo negado como Cancelamento não encontrado:

Conferir as seguintes informações na mensagem de entrada da transação, segundo o manual para reconhecer que é um cancelamento parcial, o Bit 24 deve estar com o valor 401, e o Bit 54 deve ter o valor original que se encontra no bit 4 da transação de compra)
Trecho no manual: consultar por "reversão parcial" Pág. 75/313


## 3 - "motivoResposta" : "OPERACAO_NAO_ENCONTRADA"

Isso acontece porque falta o tipo de operação para a transação em questão na tabela vinculosoperacoes na base do emissor, pedir para o pessoal do emissor inserir a informação quando a autorização for externa. No caso que passei foi a Dock.

* Comando para inserir na base
Insert into vinculosoperacoes (id_estabelecimento, id_produto, codigoprocessamento, id_operacao, codigomcc) values (324,10,'312000',10358,6011)

codigoprocessamento = bit 3
codigomcc = bit 18
Os demais tem que consultar nas tabelas:
id_estabelecimento - Select * from Estabelecimentos
id_produto - Select * from Produtos where Bin in (655036)  _-- consultar o bin tabela cartoes atraves do cartão real_
id_operacao - Select * from tiposoperacoes


## 4 - "motivoResposta" : "OPERACAO_COM_VALOR_INVALIDO"

É pq estourou o limite da operação que nesse caso era de 500 reais (coluna valorMaximo na tabela tiposoperacoes), então essa regra "VALIDA_VALOR_OPERACAO" barra a transação.


## 5 - "motivoResposta" : "ERRO_BUSCA_DADOS"

Esse erro acontece quando alguma procedure está desatualizada, das duas últimas vezes eu tive que perguntar a Arthur quais atualizar. Mas algumas vezes o log do Odin já informa a procedure. Geralmente é para Executar a procedure na base do emissor.
* Se o log apresentar o nome da procedure que está impactando, procurar pelo nome da procedure na base espelho 10.70.30.221, copiar colar o conteúdo em uma nova execução para a base do emissor, prestar atenção se o schema está correto e se não tiver o Drop já embutido na procedure rodar ele antes. Executar toda a procedure.
DROP PROCEDURE [dbo].[NomeDaProcedure]


## 6 - ATC DUPLICADO 

Negar uma transação com o mesmo ATC, nesse caso são passadas duas transações e a segunda deve ser negada por duplicidade, é só ativar a regra "ATF" descrição "Valida se o ATC é o mesmo que está na BASE." em REGRAS_ASSOCIACOES no Odin. Obs.: A mesma regra serviu para o EMV duplicado e para o ATC inferior ao atual.


## 7 - Não retorna bit 55

Transação 0100 consta bit 55 e no retorno 0110 o mesmo bit não é enviado.
Foi necessário ativar a regra "CRIPTOGRAMA_THALES" em REGRAS_ASSOCIACOES no Odin.

## 8 - Senha inválida sendo aprovada

Transação aprovando com senha inválida, o correto é negar 55.
Verificar se a regra SENHA_THALES está ativada, caso não, ativá-la. Essa regra faz a validação da senha.

## 9 - "motivoResposta" : "ERRO_NA_VALIDACAO"

## Caso de erro na regra cavv_thales deve ser adicionada as chaves CVK_3DS_ACS e CVK_3DS_BAN


## "content" : "Erro em callable senha_thales do conjunto class br.com.conductor.odin.core.origem.tecban.ValidadorServiceTecban."

- Na base do emissor, faz a consulta do cartão real e verifica se a coluna SenhaVisa está null:
SELECT SenhaVisa, id_cartão, * FROM cartoes where cartaohash = HASHBYTES('MD5', '4329570422721090')

- Verifica na msgEntrada o bit 52. Exemplo: 727ED158584A411B;

- Consulta as chaves atreladas ao bin:
select b.id_binschaves, b.bin , b.chave, b.checkvalue, t.descricao, *
from binschaves b join tipochave t on b.id_tipochave=t.id_tipochave
where bin in (coloca_bin_aqui)
order by b.bin asc

- Pega a chave correspondente ao IWK. No caso havia uma iwk_tecban, pois a certificação era com a bandeira tecban, nas demais bandeiras usar a IWK. Exemplo da chave: U802483CDA8757AF17AF437C79657381B

- Entra no BP HSM Commander, escolhe a opção JE.  
Preenche em Source ZPK com a chave iwk correspondente (U802483CDA8757AF17AF437C79657381B), o PIN block  com a informação do bit 52, Account NR.: Número do cartão sem os 3 primeiros números e sem o último. Clica na setinha verde.
Ao realizar a conversão, pegar o número do PIN apresentado e atualizar o banco onde a SenhaVisa estava null.


![HSM Commander.png](/.attachments/HSM%20Commander-ce016052-722d-4a29-9508-6ac9baefa676.png)



## 10 - "motivoResposta" : "BLOQUEADO_STATUS_CARTAO"
Ao realizar a consulta pelo cartão informado, foi visto que a quantidade de senhas digitadas erradas estava igual a 3 e o status do cartão estava 29. O cartão havia sido bloqueado pela quantidade de senhas digitadas erradas. Então roda a query de habilitar cartão para uso.

-- Consulta cartão real - Roda na base do emissor
SELECT * FROM cartoes where cartaohash = HASHBYTES('MD5', '5067070234438564') -- inserir o número do cartão real

-- Desbloquear CARTÃO  (HABILITAR O CARTÃO PARA USO) - Roda na base do emissor
UPDATE CARTOES SET STATUS = 1, QtdSenhasIncorretas = 0, Estagio = 6
     where cartaohash = HASHBYTES('MD5', '5067070234438564') -- inserir o número do cartão real

## 11 - "motivoResposta" : CRIPTOGRAMA_INVÁLIDO
-- Consulta as chaves atreladas ao bin - Roda na base do emissor
selectDescricao,b.id_binschaves,b.bin,b.chave,b.checkvalue,t.descricao,*
frombinschavesbjointipochavetonb.id_tipochave=t.id_tipochave
wherebinin(coloca_bin_aqui)
orderbyb.binasc

Com o arquivo das chaves da Elo, verifica se o valor da chave AC e o KCV (checkValue) estão iguais com os cadastrados no banco. Se estiver iguais, o problema é que eles estão passando o criptograma errado.

## 12 - "motivoResposta" : "CONTA_EM_COBRANCA"

Quando este erro ocorrer será necessário verificar:
- Status da conta do cartão utilizado e a Data de Vencimento de Cobranças
select status,DataVencimentoCobranca, * from Contas where Id_Conta in (110)--inserir id_conta do cartão utilizado

Conta deve ter status = 0 e Data de Vencimento Cobrança deve ser uma data futura, para que não caracterize faturamento em atraso, caso a consulta retorne alguma informação diferente desta será necessário alterar a base para voltar a transacionar com cartão;

Outra coisa que pode ser verificada também é a regra de associação "CONTA_EM_ATRASO" ao desabilitar ela também pode ser possível transacionar, porém a situação da conta permanece em cobrança, quando for realizada uma transação do tipo "EventoConsultaStatusConta" o retorno será negativo e se tratando de uma certificação este teste não será aprovado. 

## 13 - Retorno do bit 54

Quando não quiser que retorne o bit 54 deve desativar a regra RETORNA_SALDO

## 14 - "motivoResposta" : "ERRO_NA_VALIDACAO", e  "content" : "Erro em callable calcula_parcela do conjunto class br.com.conductor.odin.core.origem.mastercard.ValidadorServiceMastercard."

Quando der esse erro, provavelmente o emissor está sem a cotação do dólar. 
-- Consulta para saber se o emissor tem cotação:
```
SELECT dbo.Fc_cotacaodolar(Getdate())
```
-- Caso retorne null, procurar em outro emissor a cotação que esteja mais atualizada rodando o select abaixo:
```
select * from cotacaodolar
```
-- Copiar as informações e add no emissor que está null.