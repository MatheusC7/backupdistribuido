#!/bin/bash

while getopts "c:d:t:" OPTVAR
do
	if [ $OPTVAR == "c" ]
     	then
     		conf=$OPTARG
  	fi

  	if [ $OPTVAR == "d" ]
     	then
     		diretorio=$OPTARG
  	fi

  	if [ $OPTVAR == "t" ]
     	then
     		tempo=$OPTARG
  	fi
done


remover(){

exec 3< $conf

for i in `ls $diretorio`
do
  echo "$i:"`date -r loc/$i +%s` >> loc.txt
done

while read arq <&3; do
	ip=`echo "$arq" | cut -d" " -f1`
	user=`echo "$arq" | cut -d" " -f2`
	senha=`echo "$arq" | cut -d" " -f3`
	dir=`echo "$arq" | cut -d" " -f4`

	sshpass -p "$senha" ssh $user@$ip "ls $dir" > remoto.txt

	for i in `cat remoto.txt`
	do

		if [ `cat loc.txt | grep -e "^$i$"` ]
		then
			echo  &>/dev/null
		else
			echo "------DEVE SER REMOVIDO o Arquivo: $i em $user@$ip"
			sshpass -p "$senha" ssh $user@$ip "rm $dir/$i"
		fi
	done
done

}

adicionar(){

exec 3< $conf

ls $diretorio > loc.txt

while read arq <&3; do
        ip=`echo "$arq" | cut -d" " -f1`
        user=`echo "$arq" | cut -d" " -f2`
        senha=`echo "$arq" | cut -d" " -f3`
        dir=`echo "$arq" | cut -d" " -f4`

        sshpass -p "$senha" ssh $user@$ip "ls $dir" > remoto.txt

	for i in `cat loc.txt`
	do
        	if [ `cat remoto.txt | grep -e "^$i$"` ]
        	then
			HLOC=`md5sum $diretorio/$i | cut -d" " -f1`
			HREM=`sshpass -p "$senha" ssh $user@$ip "md5sum $dir/$i | cut -d' ' -f1"`

			if [ $HLOC == $HREM ]
			then
				echo  &>/dev/null

			else
                       		echo "Arquivo alterado: $i---- em $user$ip"
                        	sshpass -p "$senha" ssh $user@$ip "rm $dir/$i"
                        	sshpass -p "$senha" scp $diretorio/$i $user@$ip:$dir
                        	echo "Arquivo atualizado: $i---- em $user@$ip"
        		fi
		else

		echo "------DEVE SER ADICIONADO O Arquivo: $i---- em $user$ip"
		sshpass -p "$senha" scp $diretorio/$i $user@$ip:$dir

		fi
	done

done

}

while true
do
	remover
	adicionar
	sleep $tempo
done

