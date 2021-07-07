##1 - Descobrir o número do cartão real pelo ID do cartão:
Acessa o PIER, e procurar pelo endpoint consultarDadosImpressao:

![consultarDadosImpressao.png](/.attachments/consultarDadosImpressao-6384614c-9926-4c11-a149-1748faa2bd6a.png)

Clica no cadeado e insere o token do emissor

-- BUCAR TOKEN PIER na base 10.19.20.21 V2:
select b.id, b.SERVIDOR, B.NOME_BASE, t.*,B.* from TOKENS t
    join BASES B on t.BASE_ID = B.ID
where 1=1
 and b.SERVIDOR = '10.75.33.166' -- SUBSTITUIR DE ACORDO COM O SERVIDOR DESEJADO
 --and t.OWNER like '%Controly%'


Após, clicar no botão "Try it out". Informa o id_cartão e Execute.

-- Consulta id_cartao com o número do cartão
select id_cartao, * from CARTOES where cartao = '5067000002705146' -- esse número não é do cartão real

Ao executar, retorna os dados do cartão, e cartão real estará nesse campo:  "numeroCartao": "5067074204105146"


## 2 - Descobrir senha real do cartão:
Acessa o PIER, e procurar pelo endpoint consultarSenhaCartao:
![consultarSenhaCartao.png](/.attachments/consultarSenhaCartao-716890ed-1f45-4e84-b4b8-5daf0a53730d.png)


Clica no cadeado e insere o token do emissor

-- BUCAR TOKEN PIER na base 10.19.20.21 V2:
select b.id, b.SERVIDOR, B.NOME_BASE, t.*,B.* from TOKENS t
    join BASES B on t.BASE_ID = B.ID
where 1=1
 and b.SERVIDOR = '10.75.33.166' -- SUBSTITUIR DE ACORDO COM O SERVIDOR DESEJADO
 --and t.OWNER like '%Controly%'


Após, clicar no botão "Try it out". Informa o id_cartão e Execute.

-- Consulta id_cartao com o número do cartão
select id_cartao, * from CARTOES where cartao = '5067000002705146' -- esse número não é do cartão real

-- Consulta id_cartao com o número do cartão real
SELECT id_cartão, * FROM cartoes where cartaohash = HASHBYTES('MD5', '5067074204105146')

Ao executar, retornará a senha real do cartão