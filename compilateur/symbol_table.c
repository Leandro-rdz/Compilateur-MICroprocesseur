#include "symbol_table.h"

static Symbol * st;    // table des symbole
static int tableIndex = 0; // index dans la table des symboles
static int scope = 0;

static int stp = 0; // symbol table pointer

void initSymbolTable() {
	st = malloc(sizeof(Symbol) * TABLE_SIZE);
}

Symbol newSymbol(char * name, int size, int address) {
    Symbol sym;
    strncpy(sym.name, name, SYMBOL_NAME_SIZE - 1); // on est passé à 2 doigts(1 char) du buffer overflow ici ;)
    sym.name[SYMBOL_NAME_SIZE - 1] = '\0';
    sym.scope = scope;
    sym.size = size;
    sym.address = address;
    return sym;
}

int addToSymbolTable(char * name, char type[16]) {
	int size;
	if (strcmp(type, "int") == 0) {
		size = ADDRESS_SIZE;
	} else if (strcmp(type, "float") == 0) {
		size = ADDRESS_SIZE;
	} else if (strcmp(type, "void") == 0) {
		size = ADDRESS_SIZE;
	} else if (strcmp(type, "char") == 0) {
		size = 1;
	}
	if(tableIndex <= TABLE_SIZE) {
		Symbol newsymbol = newSymbol(name, size, stp);
		st[tableIndex] = newsymbol;
		int old_stp = stp;
		stp = stp + size;
		tableIndex++;
		return old_stp;
	} else {
		printf("Table des symboles full");
	}
	printSymbolTable();
}

void enterScope() {
	scope++;
}

void exitScope() {
	scope--;
	clearCurrentScope();
}

void clearCurrentScope() { // supprime les éléments du scope qu'on vient de fermer
	for(; st[tableIndex-1].scope > scope; tableIndex--) {
		stp -= st[tableIndex-1].size;
	}
	printSymbolTable();
}

void printSymbolTable() {
	//première ligne
	printf("┏");
	for (int i = 0; i <= SYMBOL_NAME_SIZE; i++) printf("━");
    printf("┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┓\n");
	//deuxième ligne
	printf("┃ Symbol name");
	for(int r = SYMBOL_NAME_SIZE - 12; r >= 0; r--) { printf(" "); }
	printf("┃ scope   ┃ size    ┃ @                  ┃\n");
	//troisième ligne
	printf("┣");
	for (int i = 0; i <= SYMBOL_NAME_SIZE; i++) printf("━");
    printf("╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━┫\n");

    for (size_t i = 0; i < tableIndex; i++) {
    	printf("┃ ");
        printf("%s", st[i].name);
        for(int r = SYMBOL_NAME_SIZE - strlen(st[i].name); r > 0; r--) printf(" ");

        char str[20];
    	printf("┃ ");
	    sprintf(str, "%-8d", st[i].scope);
	    printf("%s", str);
	    printf("┃ ");
	    sprintf(str, "%-8d", st[i].size);
	    printf("%s", str);
	    printf("┃ 0x");
	    sprintf(str, "%-16x", st[i].address);
	    printf("%s", str);
	    printf(" ┃\n");
    }

	//dernière ligne
	printf("┗");
	for (int i = 0; i <= SYMBOL_NAME_SIZE; i++) printf("━");
    printf("┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━┛\n");

    char str[9];  // 8 caractères + '\0'
	printf("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━┓\n");
	sprintf(str, "%-8X", stp);
	printf("┃ STP (Symbol Table Pointer) ┃ 0x%s ┃", str);
	sprintf(str, "%-8d", stp);
	printf(" %s ┃\n", str);
    printf("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━┻━━━━━━━━━━┛\n");
}