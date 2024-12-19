#ifndef STATION_H
#define STATION_H

typedef struct station
{
    long id;                
    long consommation; 
    long capacite;
} Station;


int est_nombre_valide(const char* str);
#endif
