## Regra de validação do odin para validar transação duplicada:
---

IF EXISTS (  
    SELECT TOP 1 0 FROM AUTORIZACOES (NoLock)  
    WHERE  
        CARTAO = (SELECT CARTAO FROM CARTOES WHERE CARTAOHASH = hashbytes('md5', @CartaoReal) AND Bin = LEFT(@CartaoReal, 6))  
        AND VALOR = @ValorCompra  
        AND NSUORIGEM = @NsuOrigem  
        AND IDENTIFICACAOTRANSACAO = @IdentificacaoTransacao  
    )  
BEGIN  
    RAISERROR (15600,-1,-1, 'TRANSACAO DUPLICADA')  
END


## Como fazer no simulador?
---
Além dos campos bits que provavelmente já existam na transação (004 -> valor, 011 -> NSU) colocar também o bit 007 no qual se refere a data e hora da transação.

Basta enviar uma transação normalmente sem o bit 007 de preferencia para ir o padrão do simulador, copiar o bit 007 dela no odin e inserir o bit no simulador com o valor copiado.

## Exemplo de mensageria
---
PagSeguro - Simulador Debito

057211/06/2021 17:34:17:3085|10.19.21.167|087|0200|Conductor||8|[*]002|5322213517619325|003|000000|004|000000002699|005|000000002699|006|000000002699|007|0611173350|009|61000000|010|61000000|011|000001|012|173350|013|0611|014|2605|015|0611|016|0611|018|5946|022|902|032|728384008|033|9000000283|035|5322213517619325=26052060000082400000|037|340000400015|041|MTF TEST|042|ABC123TESTMTF19|043|STL photo              St. Louis      MO|048|00;R|049|840|050|840|051|840|057|010|061|00000040002008406338500000|063|MS1000009793|126|000          NX123ABCDEFABCDEFGHIJKLMNOPQRSTUVWXYZ|\r\n



