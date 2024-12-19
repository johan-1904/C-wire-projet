
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "avl.h"
#include "station.h"


int max(int a, int b){
    
    if (a > b){
        return a;
    }
    return b;
}


int min(int a, int b){
    
    if (a < b){
        return a;
    }
    return b;
}


int min3(int a, int b, int c) {
    
    int temp = a ;
    if (b < temp){
        temp = b;
    }
    if (c < temp){
        temp = c;
    }
    return temp;
}

int max3(int a, int b, int c) {
    
    int temp = a;
    if (b > temp){
        temp = b;    
    } 
    if (c > temp){
        temp = c;
    }
    return temp;
}


AVL* creerAVL(Station station){

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

    
int hauteur(AVL* a) {
    if (a == NULL){
        return -1;
    }
    return 1 + max(hauteur(a->fd), hauteur(a->fg));
}

void liberer(AVL* a){
    if (a != NULL){
       liberer(a->fg);
       liberer(a->fd);
       free(a);
    }
}


AVL* rotationDroite(AVL* a){
    AVL* pivot = a->fg; 
    int eq_a = a->eq, eq_p = pivot->eq;

    a->fg = pivot->fd; 
    pivot->fd = a;     

    a->eq = eq_a - min(eq_p, 0) + 1;
    pivot->eq = max3(eq_a + 2, eq_a + eq_p + 2, eq_p + 1);

    return pivot; 
}


AVL* rotationGauche(AVL* a){
    AVL* pivot = a->fd; 
    int eq_a = a->eq, eq_p = pivot->eq;

    a->fd = pivot->fg; 
    pivot->fg = a;    
 
    a->eq = eq_a - max(eq_p, 0) - 1;
    pivot->eq = min3(eq_a - 2, eq_a + eq_p - 2, eq_p - 1);

    return pivot;
    
}


AVL* doubleRotationGauche(AVL* a){
    
    a->fd = rotationDroite(a->fd);
    return rotationGauche(a);
}


AVL* doubleRotationDroite(AVL* a){
    
    a->fg = rotationGauche(a->fg);
    return rotationDroite(a);
}


AVL* equilibrerAVL(AVL* a){
    
    if (a->eq >= 2){ 
        if (a->fd->eq >= 0)
        {
            return rotationGauche(a); 
        }
        else
        {
            return doubleRotationGauche(a); 
        }
    }
    else if (a->eq <= -2){ 
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


AVL* insert(AVL* a, Station new_station){
    
    if (a == NULL){       
        return creerAVL(new_station);
    }
    
    
    else if( new_station.id < a->station.id){ 
        a->fg = insert(a->fg, new_station);
        a->eq -= 1;
    }
    
     else if( new_station.id > a->station.id){ 
        a->fd = insert(a->fd, new_station);
        a->eq += 1;
    }
    
    else{
        a->station.consommation += new_station.consommation;
    }
    
    return equilibrerAVL(a);
}
void ecrire_infixe(AVL* a, FILE* fichier) {
    if (a != NULL) {
        ecrire_infixe(a->fg, fichier);
        fprintf(fichier, "%ld:%ld:%ld:%ld\n", a->station.id, a->station.capacite, a->station.consommation, a->station.capacite - a->station.consommation);
        ecrire_infixe(a->fd, fichier);
    }
}

