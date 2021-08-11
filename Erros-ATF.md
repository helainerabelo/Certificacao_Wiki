Erro para restartar ou dar stop e start no xinetd do servidor 10.75.33.100

![image.png](/.attachments/image-17359111-c1bb-4c3a-9217-a84ca8b564c6.png)

Nesse caso é preciso executar o comando utilizando o sudo na frente, para que o usuário se torno root.
No casos os comandos ficaria:

Iniciar ATF: sudo service xinetd start

Parar ATF: sudo service xinetd stop

Reiniciar ATF: sudo service xinetd restart

Status ATF: sudo service xinetd status