Backup Distribuido

O script monitora de tempo em tempo, uma pasta com apenas arquivos, havendo modificação em certo arquivo, ele deve ser transferido para os diretórios das máquinas especificadas no arquivo backup.conf. O script também trata a inclusão e a exclusão de arquivos.

Exemplo backup.conf:
# <IP>          <USER>      	<PASSWORD>	<DIR>
10.0.0.1        alunoufc       	super122	/home/alunoufc/bkp
10.0.14.54    	root            toor		/tmp/backup
10.0.8.8        jjletho         1234		/home/jjletho/backup
