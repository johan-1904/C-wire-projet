
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "avl.h"
#include "station.h"

int est_nombre_valide(const char* str) {
    if (str == NULL || *str == '\0') {
        return 0;
    }
    for (int i = 0; str[i] != '\0'; i++) {
        if (!isdigit(str[i])) {
            return 0;
        }
    }
    return 1;
}


void traitement_fichier(FILE* fichier, AVL** a) {
    char id_str[100], capacite_str[100], consommation_str[100], ligne[100];
	while (fgets(ligne, sizeof(ligne), fichier) != NULL) {
        ligne[strcspn(ligne, "\n")] = '\0';
        Station station;
        int n = sscanf(ligne, "%s %s %s", id_str, capacite_str, consommation_str);
        if (n != 3) {
            exit(1);
        }

        if (!est_nombre_valide(id_str) || !est_nombre_valide(capacite_str) || !est_nombre_valide(consommation_str)) {
            exit(1);
        }
        station.id = strtol(id_str, NULL, 10);
        station.capacite = strtol(capacite_str, NULL, 10);
        station.consommation = strtol(consommation_str, NULL, 10);

        *a = insert(*a, station);
    }

}


int main(int argc, char** argv) {
    
    if (argc < 2) {
        printf( "Erreur d'argument\n");
        exit(1);
    }
    
    FILE* fichier = fopen(argv[1], "r+");
    if (fichier == NULL) {
        printf("Erreur avec le fichier\n");
        exit(1);
    }
    

    AVL* a = NULL;
    traitement_fichier(fichier,&a);
    freopen(argv[1], "w", fichier);
    ecrire_infixe(a, fichier);
    liberer(a);
    fclose(fichier);
   

    return 0;
}
