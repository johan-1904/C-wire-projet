#ifndef STATION_H
#define STATION_H

typedef struct station // structure de la station avec des long
{
    long id;                
    long consommation; 
    long capacite;
} Station;


int est_nombre_valide(const char* str);
#endif
