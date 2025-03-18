#ifndef SYMBOL__H
#define SYMBOL__H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TABLE_SIZE 256
#define SYMBOL_NAME_SIZE 30
#define ADDRESS_SIZE 4 // taille d'une adressse dans notre architecture en octet

typedef struct {
	char name[SYMBOL_NAME_SIZE];
	int size;
	int scope;
} Symbol;

void initSymbolTable();

Symbol newSymbol(char * name, int size); // size en octet

void addToSymbolTable(char * name, char type[16]);

void enterScope();
void exitScope();

void clearCurrentScope();

void printSymbolTable();

#endif