CC = gcc
CFLAGS = -Wall -g
OBJ = main.o avl.o
EXEC = program

# Compilation de l'exécutable
$(EXEC): $(OBJ)
	$(CC) $(CFLAGS) -o $(EXEC) $(OBJ)

# Compilation des fichiers .o
main.o: main.c avl.h station.h
	$(CC) $(CFLAGS) -c main.c

avl.o: avl.c avl.h station.h
	$(CC) $(CFLAGS) -c avl.c

# Nettoyage des fichiers objets et de l'exécutable
clean:
	rm -f $(OBJ) $(EXEC)

# Exécution du programme avec un fichier d'entrée
run: $(EXEC)
	./$(EXEC) fichier.csv
