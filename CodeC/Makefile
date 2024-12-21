CC = gcc
CFLAGS = -Wall -g
OBJ = main.o avl.o
EXEC = exec

# Compilation de l'exec
$(EXEC): $(OBJ)
	$(CC) $(CFLAGS) -o $(EXEC) $(OBJ)

# Compilation des  .o
main.o: main.c avl.h station.h
	$(CC) $(CFLAGS) -c main.c

avl.o: avl.c avl.h station.h
	$(CC) $(CFLAGS) -c avl.c

# Nettoyage des fichiers objets et de l'exécutable
clean:
	rm -f $(OBJ) $(EXEC)


