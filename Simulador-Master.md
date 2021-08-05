## 1 - "motivoResposta" : "TRANSACAO_TARJA_SEM_DADOS_DE_TRILHA"

Quando a tabela for do tipo MDES

Erro pode ocorrer porque o Bit 35 não está sendo enviado na mensageria de entrada.

Verificar se o NtwOutcome está presente. Informações passadas pelo BMG:
- Vocês estão aplicando o serviço de OBS 50, 52. O correto deveria de ser OBS 50, 51.

![image.png](/.attachments/image-5a9a9831-b5cc-4842-8b8e-9d59833f7da8.png)

Porém, mesmo aplicando dessa forma, continuava apresentando o erro.

A solução foi remover o NtwOutcome do cenário, deixando só no cartão.

## 2 - Final Authorization

Quando por uma Final Authorization, o DE48SE61, incluir as 5 opções e colocar o valor 1 em todas.
O DE61, a posição subcampo 7, deve ser 0, exemplo: 000000**0**0004018406312915210.

## 3 - CashOut
Utilizar a moeda Real 986 e o Adquirente Brasil (DE32) = 999698
Quando o dinheiro é fornecido sem a compra de acompanhamento, o total,  o valor da transação em DE 4 (valor, transação) deve ser igual ao cashback no DE 54 (Montantes Adicionais), subcampo 4 (Montante).