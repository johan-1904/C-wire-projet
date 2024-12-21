
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "avl.h"
#include "station.h"


int max(int a, int b){ // fonction pour calculer le maximum entre deux entiers
    
    if (a > b){
        return a;
    }
    return b;
}


int min(int a, int b){ // fonction pour calculer le minimum entre deux entiers
    
    if (a < b){
        return a;
    }
    return b;
}


int min3(int a, int b, int c) { // fonction pour calculer le minimum entre trois entiers
    
    int temp = a ;
    if (b < temp){
        temp = b;
    }
    if (c < temp){
        temp = c;
    }
    return temp;
}

int max3(int a, int b, int c) { // fonction pour calculer le maximum entre trois entiers  
    
    int temp = a;
    if (b > temp){
        temp = b;    
    } 
    if (c > temp){
        temp = c;
    }
    return temp;
}


AVL* creerAVL(Station station){ // fonction pour creer un AVL

    AVL* nouveau = malloc(sizeof(AVL));
    if (nouveau == NULL)
    {
        exit(EXIT_FAILURE); 
    }
    nouveau->station = station;
    nouveau->fg = NULL; 
    nouveau->fd = NULL;
    nouveau->eq = 0;   
    return nouveau;
}

    
int hauteur(AVL* a) { // fonction pour calculer la hauteur d'un avl a
    if (a == NULL){
        return -1;
    }
    return 1 + max(hauteur(a->fd), hauteur(a->fg));
}

void liberer(AVL* a){ // fonction pour free tout un avl
    if (a != NULL){
       liberer(a->fg);
       liberer(a->fd);
       free(a);
    }
}


AVL* rotationDroite(AVL* a){ //fonction pour effectuer une rotation à droite sur un AVL
    AVL* pivot = a->fg; 
    int eq_a = a->eq, eq_p = pivot->eq;

    a->fg = pivot->fd; 
    pivot->fd = a;     

    a->eq = eq_a - min(eq_p, 0) + 1; //met a jour le facteur d'équilibre apres rotation
    pivot->eq = max3(eq_a + 2, eq_a + eq_p + 2, eq_p + 1);

    return pivot; 
}


AVL* rotationGauche(AVL* a){ // fonction pour effectuer une rotation à gauche sur un AVL
    AVL* pivot = a->fd; 
    int eq_a = a->eq, eq_p = pivot->eq;

    a->fd = pivot->fg; 
    pivot->fg = a;    
 
    a->eq = eq_a - max(eq_p, 0) - 1;  //met a jour le facteur d'équilibre apres rotation
    pivot->eq = min3(eq_a - 2, eq_a + eq_p - 2, eq_p - 1);

    return pivot;
    
}


AVL* doubleRotationGauche(AVL* a){ // fonction pour effectuer une double rotation gauche sur un AVL
    
    a->fd = rotationDroite(a->fd);
    return rotationGauche(a);
}


AVL* doubleRotationDroite(AVL* a){ // fonction pour effectuer une double rotation droite sur un AVL
    
    a->fg = rotationGauche(a->fg);
    return rotationDroite(a);
}


AVL* equilibrerAVL(AVL* a){ // fonction pour équilibrer un AVL en effectuant les rotations nécessaires
    
    if (a->eq >= 2){ // cas ou le déséquilibre est à droite
        if (a->fd->eq >= 0) 
        {
            return rotationGauche(a); 
        }
        else
        {
            return doubleRotationGauche(a); 
        }
    }
    else if (a->eq <= -2){  // cas ou le déséquilibre est à gauche
        if (a->fg->eq <= 0)
        {
            return rotationDroite(a); 
        }
        else
        {
            return doubleRotationDroite(a); 
        }
    }
    return a; 
}


AVL* insert(AVL* a, Station new_station){ //insert une nouvelle station dans l'arbre
    
    if (a == NULL){ // cas de bas où l'arbre est vide 
        return creerAVL(new_station);
    }
    
    
    else if( new_station.id < a->station.id){  //cas où l'identifiant est inferieur au noeud actuel 
        a->fg = insert(a->fg, new_station);
        a->eq -= 1;
    }
    
     else if( new_station.id > a->station.id){ //cas où l'identifiant est superieur au noeud actuel 
        a->fd = insert(a->fd, new_station);
        a->eq += 1;
    }
    
    else{ // cas où l'identifiant est le même et ou il faut donc sommer les consos
        a->station.consommation += new_station.consommation;
    }
    
    return equilibrerAVL(a);
}


void ecrire_infixe(AVL* a, FILE* fichier) {

    if (a != NULL) {
        ecrire_infixe(a->fg, fichier);
        if(a->station.capacite - a->station.consommation<0){  // cas pour eviter une difference negative 
        	fprintf(fichier, "%ld:%ld:%ld:%ld\n", a->station.id, a->station.capacite, a->station.consommation, - (a->station.capacite - a->station.consommation));
        }
	else{
        	fprintf(fichier, "%ld:%ld:%ld:%ld\n", a->station.id, a->station.capacite, a->station.consommation, a->station.capacite - a->station.consommation);
       	}
	ecrire_infixe(a->fd, fichier);
    }
}

