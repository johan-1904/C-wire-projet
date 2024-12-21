#!/bin/bash

afficher_centrale() {
	
	echo "						"
	echo "Bienvenue dans notre projet C-Wire !"
	time sleep 0.5 
	echo 
	
   	echo "                       _______________ "
	echo "                      |               |"
    	echo "                      |    CENTRALE   |"
    	echo "                      |   ELECTRIQUE  |"
    	echo "                      |_______________|"
    	echo "                             ||"
    	echo "                            /  \\"
    	echo "                           /    \\"
    	echo "                          /______\\"
    	echo "                         /        \\"
    	echo "       _______           |   ||   |            _______"
    	echo "      /       \\         |   ||   |           /       \\"
    	echo "     |    O    |   __    |   ||   |    __    |    O    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |    |    |  |  |   |   ||   |   |  |   |    |    |"
    	echo "     |____|____|__|__|___|___||___|___|__|___|____|____|"
    	echo "								"
}

filtre() {
	
	case "$4_$6" in
	
	vide_vide)
		echo "Traitement en cours..."
		station=$5
		awk -v stat="$station" 'BEGIN {FS =";"}  ($stat != "-" && $5 != "-" && $8 != "-") || ($stat != "-" && $(stat+1) == "-" && $7 != "-") {print $stat, $7, $8}' $1 |
		tail -n +2 |
		tr '-' '0' >> tmp/$fichier.csv
	;;
	
	$4_vide)
		echo "Traitement en cours..."
		condition=$4
		station=$5
		awk  -v cond="$condition" -v stat="$station" 'BEGIN {FS =";"} ($stat == cond && $5 != "-" && $8 != "-") || ($stat == cond && $(stat+1) == "-" && $7 != "-") {print $stat, $7, $8}' $1 |
		tr '-' '0' >> tmp/$fichier.csv
	;;
	
	vide_$6)
		echo "Traitement en cours..."
		station=$5
		company=$6
		awk -v stat="$station" -v comp="$company" 'BEGIN {FS =";"} $stat != "-" && ($comp != "-" || $7 != "-") {print $stat, $7, $8}' $1 |	
		tail -n +2 |
		tr '-' '0' >> tmp/$fichier.csv
	;;
	*)
		echo "Traitement en cours..."
		condition=$4
		station=$5
		company=$6
		awk -v stat="$station" -v cond="$condition" -v comp="$company" 'BEGIN {FS =";"} $stat == cond && ($(comp) != "-" || $7 != "-") {print $stat, $7, $8}' $1 |
		tr '-' '0'>> tmp/$fichier.csv
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
		case "$2_$3_$4" in

		hvb_comp_$4)		
			filtre "$1" "$2" "$3" "$4" 2 vide 			
			./CodeC/exec tmp/$fichier.csv
			
			if [ $? -eq 1 ]
			then 
				echo "Erreur pendant le fonctionnement du programme C !"
			fi
		;;
	
		hva_comp_$4)		
			filtre "$1" "$2" "$3" "$4" 3 vide
			./CodeC/exec tmp/$fichier.csv
		;;
	
		lv_comp_$4)
			filtre "$1" "$2" "$3" "$4" 4 5
			./CodeC/exec tmp/$fichier.csv
	
		;;
	
		lv_all_vide) 
			filtre "$1" "$2" "$3" "$4" 4 all 
			./CodeC/exec tmp/$fichier.csv
			
			if [ -e tests/lv_all_minmax.csv ] 
			then
				rm tests/lv_all_minmax.csv
			fi
			
			touch tests/lv_all_minmax.csv
			
			sort -n -r -t ":" -k3 tmp/$fichier.csv > tmp/tri.csv
			head -n 10 tmp/tri.csv > tmp/temp.csv
			tail -n 10 tmp/tri.csv >> tmp/temp.csv
			echo "Station LV:Capacité:Consommation:ValeurAbs_Diff_Capacité_Consommation" > tests/lv_all_minmax.csv
			sort -n -t ":" -k4 tmp/temp.csv >> tests/lv_all_minmax.csv
		;;
		lv_all_$4)
			filtre "$1" "$2" "$3" "$4" 4 all 
			./CodeC/exec tmp/$fichier.csv
		;;
		lv_indiv_$4)
			filtre "$1" "$2" "$3" "$4" 4 6
			./CodeC/exec tmp/$fichier.csv
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

for i in $@
do

	if [ $i = "-h" ]
		
	then 
		aide
		
	fi
done

afficher_centrale

debut=$(date +%s)

cd CodeC
make 
cd ..

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

if [  ! -d "tests" ]

then

	mkdir tests
			
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

if [ $# -eq 4 ]
then 
	if [ "$4" -eq "$4" ] 2>/dev/null
	then
		vérifier_arg4 "$1" "$2" "$4"
		fichier="$2_$3_$4"	
		if [ -e tests/$fichier.csv ]
		then
			rm tests/$fichier.csv
		fi		
		touch tests/$fichier.csv
		vérifier_cas "$1" "$2" "$3" "$4"
	else
		fichier="$2_$3"	
		if [ -e tests/$fichier.csv ]
		then
			rm tests/$fichier.csv
		fi
		touch tests/$fichier.csv
		vérifier_cas "$1" "$2" "$3" vide
	fi
else
	fichier="$2_$3"	
	if [ -e tests/$fichier.csv ]
	then
		rm tests/$fichier.csv
	fi
	touch tests/$fichier.csv
	vérifier_cas "$1" "$2" "$3" vide
fi

echo "Station $2:Capacité:Consommation:ValeurAbs_Diff_Capacité_Consommation" > tmp/fichier_final.csv
sort -n -t ":" -k2 tmp/$fichier.csv >> tmp/fichier_final.csv
mv tmp/fichier_final.csv tests/$fichier.csv



echo " "
echo "Le traitement est terminé !"

fin=$(date +%s)
duree=$(( $fin - $debut ))
echo "Temps d'exécution du programme : $duree secondes."		
