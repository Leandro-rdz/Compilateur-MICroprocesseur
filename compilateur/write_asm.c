#include "write_asm.h"

static FILE *file = NULL;

void initOUTPUT(char *filename) {
    if (file != NULL) {
        fclose(file);
    }

    file = fopen(filename, "w");
    if (file == NULL) {
        perror("Erreur lors de l'ouverture du fichier");
        exit(EXIT_FAILURE);
    }
}

void closeFile() {
    if (file != NULL) {
        fclose(file);
        file = NULL;
    }
}


void ASM(enum OpCode op, int a, int b, int c) {
	switch (op) {
		case ADD:
			fprintf(file, "ADD %d %d %d\n", a, b, c);
			break;
		case MUL:
			fprintf(file, "MUL %d %d %d\n", a, b, c);
			break;
		case SOU:
			fprintf(file, "SOU %d %d %d\n", a, b, c);
			break;
		case DIV:
			fprintf(file, "DIV %d %d %d\n", a, b, c);
			break;
		case COP:
			fprintf(file, "COP %d %d\n",a,b );
			break;
		case AFC:
			fprintf(file, "AFC %d %d\n",a,b);
			break;
		case LOAD:
			fprintf(file, "LOAD %d %d\n",a,b);
			break;
		case STORE:
			fprintf(file, "STORE %d %d\n",a,b);
			break;
		case EQU: // a=1 si b=c sinon a=0
			fprintf(file, "EQU %d %d %d\n", a, b, c);
			break;
		case INF: // a=1 si b<c sinon a=0
			fprintf(file, "INF %d %d %d\n", a, b, c);
			break;
		case INFE: // a=1 si b<=c sinon a=0
			fprintf(file, "INFE %d %d %d\n", a, b, c);
			break;
		case SUP: // a=1 si b>c sinon a=0
			fprintf(file, "SUP %d %d %d\n", a, b, c);
			break;
		case SUPE: // a=1 si b>=c sinon a=0
			fprintf(file, "SUPE %d %d %d\n", a, b, c);
			break;
		case JMP: // saut à l'@ de a
			fprintf(file, "JMPPC %d %d\n", a, 1);
			break;
		case JMPC: // saut à l'@ de a si b !=0
			fprintf(file, "JMPC %d %d\n", a, b);
			break;
	}
    fflush(file);
}