**1- Descobrindo "Dados do PIN" - Bit 52**

![image.png](/.attachments/image-fc424b51-6d15-4f79-b6c6-beac0bfc6541.png)

Consultas:

-> Para descobrir a chave IWK na base do emissor
```
Select b.id_binschaves, b.bin , b.chave, b.checkvalue, t.descricao, *
from binschaves b join tipochave t on b.id_tipochave=t.id_tipochave
where bin in (BinCartao) -- BinCartao = 6 dígitos do cartão real
order by t.Descricao asc
```

-> Para descobrir o valor da SenhaVisa
```
Select SenhaVisa, SenhaVisaCriptografada, * from cartoes where cartaohash = HASHBYTES('MD5', '5094670362013464')
-- 5094670362013464 = Número do cartão real
```
<br></br>
**2- Descobrir SenhaVisa (tabela Cartoes)**

![image.png](/.attachments/image-ba44da46-ae57-44a1-bac0-7e91e255c407.png)

<br></br>
**3- Descobrir a senha real do cartão**

![image.png](/.attachments/image-040a63d5-c026-4158-a8d0-9aab73ce41a8.png)


