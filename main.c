
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "avl.h"
#include "station.h"

int est_nombre_valide(const char* str) { // verifie si la cahine n'est pas nulle
    if (str == NULL || *str == '\0') {
        return 0;
    }
    for (int i = 0; str[i] != '\0'; i++) {
        if (!isdigit(str[i])) { // verifie si le caractere est un chiffre de 0 à 9
            return 0;
        }
    }
    return 1;
}


int traitement_fichier(FILE* fichier, AVL** a) {
    
    char id_str[100], capacite_str[100], consommation_str[100], ligne[100];
    
    while (fgets(ligne, sizeof(ligne), fichier) != NULL) { // boucle qui lit chaque ligne du fichier 
        ligne[strcspn(ligne, "\n")] = '\0'; // supprime les \n en fin de ligne 
        Station station;
        int n = sscanf(ligne, "%s %s %s", id_str, capacite_str, consommation_str); //decoupe chaque ligne en trois parties
        if (n != 3) { // verifie si les trois parties sont la 
            return 1;
        }

        if (!est_nombre_valide(id_str) || !est_nombre_valide(capacite_str) || !est_nombre_valide(consommation_str)) { // verifie si les 3 parties sont des nombres valides
            return 1;
        }
        station.id = strtol(id_str, NULL, 10); // convertit en entier long 
        station.capacite = strtol(capacite_str, NULL, 10);
        station.consommation = strtol(consommation_str, NULL, 10);

        *a = insert(*a, station);
    }
    return 0;
}


int main(int argc, char** argv) {
    
    if (argc < 2) { // verifie les arguments 
        printf( "Erreur d'argument\n");
        return 1;
    }
    
    FILE* fichier = fopen(argv[1], "r+"); // ouvre le fichier
    if (fichier == NULL) { // verifie si le fichier est bien ouvert
        printf("Erreur avec le fichier\n");
        return 1;
    }
    

    AVL* a = NULL;
    if (traitement_fichier(fichier,&a)){//lit le fichier et remplit l'avl
    	return 1;
    }
    freopen(argv[1], "w", fichier); // réouvre le fichier et ecrase son contenu
    ecrire_infixe(a, fichier);
    liberer(a); // libere la memoire prise par l'avl
    fclose(fichier); // ferme le fichier
   

    return 0;
}
