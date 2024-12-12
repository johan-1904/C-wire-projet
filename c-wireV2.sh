#!/bin/bash

aide() {
	echo "				
Voici une aide pour vous assister :

Premier argument (obligatoire) = Chemin vers le fichier
Deuxième argument (obligatoire) = 'hvb', 'hva' ou 'lv'
Troisième argument (obligatoire) = 'all', 'indiv' ou 'comp'
Quatrième argument (optionnel) = L'identifiant d'une centrale
"
		exit 2
}

for i in $@
do

	if [ $i = "-h" ]
		
	then 
		aide
		
	fi
done	


if [ $# -lt 3 ] || [ $# -gt 4 ]

then	
	echo "
mauvais nombre d'arguments"
	aide
	
fi

case "$2_$3" in

	hvb_comp)
	
		echo "Identifiant Capacité Consommation" > res.dat
		awk  'BEGIN {FS =";"}  $2 != "-" {print $2, $7, $8}' $1 >> res.dat
		sed -i.bak "2d" res.dat
		cat res.dat
	
	;;
	
	hva_comp)
	
	;;
	
	lv_comp)
	
	;;
	
	lv_all)
	
	;;
	
	lv_indiv)
	
	;;
	
	*) 
		echo "
Il y a une erreur avec les arguments !"
		aide
	;;  
	
esac

if [ ! -f $1 ]
then
	echo "
Le premier argument n'est pas un fichier"
	aide
	
fi

if [ ! -r $1 ]
then
	echo "
Impossible de lire le fichier"
	aide
	
fi

if [ ! -d "tmps" ]

then

	mkdir tmps
	
fi

if [ -d "graphs" ]

then

	rm -r graphs
			
fi

mkdir graphs

if [ ! -e exec ]

then

	gcc codeC/exo.c -o exec
	
fi

if [ $? -ne 0 ]

then 
	
	echo "Erreur, la compilation a échoué"
	exit 3

fi

if [ ! -e res.dat ]

then
	touch res.dat

fi
