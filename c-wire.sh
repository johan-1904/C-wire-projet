#!/bin/bash

filtre() {
	
	echo "arg 4 : $4, arg 6 : $6"
	
	case "$4_$6" in
	
	vide_vide)
		station=$5
		awk -v stat="$station" 'BEGIN {FS =";"}  $(stat) != "-" {print $(stat), $7, $8}' $1 >> tmps/$fichier.csv
		sed -i.bak "2d" tmps/$fichier.csv
		sed -i s/x/0/g tmps/$fichier.csv
	;;
	
	$4_vide)
		condition=$4
		station=$5
		awk  -v cond="$condition" -v stat="$station" 'BEGIN {FS =";"} $stat == cond {print $stat, $7, $8}' $1 >> tmps/$fichier.csv
		sed -i s/-/0/g tmps/$fichier.csv
	;;
	
	vide_$6)
		station=$5
		company=$6
		awk -v stat="$station" -v comp="$company" 'BEGIN {FS =";"} $(stat) != "-" && $(comp) != "-" {print $stat, $7, $8}' $1 >> tmps/$fichier.csv
		sed -i.bak "2d" tmps/$fichier.csv
		sed -i s/x/0/g tmps/$fichier.csv
	;;
	
	*)
		condition=$4
		station=$5
		company=$6
		awk -v stat="$station" -v cond="$condition" -v comp="$company" 'BEGIN {FS =";"} $stat == cond && ($(comp) != "-" || $7 != "-") {print $stat, $7, $8}' $1 >> tmps/$fichier.csv
		sed -i s/x/0/g tmps/$fichier.csv
	;;
	esac
}

check_case()			
		case "$2_$3" in

		hvb_comp)
			echo "Identifiant Capacité Consommation" > tmps/$fichier.csv
			filtre "$1" "$2" "$3" "$4" 2 vide 
			cat tmps/$fichier.csv
		;;
	
		hva_comp)
			echo "Identifiant Capacité Consommation" > tmps/$fichier.csv
			filtre "$1" "$2" "$3" "$4" 3 vide
			cat tmps/$fichier.csv
		;;
	
		lv_comp)
		
			echo "Identifiant Capacité Consommation" > tmps/$fichier.csv
			filtre "$1" "$2" "$3" "$4" 4 5
			cat tmps/$fichier.csv
	
		;;
	
		lv_all) 
			echo "Identifiant Capacité Consommation" > tmps/$fichier.csv
			filtre "$1" "$2" "$3" "$4" 4 vide
			cat tmps/$fichier.csv
		;;
	
		lv_indiv)
			echo "Identifiant Capacité Consommation" > tmps/$fichier.csv
			filtre "$1" "$2" "$3" "$4" 4 6
			cat tmps/$fichier.csv
		;;
	
		*) 	
			echo "
Il y a une erreur avec les arguments !"
			if [ $4 = vide ]	
			then
				rm tmps/$2_$3.csv
			else
				rm tmps/$2_$3_$4.csv
			fi
			aide
		;;  
	
		esac

	

aide() {
	echo "				
Voici une aide pour vous assister :

Premier argument (obligatoire) = Chemin vers le fichier
Deuxième argument (obligatoire) = 'hvb', 'hva' ou 'lv'
Troisième argument (obligatoire) = 'all', 'indiv' ou 'comp'
Quatrième argument (optionnel) = L'identifiant d'une centrale

De plus, les combinaisons 'hvb_all', 'hvb_indiv', 'hva_all' et 'hva_indiv' ne sont pas autorisées.
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

if [ -d "tmps" ]

then

	rm -r tmps
	
fi

mkdir tmps

if [  ! -d "graphs" ]

then

	mkdir graphs
			
fi

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

if [ ! -e exec ]

then

	gcc codeC/exo.c -o exec
	
fi

if [ $? -ne 0 ]

then 
	
	echo "Erreur, la compilation a échoué"
	exit 3

fi

if [ $# -eq 4 ]
then 
	if [ "$4" -eq "$4" ] 2>/dev/null
	then
		fichier="$2_$3_$4"	
		touch tmps/$fichier.csv
		check_case "$1" "$2" "$3" "$4"
	else
		fichier="$2_$3"	
		touch tmps/$fichier.csv
		check_case "$1" "$2" "$3" vide
	fi
else
	fichier="$2_$3"	
	touch tmps/$fichier.csv
	check_case "$1" "$2" "$3" vide
fi
