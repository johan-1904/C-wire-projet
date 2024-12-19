
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>



typedef struct station
{
    long id;                
    long consommation; 
    long capacite;
} Station;

typedef struct avl_struct
{
    Station station;             
    int eq;                
    struct avl_struct *fg; 
    struct avl_struct *fd; 
} AVL;


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


 AVL* classement_station(AVL* a, Station station){
    return insert(a,station);
}        


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

void ecrire_infixe(AVL* a, FILE* fichier) {
    if (a != NULL) {
        ecrire_infixe(a->fg, fichier);
        fprintf(fichier, "%ld:%ld:%ld\n", a->station.id, a->station.capacite, a->station.consommation);
        ecrire_infixe(a->fd, fichier);
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
    char id_str[100], capacite_str[100], consommation_str[100], ligne[100]; 

    while (fgets(ligne, sizeof(ligne), fichier) != NULL) {
        ligne[strcspn(ligne, "\n")] = '\0'; 
        Station station;
        int n = sscanf(ligne, "%s %s %s",id_str, capacite_str, consommation_str);
        if( n != 3){
            return 1;
        }
        
        if (!est_nombre_valide(id_str) || !est_nombre_valide(capacite_str) || !est_nombre_valide(consommation_str)) {
            return 1;  
        }
        station.id = strtol(id_str, NULL, 10);
	station.capacite = strtol(capacite_str, NULL, 10);
	station.consommation = strtol(consommation_str, NULL, 10);
      
        a = classement_station(a, station);
            
    }
    freopen(argv[1], "w", fichier);
    
    ecrire_infixe(a, fichier);
    fclose(fichier);
   

    return 0;
}
