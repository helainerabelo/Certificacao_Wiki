Para sensibilizar o limite, é necessário acessar a tabela **FlagsDispComprasParcs** passando o Id Operação da transação, setando o valor "-1", conforme orientações abaixo:

`select * from FlagsDispComprasParcs where Id_Operacao = 10473 -- trocar o id_operacao`

**Transações nacionais**: devemos alterar a coluna **VcompraDG**

**Transações internacionais:** devemos alterar a coluna **VcontratoDG** 

Para transações **DÉBITO**:
- Devemos inserir o valor "-1" na linha de **Compara** 

`update FlagsDispComprasParcs set VcompraDG = -1 where Id_FlagsDispComprasParcs = 1048 and TipoRegistro = Compara' -- LEMBRAR DE TROCAR O Id_FlagsDispComprasParcs`

Para transações **CRÉDITO**:
- Devemos inserir o valor "-1" na linha de **Altera**
*Obs.: Para compra à vista, parcelada e saque

`update FlagsDispComprasParcs set VcompraDG = -1 where Id_FlagsDispComprasParcs = 1048 and TipoRegistro = Altera' -- LEMBRAR DE TROCAR O Id_FlagsDispComprasParcs`[


Limite Contactless **SEM SENHA**:

Ativar a regra LIMITE_CONTACTLESS_SEM_SENHA e adicionar/alterar o limite na tabela ControleConfiguracoesCartoes na base do EMISSOR

Exemplo:
- Atualizar o id_cartao e valor limite de acordo com a necessidade
insert into ControleConfiguracoesCartoes
(Id_Cartao, PermiteEcommerce, PermiteSaque, PermiteWallet, PermiteControleMCC, PermiteCompraInternacional, PermiteTarjaMagnetica, PermiteContactless, limiteContactlessSemSenha, FuncaoAtiva)
values
(24097263,1,1,1,1,1,1,1,'200.00',0)