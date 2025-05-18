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
	char type[16];
	int size;
	int scope;
	int address;
	int const_flag;
	int ptr_flag;
} Symbol;

void initSymbolTable();

Symbol newSymbol(char * name, int size, int address, char * type, int const_flag, int ptr_flag); // size en octet

void removeFromSymbolTable(int tempAddr);

char* getTypeFromSymbolTable(char* name); 

int addToSymbolTable(char * name, char * type, int const_flag, int ptr_flag);

void enterScope();
void exitScope();

void clearCurrentScope();

Symbol * searchSymbol(char * name);

void printSymbolTable();

#endif