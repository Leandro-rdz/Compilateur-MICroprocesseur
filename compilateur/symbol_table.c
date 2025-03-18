#include "symbol_table.h"

static Symbol * st;    // table des symbole
static int tableIndex = 0; // index dans la table des symboles
static int scope = 0;

void initSymbolTable() {
	st = malloc(sizeof(Symbol) * TABLE_SIZE);
}

Symbol newSymbol(char * name) {
    Symbol sym;
    strncpy(sym.name, name, SYMBOL_NAME_SIZE - 1); // on est passé à 2 doigts(1 char) du buffer overflow ici ;)
    sym.name[SYMBOL_NAME_SIZE - 1] = '\0';
    sym.scope = scope;
    return sym;
}

void addToSymbolTable(char * name) {
	if(tableIndex <= TABLE_SIZE) {
		Symbol newsymbol = newSymbol(name);
		st[tableIndex] = newsymbol;
		tableIndex++;
	} else {
		printf("Table des symboles full");
	}
}

void enterScope() {scope++;}
void exitScope() {scope--;}

void printSymbolTable() {
	//première ligne
	printf("┏");
	for (int i = 0; i <= SYMBOL_NAME_SIZE; i++) printf("━");
    printf("┳━━━━━━━━━━━━┓\n");
	//deuxième ligne
	printf("┃ Symbol name                   ┃ @          ┃\n");
	//troisième ligne
	printf("┣");
	for (int i = 0; i <= SYMBOL_NAME_SIZE; i++) printf("━");
    printf("╋━━━━━━━━━━━━┫\n");

    for (size_t i = 0; i < tableIndex; i++) {
    	printf("┃ ");
        printf("%s", st[i].name);
        for(int r = 30 - strlen(st[i].name); r > 0; r--) printf(" ");
	    printf("┃ 0x");
	    printf("87654357");
	    printf(" ┃\n");
    }

	//dernière ligne
	printf("┗");
	for (int i = 0; i <= SYMBOL_NAME_SIZE; i++) printf("━");
    printf("┻━━━━━━━━━━━━┛\n");
}