## Negar com modo de entrada 01:
01| Manual | Número do cartão foi digitado manualmente no POS, incluindo transações MOTO.
- Ativar a regra 121 | NAO_PERMITE_MANUAL_CARTAO_FISICO | Regra que verifica se a transação é um evento com modoEntrada Manual e cartão fisico e a nega, permitindo apenas cartões virtuais';


## Negar com modo de entrada 81:
81 | Contactless (Indicador de Identificador de Rádio Frequência) –  Tarja magnética |
▪ Transações Contactless ZIP (Tap and Pay) com os dados de tarja obtidos do CHIP
▪ Transações Contactless utilizando dispositivos móveis utilizando tarja magnética.
- Ativar a regra 147 | NAO_PERMITE_CONTACTLESS_TARJA | Nega modo de entrada contactless tarja simulada


## Negar com modo de entrada 83:
83 | Contactless (Indicador de Identificador de Rádio Frequência) – Chip |
▪ Transações Contactless Chip (Tap and Pay)
▪ Transações Contactless utilizando dispositivos móveis utilizando dados de CHIP.
▪ Transações Contactless utilizando dispositivos móveis utilizando dados de CHIP tokenizados.
- Ativar a regra 113 | NAO_PERMITE_CONTACTLESS | Nega todas as transações de contactless

## Negar com modo de entrada 86:
86 | Mudança de interface Contactless | Identifica quando uma transação de cartão com CHIP com dupla interface muda de CHIP Contactless para CHIP com Contato
- Ativar a regra 148 | NAO_PERMITE_MUDANCA_DE_INTERFACE', | Nega modo de entrada mudanca de interface');


## Negar com modo de entrada 90: 
90 |Autorizações de voz
- Ativar a regra 142 NAO_PERMITE_AUTORIZACAO_VOZ_CARTAO_FISICO |Regra que nega transações por voz

## Negar com modo de entrada 91:
91 | Voice Response Unit (VRU)/(URA):
- Ativar a regra 144 | NAO_PERMITE_VOICE_RESPONSE_UNIT_CARTAO_FISICO' | 'Regra que nega transações por modo de entrada Voice Response Unit (VRU)/(URA)');

## Sistema negando por 57:
"motivoResposta" : "MODO_ENTRADA_NAO_PROCESSADO"
- Desativar a regra 115 | MODOS_ENTRADA_NAO_PROCESSADOS | Regra que valida os modos de entrada que não são processados pela processadora. E ativar a regra específica do modo de entrada, para que seja negado conforme requisito.
