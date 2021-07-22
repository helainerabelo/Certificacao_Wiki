**1- Descobrindo o CVV/CVE do cartão**

![image.png](/.attachments/image-244ad500-1540-4356-ad19-e0dcde34ffe9.png)

Observações:
Onde o primeiro campo será informado de acordo dependendo da tabela abaixo (concatenando os dois valores, sem espaço ou barra, C2KAC2KB):
![image.png](/.attachments/image-884cab19-e4e0-441d-b8a5-095c69f31585.png)

Consultas:

No caso do CVE2 = CVV2 e usa o valor do III, as chaves C2KA e C2KB e demais pega na base do emissor com o seguinte select, (coluna chave)

-- select que retorna as chaves C2KA/C2KB e etc
`select Descricao, * from BinsChaves b join TipoChave c on b.Id_TipoChave = c.Id_TipoChave where bin = 650516`

Obs.:
Para configurar a data e saber se mês vem antes do ano:
CVV1 - AAMM (tarja)
CVV2 - MMAA (manual)
ICVV - AAMM (chip)

<br></br>
**2- Descobrindo "Dados do PIN" - Bit 52**

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
**3- Descobrir SenhaVisa (caso a coluna esteja vazia na tabela Cartoes)**

![image.png](/.attachments/image-ba44da46-ae57-44a1-bac0-7e91e255c407.png)

<br></br>
**4- Descobrir a senha real do cartão**

![image.png](/.attachments/image-393ba639-5bda-434b-9604-2fb309fc9889.png)


