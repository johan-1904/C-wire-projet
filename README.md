Projet : C-Wire
Description :
C-Wire est un programme combinant Shell et C, analysant et traitant des données de stations électriques (HVB, HVA, LV). Elle associe un filtrage en Shell à un traitement rapide en C grâce à un AVL.
Fonctionnalités principales

Filtrage Shell :
Extraction par :
  -> type de station : "HVB", "HVA", "LV".
  -> type de consommateurs : "COMP" pour les entreprises, "INDIV" pour les particuliers ou "ALL" pour tous. 
  -> identifiant de centrale
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
"bash c-wire.sh <Chemin vers le fichier> <Type de centrale> <Type de consommateur> <Identifiant de centrale>"
Vous pouvez également accéder à une aide concernant les arguments en mettant en paramètre "-h".

Prérequis :
* Avant de lancer le programme, veillez à avoir dans un de vos dossiers:
  -> un dossier "input" dans lequel sera rangé le fichier de départ à analyser.
  -> un dossier "CodeC" dans lequel vous aurez téléchargé les fichiers '.c', '.h' et le fichier 'Makefile'.
  -> le fichier 'c-wire.sh' téléchargé à la racine des deux autres dossiers.   
* Système d’exploitation : Linux
* Fichier : c-wire_v25.dat le fichier etant trop volumineux pour rentrer sur le répertoire github
* Outils requis : bash
* Information supplémentaire : Il faudra vous rendre dans votre dossier à l'aide du terminal. 
