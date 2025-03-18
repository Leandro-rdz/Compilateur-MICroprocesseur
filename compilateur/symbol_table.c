#include "symbol_table.h"

static Symbol * st;    // table des symbole
static int tableIndex = 0; // index dans la table des symboles
static int scope = 0;

static int esp = 0; // sommet de la pile
static int ebp = 0; // base de pile

void initSymbolTable() {
	st = malloc(sizeof(Symbol) * TABLE_SIZE);
}

Symbol newSymbol(char * name, int size) {
    Symbol sym;
    strncpy(sym.name, name, SYMBOL_NAME_SIZE - 1); // on est passé à 2 doigts(1 char) du buffer overflow ici ;)
    sym.name[SYMBOL_NAME_SIZE - 1] = '\0';
    sym.scope = scope;
    sym.size = size;
    sym.address = 0x10;
    return sym;
}

void addToSymbolTable(char * name, char type[16]) {
	int size;
	if (strcmp(type, "int") == 0) {
		size = 8;
	} else if (strcmp(type, "float") == 0) {
		size = 8;
	} else if (strcmp(type, "void") == 0) {
		size = ADDRESS_SIZE;
	} else if (strcmp(type, "char") == 0) {
		size = 1;
	}
	if(tableIndex <= TABLE_SIZE) {
		Symbol newsymbol = newSymbol(name, size);
		st[tableIndex] = newsymbol;
		tableIndex++;
		esp = esp + size;
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
		esp = esp - st[tableIndex-2].size;
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

        char str[9];  // 8 caractères + '\0'
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
	printf("┏━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━┓\n");
	sprintf(str, "%-8X", ebp);
	printf("┃ EBP ┃ 0x%s ┃", str);
	sprintf(str, "%-8d", ebp);
	printf(" %s ┃\n", str);

	sprintf(str, "%-8X", esp);
	
	printf("┃ ESP ┃ 0x%s ┃", str);
	sprintf(str, "%-8d", esp);
	printf(" %s ┃\n", str);
    printf("┗━━━━━┻━━━━━━━━━━━━┻━━━━━━━━━━┛\n");
}