--------------------------------------------
Geração do CVV via HSM Thales Commander
--------------------------------------------


Tipos de CVV: 
ICVV (CHIP) 
CVV1 (TARJA)
CVV2 (MANUAL)

Commando no HSM commander: CW

CVK A/B (vai depender do cvv desejado):
ICVV/CVV1 - CVKA/B
CVV2 - C2KA/B

Primary account number: (Cartão real)

Expiration date: (formato depende do cvv)

ICVV e CVV1 , formato = AAMM

CVV2 , formato = MMAA

Service code: (depende do cvv)

ICVV = 999
CVV1 = 206
CVV2 = 000


--------------------------------------------
Formato da Trilha
--------------------------------------------

TRILHA 1:
B(NUMERO_DO_CARTAO)^(ULTIMO_NOME)/(PRIMEIRO_NOME) ^(VALIDADE)(SERVICE_CODE)000000000000(CVV)000000

exemplo:
B9999999999999999^ROSANGELA/CLARA^2508206000000000000999000000

TRILHA 2 (CVV1):
(NUMERO_DO_CARTAO)=(VALIDADE)(SERVICE_CODE)00000(CVV)00000

exemplo:
9999999999999999=26012060000009990000

TRILHA 2 equivalent data (ICVV):
(NUMERO_DO_CARTAO)=(VALIDADE)(SERVICE_CODE)00000(CVV)00000

exemplo:
9999999999999999=26012060000009990000


