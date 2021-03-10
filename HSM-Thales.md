Descobrindo "Dados do PIN" - Bit 52

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


