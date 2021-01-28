Aqui encontra-se a lista de problemas já passados nas certificações anteriores e como foram resolvidos para que possa ajudar a toda a equipe:

## 1- Cancelamento ou Desfazimento não encontrado - Valor Total:
Prestar atenção se o valor dos bits 2 (numero cartão), 4 (valor), 41 (terminal), 42 (estabelecimento), sendo que obrigatório são os 3 primeiros estarem iguais, pode ser visto na base do Odin a proc (SPR_ODIN_CANCELAR_TRANSACAO).

* Internacional
-> Para transações internacionais pode acontecer ainda que mesmo com os campos citados acima estarem iguais, ainda seja apresentada a mensagem. Dai é recomendado olhar o Bit 90, que deve vir com a informação dos bits 032 e 033. Bit 90 são os dados da transação original. - Ver no manual pág. 267

Obs.: Toda transação de cancelamento e desfazimento é precedida de uma transação de compra. Ou seja, para um cancelamento geralmente é enviada uma transação de compra e depois o envio do cancelamento da compra.


## 2- Cancelamento parcial, sendo negado como Cancelamento não encontrado:

Conferir as seguintes informações na mensagem de entrada da transação, segundo o manual para reconhecer que é um cancelamento parcial, o Bit 24 deve estar com o valor 401, e o Bit 54 deve ter o valor original que se encontra no bit 4 da transação de compra)
Trecho no manual: consultar por "reversão parcial" Pág. 75/313


## 3- "motivoResposta" : "OPERACAO_NAO_ENCONTRADA"

Isso acontece porque falta o tipo de operação para a transação em questão na tabela vinculosoperacoes na base do emissor, pedir para o pessoal do emissor inserir a informação quando a autorização for externa. No caso que passei foi a Dock.

* Comando para inserir na base
Insert into vinculosoperacoes (id_estabelecimento, id_produto, codigoprocessamento, id_operacao, codigomcc) values (324,10,'312000',10358,6011)

codigoprocessamento = bit 3
codigomcc = bit 18
Os demais tem que consultar nas tabelas:
id_estabelecimento - Select * from Estabelecimentos
id_produto - Select * from Produtos where Bin in (655036)  _-- consultar o bin tabela cartoes atraves do cartão real_
id_operacao - Select * from tiposoperacoes


## 4- "motivoResposta" : "OPERACAO_COM_VALOR_INVALIDO"

É pq estourou o limite da operação que nesse caso era de 500 reais (coluna valorMaximo na tabela tiposoperacoes), então essa regra "VALIDA_VALOR_OPERACAO" barra a transação.


## 5- "motivoResposta" : "ERRO_BUSCA_DADOS"

Esse erro acontece quando alguma procedure está desatualizada, das duas últimas vezes eu tive que perguntar a Arthur quais atualizar. Mas algumas vezes o log do Odin já informa a procedure. Geralmente é para Executar a procedure na base do emissor.
* Se o log apresentar o nome da procedure que está impactando, procurar pelo nome da procedure na base espelho 10.70.30.221, copiar colar o conteúdo em uma nova execução para a base do emissor, prestar atenção se o schema está correto e se não tiver o Drop já embutido na procedure rodar ele antes. Executar toda a procedure.
DROP PROCEDURE [dbo].[NomeDaProcedure]


## 6- ATC DUPLICADO 

Negar uma transação com o mesmo ATC, nesse caso são passadas duas transações e a segunda deve ser negada por duplicidade, é só ativar a regra "ATF" descrição "Valida se o ATC é o mesmo que está na BASE." em REGRAS_ASSOCIACOES no Odin. Obs.: A mesma regra serviu para o EMV duplicado e para o ATC inferior ao atual.