## **- OpenVPN Conect**
Necessário realizar download.
Utilizado para acesso a VPN da conductor;
Necessita criação de um usuário e importação de um arquivo;


## **- MobaXTerm**
Necessário realizar download.
Aplicação utilizada para realização de Sign On, acesso aos logs e configurações de atf e gateways
- Configuração:

![image.png](/.attachments/image-ca7fd295-26d7-4022-880e-d64505d74df9.png)

Incluir nova Sessão - SSH para ip: 10.19.21.167
Usuário: root
Senha: cdt@123

## **- DataGrip**
Necessário realizar download.
Ferramenta para acesso ao Banco de Dados, necessita de uma licença adquirida pela Labsit (solicitar ao Rodrigo Silveira)
- Configuração Banco Odin:
![image.png](/.attachments/image-c806401b-f587-4e6b-b21e-d1ebbd3b6c64.png)

  ![image.png](/.attachments/image-f8406a8c-2742-4525-9f90-c4283cec76ed.png)

IP: 10.75.30.84
Usuário: odin_teste
Senha: odin_teste
DataBase: ODIN_CERT



## **- Novo Performance**
Não é necessário realizar download, trata-se de um executável desenvolvido pela Conductor para simular o envio de uma transação por parte da Bandeira/Emissor

Download abaixo:
[NovoPerformance.zip](/.attachments/NovoPerformance-ad935684-d5d8-4ca2-ade9-03d040b4c107.zip)

## **- Postman**
Necessário realizar download.
Utilizado para realizar alguns procedimentos com a VPN ou com criação de cartões.

Abaixo donwload de collections utilizadas:
[Pier.postman_collection.json](/.attachments/Pier.postman_collection-bfafea14-535e-496d-95a6-f34139611dc7.json)
[VPN.postman_collection.json](/.attachments/VPN.postman_collection-ab58c6eb-5593-4ad9-b2d0-b3ba43ecddf2.json)

## **- Rancher - Odin**
Aplicação utilizada para ver logs do Odin e reinicar Odin quando necessário.
Acesso: https://rancher-gcp-hml.devcdt.com.br/login
Necessita de liberação por parte da conductor para acesso, depois de liberado é acessado com mesmos dados do e-mail e teams.

![image.png](/.attachments/image-07f9d574-1d8c-41c9-ab97-f59595f06d62.png)

Após acessar o Odin, serão listados diversos ambientes, nós da Certificação utilizados o ambiente "odin-cert"
![image.png](/.attachments/image-371236e8-51f3-4f1d-b080-38ece27dab17.png)

## Reiniciar o Odin
![image.png](/.attachments/image-0afe0e17-3b00-4115-ac43-3b3249550670.png)