Altera o status do cartão com base no código da tabela StatusCartao que representa "Suspeita de Fraude - Preventivo" no emmissor desejado:

`select * from StatusCartao`

**OBS:** Se atentar para a coluna Status para pegar o id correto e não a id_StatusCartão
![image.png](/.attachments/image-3840d759-c618-428e-9e0a-42972bbf7560.png)

Atualizar o status do cartão passando o número real do cartão e o id de Suspeita de Fraude:
`UPDATE CARTOES SET STATUS = 32 where cartaohash = HASHBYTES('MD5', '4078430049318403')`


Se quiser que negue por 59, precisa atualizar na tabela StatusCartao a coluna RespAutorizadorVisa (se for bandeira Visa), na linha do Suspeita Fraude: 

`UPDATE StatusCartao SET RespAutorizadorVisa = N'59' where id_StatusCartao = 33 and Status = 32`