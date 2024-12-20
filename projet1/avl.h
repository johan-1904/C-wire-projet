#ifndef AVL_H
#define AVL_H
#include "station.h"

typedef struct avl_struct { // structure de l'AVL
    Station station;
    int eq;  
    struct avl_struct *fg;
    struct avl_struct *fd;
} AVL;

AVL* creerAVL(Station station);
int hauteur(AVL* a);
AVL* rotationDroite(AVL* a);
AVL* rotationGauche(AVL* a);
AVL* doubleRotationGauche(AVL* a);
AVL* doubleRotationDroite(AVL* a);
AVL* equilibrerAVL(AVL* a);
AVL* insert(AVL* a, Station new_station);
void ecrire_infixe(AVL* a, FILE* fichier);
void liberer(AVL* a);
int min3(int a, int b, int c);
int max3(int a, int b, int c);
int min(int a, int b);
int max(int a, int b);

#endif
