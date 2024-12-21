Projet : C-Wire
Description :
C-Wire est un programme combinant Shell et C, analysant et traitant des données de stations électriques (HVB, HVA, LV). Elle associe un filtrage en Shell à un traitement rapide en C grâce à un AVL.
Fonctionnalités principales

Filtrage Shell :
Extraction par type de station (HVB, HVA, LV) ou identifiant spécifique.
Classement des 10 stations LV les plus et les moins consommatrices.

Analyse C :
Tri des données par identifiant.
Calcul des consommations totales et des différences capacité/consommation.

Rapports :
Génération de fichiers de sortie triés et formatés
Format des données
Entrée --> Chaque ligne suit le format <ID> <Capacité> <Consommation>.
Sortie --> Chaque ligne suit le format <ID>:<Capacité>:<Consommation>:<Différence>.

Utilisation :
Le script principal gère le filtrage et appelle automatiquement le programme C pour l’analyse.
Utilisez simplement la commande suivante :
bash c-wire.sh <Chemin vers le fichier> <Type de centrale/identifiant>

Prérequis :
* Système d’exploitation : Linux
* Fichier : c-wire_v25.dat le fichier etant trop volumineux pour rentrer sur le répertoire github
* Outils requis : bash
