#include "write_asm.h"

static FILE *file = NULL;

int Jump_Table[4096];
char Instructions[4096][40];
int instruction_counter = 0;
int jump_counter=0;

void pushJump(int address) {
	if (jump_counter >= 4096) {
		fprintf(stderr, "Erreur : dépassement de la table des sauts\n");
		exit(EXIT_FAILURE);
	}
	Jump_Table[jump_counter++] = address;
}

void popJump() {
	if (jump_counter <= 0) {
		fprintf(stderr, "Erreur : tentative de dépiler une table des sauts vide\n");
		exit(EXIT_FAILURE);
	}
	jump_counter--;
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
			sprintf(Instructions[instruction_counter], "EQU 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case INF: // a=1 si b<c sinon a=0
			sprintf(Instructions[instruction_counter], "INF 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case INFE: // a=1 si b<=c sinon a=0
			sprintf(Instructions[instruction_counter], "INFE 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case SUP: // a=1 si b>c sinon a=0
			sprintf(Instructions[instruction_counter], "SUP 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case SUPE: // a=1 si b>=c sinon a=0
			sprintf(Instructions[instruction_counter], "SUPE 0x%d 0x%d 0x%d\n", a, b, c);
			instruction_counter++;
			break;
		case JMP: // saut à l'@ de a
			sprintf(Instructions[instruction_counter], "JMP %d %d\n", a, 1);
			instruction_counter++;
			break;
		case JMPF: // saut à l'@ de a si b !=0
			sprintf(Instructions[instruction_counter], "JMPF 0x%d 0x%d\n", a, b);
			instruction_counter++;
			break;
	}
}

void writeOutputASM(char * filename){
	if (file != NULL) {
        fclose(file);
    }

    file = fopen(filename, "w");
    if (file == NULL) {
        perror("Erreur lors de l'ouverture du fichier");
        exit(EXIT_FAILURE);
    }
	for (int i = 0; i < instruction_counter; i++) {
		fprintf(file, "%s", Instructions[i]);
	}
	fflush(file);

    if (file != NULL) {
        fclose(file);
        file = NULL;
    }
}