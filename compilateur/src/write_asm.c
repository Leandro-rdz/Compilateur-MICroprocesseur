#include "write_asm.h"

static FILE *file = NULL;

char Instructions[4096][40];
int instruction_counter = 0;

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
			sprintf(Instructions[instruction_counter], "ADD 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case MUL:
			sprintf(Instructions[instruction_counter], "MUL 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case SOU:
			sprintf(Instructions[instruction_counter], "SOU 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case DIV:
			sprintf(Instructions[instruction_counter], "DIV 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case COP:
			sprintf(Instructions[instruction_counter], "COP 0x%d 0x%d\n", a, b);
			instruction_counter++;
			break;
		case AFC:
			sprintf(Instructions[instruction_counter], "AFC 0x%d %d\n", a, b);
			instruction_counter++;
			break;
		case LOAD:
			sprintf(Instructions[instruction_counter], "LOAD 0x%d 0x%d\n", a, b);
			instruction_counter++;
			break;
		case STORE:
			sprintf(Instructions[instruction_counter], "STORE 0x%d 0x%d\n", a, b);
			instruction_counter++;
			break;
		case EQU: // a=1 si b=c sinon a=0
			sprintf(Instructions[instruction_counter], "EQU %d %d %d\n", a, b, c);
			instruction_counter++;
			break;
		case INF: // a=1 si b<c sinon a=0
			sprintf(Instructions[instruction_counter], "INF %d %d %d\n", a, b, c);
			instruction_counter++;
			break;
		case INFE: // a=1 si b<=c sinon a=0
			sprintf(Instructions[instruction_counter], "INFE %d %d %d\n", a, b, c);
			instruction_counter++;
			break;
		case SUP: // a=1 si b>c sinon a=0
			sprintf(Instructions[instruction_counter], "SUP %d %d %d\n", a, b, c);
			instruction_counter++;
			break;
		case SUPE: // a=1 si b>=c sinon a=0
			sprintf(Instructions[instruction_counter], "SUPE %d %d %d\n", a, b, c);
			instruction_counter++;
			break;
		case JMP: // saut à l'@ de a
			sprintf(Instructions[instruction_counter], "JMPPC %d %d\n", a, 1);
			instruction_counter++;
			break;
		case JMPF: // saut à l'@ de a si b !=0
			sprintf(Instructions[instruction_counter], "JMPF %d %d\n", a, b);
			instruction_counter++;
			break;
	}   
}

void writeAll (){
	for (int i = 0; i < 256; i++) {
		if (Instructions[i] != NULL) {
			fprintf(file, "%s", Instructions[i]);
		}
	}
	fflush(file);
}