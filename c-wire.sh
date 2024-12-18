#!/bin/bash

filtre() {
	
	echo "arg 4 : $4, arg 6 : $6"
	
	case "$4_$6" in
	
	vide_vide)
		echo "TEST" // FONCTIONNE POUR HVB COMP, HVA COMP. 
		station=$5
		awk -v stat="$station" 'BEGIN {FS =";"}  ($(stat) != "-" && $5 != "-" && $8 != "-") || ($(stat) != "-" && $(stat+1) == "-" && $7 != "-") {print $(stat), $7, $8}' $1 >> tmp/$fichier.csv
		sed -i.bak "1d" tmp/$fichier.csv
		sed -i s/-/0/g tmp/$fichier.csv
	;;
	
	$4_vide)
		echo "GROTTE"	// FONCTIONNE POUR HVB COMP + num, HVA COMP + num.
		condition=$4
		station=$5
		awk  -v cond="$condition" -v stat="$station" 'BEGIN {FS =";"} ($(stat) == cond && $5 != "-" && $8 != "-") || ($(stat) == cond && $(stat+1) == "-" && $7 != "-") {print $stat, $7, $8}' $1 >> tmp/$fichier.csv
		sed -i s/-/0/g tmp/$fichier.csv
	;;
	
	vide_$6)
		echo "MARCHE" // FONCTIONNE POUR LV COMP, LV INDIV, LV ALL
		station=$5
		company=$6
		awk -v stat="$station" -v comp="$company" 'BEGIN {FS =";"} ($(stat) != "-" && $(comp) != "-") || ($stat != "-" && $7 != "-") {print $stat, $7, $8}' $1 >> tmp/$fichier.csv
		sed -i.bak "1d" tmp/$fichier.csv
		sed -i s/-/0/g tmp/$fichier.csv
	;;
	*)
		echo "ZUT" // FONCTIONNE POUR LV COMP + num, LV INDIV + num, LV ALL + num
		condition=$4
		station=$5
		company=$6
		awk -v stat="$station" -v cond="$condition" -v comp="$company" 'BEGIN {FS =";"} ($stat == cond && $(comp) != "-")  || ($stat == cond && $7 != "-") {print $stat, $7, $8}' $1 >> tmp/$fichier.csv
		sed -i s/-/0/g tmp/$fichier.csv
	;;
	esac
}

vérifier_arg4(){
	
	condition=$3
	
	if [ $2 = hvb ]
	then
		if ! awk -v cond="$condition" 'BEGIN {FS =";"} {if ($2 == cond) {found=1; exit}} END {if(!found) exit 1}' $1
		then 
			echo "L'identifiant de centrale que vous avez choisi ne correspond à aucune centrale hvb.
Temps d'exécution du programme : 0.0 secondes."
			exit 1
		fi
	fi
	
	if [ $2 = hva ]
	then
		if ! awk -v cond="$condition" 'BEGIN {FS =";"} {if ($3 == cond) {found=1; exit}} END {if(!found) exit 1}' $1
		then 
			echo "L'identifiant de centrale que vous avez choisi ne correspond à aucune centrale hva.
Temps d'exécution du programme : 0.0 secondes."
			exit 1
		fi
	fi
	
	if [ $2 = lv ]
	then
		if ! awk -v cond="$condition" 'BEGIN {FS =";"} {if ($4 == cond) {found=1; exit}} END {if(!found) exit 1}' $1
		then 
			echo "L'identifiant de centrale que vous avez choisi ne correspond à aucune centrale lv.
Temps d'exécution du programme : 0.0 secondes."
			exit 1
		fi
	fi
}

vérifier_cas() {			
		case "$2_$3" in

		hvb_comp)		// FONCTIONNE
			filtre "$1" "$2" "$3" "$4" 2 vide 			
			cat tmp/$fichier.csv
		;;
	
		hva_comp)		//FONCTIONNE
			filtre "$1" "$2" "$3" "$4" 3 vide
			cat tmp/$fichier.csv
		;;
	
		lv_comp)
			filtre "$1" "$2" "$3" "$4" 4 5
			cat tmp/$fichier.csv
	
		;;
	
		lv_all) 
			filtre "$1" "$2" "$3" "$4" 4 all 
			cat tmp/$fichier.csv
			
			touch tmp/lv_all_minmax.csv
			sort -n -r -t " " -k 3 tmp/$fichier.csv > tmp/tmp.csv
			tail -n 1 tmp/tmp.csv > tmp/final.csv
			head -n -1 tmp/tmp.csv > tmp/tri.csv
			head -n 10 tmp/tri.csv >> tmp/lv_all_minmax.csv
			tail -n 10 tmp/tri.csv >> tmp/lv_all_minmax.csv
		;;
	
		lv_indiv)
			filtre "$1" "$2" "$3" "$4" 4 6
			cat tmp/$fichier.csv
		;;
	
		*) 	
			echo "
Il y a une erreur avec les arguments !"
			aide
		;;  
	
		esac

}	

aide() {
	echo "				
Le nombre d'arguments que vous placez en paramètres doit être de 3 ou 4 avec les arguments suivants : 

Premier argument : 
		• Obligatoire 
		-> Il doit être le chemin vers le fichier que vous voulez traiter.

Deuxième argument :
		• Obligatoire 
		-> Il doit correspondre au type de station que vous voulez traiter. Ici 'hvb', 'hva' ou 'lv'.

Troisième argument 
		• Obligatoire  
		-> Il doit correspondre au type de consommateurs que vous voulez traiter. 
			-> Pour sélectionner tous les consommateurs : 'all'. 
			-> Pour sélectionner uniquement les particuliers : 'indiv'.
			-> Pour sélectionner uniquement les entreprises : 'comp'.

Quatrième argument
		• Optionnel
		-> Si vous le souhaitez, vous pouvez entrer l'identifiant d'une centrale pour traiter uniquement celle-ci.

ATTENTION !!! 
Les combinaisons 'hvb_all', 'hvb_indiv', 'hva_all' et 'hva_indiv' ne sont pas autorisées.

Temps d'execution du programme : 0.0 secondes."
		exit 2
}

debut=$(date +%s)

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

if [ -d "tmp" ]

then

	rm -r tmp
	
fi

mkdir tmp

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

if [ ! -e CodeC/exec ]

then
	echo "Erreur, le code en c ne s'est pas compilé correctement !
Temps d'exécution du programme : 0.0 secondes."
	exit 4
	
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
		vérifier_arg4 "$1" "$2" "$4"
		fichier="$2_$3_$4"	
		touch tmp/$fichier.csv
		vérifier_cas "$1" "$2" "$3" "$4"
	else
		fichier="$2_$3"	
		touch tmp/$fichier.csv
		vérifier_cas "$1" "$2" "$3" vide
	fi
else
	fichier="$2_$3"	
	touch tmp/$fichier.csv
	vérifier_cas "$1" "$2" "$3" vide
fi

fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Temps d'exécution du programme : $duree secondes."


