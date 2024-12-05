#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

typedef struct arbre {
	int valeur;
	struct arbre* fg;
	struct arbre* fd;
	int equilibre;
} arbre;

arbre* Creer_arbre(int donne) {

	arbre* nouveau = malloc(sizeof(arbre));

	if(nouveau == NULL) {
		exit(1);
	}

	nouveau->fd = NULL;
	nouveau->fg = NULL;
	nouveau->equilibre = 0;
	nouveau->valeur = donne;

	return nouveau;
}

void affichage_prefixe(arbre* a) {

	if(a!=NULL) {

		printf("%d, %d| ", a->valeur, a->equilibre);

		affichage_prefixe(a->fg);
		affichage_prefixe(a->fd);

	}
}

int max(int a, int b) {
	if(a>b) {
		return a;
	}
	return b;
}


int hauteur(arbre* a) {
	if(a==NULL) {
		return -1;
	}
	return 1+max(hauteur(a->fg),hauteur(a->fd));
}

void equilibrage(arbre* a) {
	if(a!=NULL) {
		a->equilibre = hauteur(a->fd) - hauteur(a->fg);
		equilibrage(a->fd);
		equilibrage(a->fg);
	}
}

arbre* rotGauche(arbre* a) {
	arbre* pivot = malloc(sizeof(arbre));

	pivot = a->fd;
	a->fd = pivot->fg;
	pivot->fg = a;
	equilibrage(pivot);

	return pivot;
}

arbre* rotDroite(arbre* a) {
	arbre* pivot = malloc(sizeof(arbre));

	pivot = a->fg;
	a->fg = pivot->fd;
	pivot->fd = a;
	equilibrage(pivot);

	return pivot;
}

arbre* doubleRotGauche(arbre* a) {
	a->fd = rotDroite(a->fd);
	return rotGauche(a);
}

arbre* doubleRotDroite(arbre* a) {
	a->fg = rotGauche(a->fg);
	return rotDroite(a);
}

arbre* eqAVL(arbre* a) {
	if(a->equilibre>=2) {
		if(a->fd->equilibre>=0) {
			return rotGauche(a);
		}
		else {
			return doubleRotGauche(a);
		}
	}
	else if(a->equilibre<=-2) {
		if(a->fg->equilibre<=0) {
			return rotDroite(a);
		}
		else {
			return doubleRotDroite(a);
		}
	}
	return a;
}


arbre* insert(arbre* a, int donne) {

	if(a==NULL){
	    return Creer_arbre(donne);
	}
	if(donne<a->valeur){
	    a->fg = insert(a->fg, donne);
	}
	else if(donne>a->valeur){
	    a->fd = insert(a->fd,donne);
	}
	equilibrage(a);
	a = eqAVL(a);
	return a;
}

arbre* suppMIN(arbre* a, int* elmt) {

	arbre* tmp = malloc(sizeof(arbre));

	if(a->fg == NULL) {
		tmp = a;
		a = a->fd;
		free(tmp);
		return a;
	}
	else {
		a->fg = suppMIN(a->fg, elmt);
	}
}

arbre* suppression(arbre* a, int donne) {

	arbre* tmp = malloc(sizeof(arbre));

	if(a==NULL) {
		return a;
	}

	else if(donne>a->valeur) {
		a->fd = suppression(a->fd,donne);
	}
	else if(donne<a->valeur) {
		a->fg = suppression(a->fg,donne);
	}
	else if(a->fd != NULL) {
		a->fd = suppMIN(a->fd, &(a->valeur));
	}
	else {
		tmp = a;
		a = a->fg;
		free(tmp);
	}
	equilibrage(a);
}



int main() {
