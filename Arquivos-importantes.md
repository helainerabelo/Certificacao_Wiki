**1- Manual Elo sobre as mensagerias das transações de Autorização**
[Elo_2020 Elo - Especificação Técnica - Mensageria de Autorização 20.2.pdf](/.attachments/Elo_2020%20Elo%20-%20Especificação%20Técnica%20-%20Mensageria%20de%20Autorização%2020.2-527739d2-b326-4e47-bbf3-e299a4e51f3c.pdf)

**2- Passo a passo para processar o arquivo de liquidação**
[doc_liquidacao_elo (2).md](/.attachments/doc_liquidacao_elo%20(2)-698ebaa2-4518-4cfa-bfa1-c61fe514850d.md)
e
[liquidacao.sql](/.attachments/liquidacao-4a96f302-9905-4996-aabb-6fe8471a138b.sql)

**3- Link do Odin - Autorizador Conductor**
https://rancher-gcp-hml.devcdt.com.br/login

**4- Link do SGR - Usado pela certificação para o processamento do arquivo de liquidação**
https://10.75.130.18:8080/

**5- Link do storage do SGR, onde importar os arquivos da liquidação para que o SGR execute a rotina**
https://portal.azure.com/#home
-> Caminho: Storage accounts -> sgrgkehmlg -> File shares -> sgrgkehmlg -> sgr-hmlg-primario -> importacao -> conciliaÃ§Ã£o new elo -> builderjobimportararquivoincoming -> "importar o arquivo da liquidação aqui"