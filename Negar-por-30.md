![image.png](/.attachments/image-8e44c7d0-16a4-42c0-8938-152703be96c0.png)

+ casos:
case CANCELAMENTO_ERRO_FORMATO;
case TRILHA_VAZIA_EM_MODO_OBRIGATORIO_OU_FORMATO_INCORRETO;
case AUTORIZACAO_INTERNA_INCONSISTENTE;
case TAMANHO_CARTAO_INVALIDO;



Para negar em transações [exceto cancelamento] é necessário ativar a regra ENVIO_DADOS_TRANSACAO_ORIGINAL e não enviar o bit 90