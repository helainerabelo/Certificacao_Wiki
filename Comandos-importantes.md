Aqui encontra-se uma lista de comandos mais utilizados dentro da aplicação MobaXTerm


##  Entrar na pasta gateway

cd /usr/bin/gateway


## SIGN ON

**Visa**

./gateway GatewayVisa_Digimais_Certificacao.cfg &


**Master**
./gateway.mastercard Gatewaymaster_Oslo_Stone_1sj.cfg &

**onde** 

**"Gatewaymaster_Oslo_Stone_1sj.cfg"** deve ser substituido pelo nome do arquivo de configuração que se deseja utilizar, vai depender da certificação em questão

**&** deve sempre ser utilizado para não matar a sessão se a VPN cair ou fechar o terminal

## Listar processos de gateway já iniciados
ps aux | grep gateway



## Entrar na pasta Log

cd /var/log/gateway/2021-01-15/ 
(lembrando de alterar a data da pasta para a data que deseja consultar o log)



## Ver Log Gateway

tail -f /var/log/gateway/2021-01-18/gateway.log

ou, se estiver na pasta correta pode-se apenas usar o comando específico

tail -f gateway.log

* Data deve ser ajustada para a data que se deseja ver o log


## Ver Log de erro do Gateway
tail -f /var/log/gateway/2021-06-17/gateway.err

* Data deve ser ajustada para a data que se deseja ver o log


## Parar TODOS os processos de Gateway

killall -HUP gateway




## Parar Gateway específico

kill 14080

* 14080 é o número do processo, precisa ver isso utilizando o comando  ps aux | grep gateway
* Este comando deve ser utilizado para não matar os processos de gateway que outras pessoas estejam utilizando 



## Parar XINETD

service xinetd stop



## Iniciar XINETD

service xinetd start

**** parar e iniciar xinetd é necessário após inserir ou alterar um arquivo de gateway



## Testar conexão através de Telnet

telnet ip porta

* substituir ip e porta pelos dados a serem testados, exemplo: telnet 192.168.0.1 2023



## Ver log no Odin, pelo "Execute Shell", que fica acima do "View Logs"

tail -n 100000 odin.log | grep 142603 -A 120 -B 60

* 142603 = NSU da transação


## Ver Log ATF

tail -f /var/log/atf2/2021-02-22/atf2.msg
* Data deve ser ajustada para a data que se deseja ver o log
