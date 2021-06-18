No log do Odin pode ser verificado os detalhes da autorização externa nas mensagerias:

![image.png](/.attachments/image-e3e37e6f-8114-4d69-a686-02a8118da1c3.png)

Nestes casos o que ocorre é que a conductor recebe da Bandeira a mensagem de entrada e envia uma outra mensagem ao Autorizador Externo, a "msgEnvio"

Ocorre em alguns casos que o Autorizador Externo informa que não está recebendo algum Bit, para verificarmos isso de forma fácil basta copiar a msgEnvio (que é a mensagem enviada para o autorizador) e utilizar um 'parser' para ver os bits que serão enviados, para isso é necessário acessar: **https://licklider.cl/services/financial/iso8583parser/**

![image.png](/.attachments/image-9be53ad9-e5e7-4947-bbb4-82f3dedfd267.png)

Após clicar em "Parse Message" será exibido abaixo os bits e os valores enviados em cada um:

![image.png](/.attachments/image-fca35da0-ab34-45f2-bb24-dd14319db06d.png)


Quando ocorrer de o Autorizador Externo não estar recebendo algum Bit que ele considere necessário poderá ser configurado na base do Odin Bits a serem enviados na Autorização externa, esta configuração pode ser feita e consultada na tabela **"BITS_AUTORIZACAO_EXTERNA"** 

Um exemplo de configuração deste tipo:

select * from BITS_AUTORIZACAO_EXTERNA where ID_EMISSOR in (275);


![image.png](/.attachments/image-7b87fe83-8b10-4dcb-a0c6-7b27dc02ef5c.png)
Emissor exemplo Banestes