#include "write_asm.h"

static FILE *file = NULL;

#define debug 0

int Jumpf_Table[4096];
char Instructions[4096][40];
int instruction_counter =0 ;
int jumpf_counter = 0;

int Jump_Table[4096];
int jump_counter = 0;

void pushJumpf(int condition) {
    int index = instruction_counter; // Sauvegarde l'adresse actuelle
    if (jumpf_counter >= 4096) {
        fprintf(stderr, "Erreur : dépassement de la table des sauts\n");
        exit(EXIT_FAILURE);
    }
    Jumpf_Table[jumpf_counter++] = index;  // Empile l'index actuel
    sprintf(Instructions[instruction_counter++], "JMPF TMP 0x%x\n", condition);
}

int popJumpf() {
    if (jumpf_counter <= 0) {
        fprintf(stderr, "Erreur : tentative de dépiler une table des sauts vide\n");
        exit(EXIT_FAILURE);
    }
	int jumpf_index = Jumpf_Table[jumpf_counter - 1]; // Récupère l'index du dernier saut
    char *line = Instructions[jumpf_index]; // Récupère la ligne à patcher
    int condition;
    sscanf(line, "JMPF TMP 0x%x", &condition);

    sprintf(Instructions[jumpf_index], "JMPF 0x%x 0x%x\n", instruction_counter * 4, condition);    // Écriture dans la bonne ligne
    jumpf_counter--; // Dépile l'index
	return jumpf_index;
}




void pushJump() {
    int index = instruction_counter;
    Jump_Table[jump_counter++] = index;
    sprintf(Instructions[instruction_counter++], "JMP 0x0\n");
}

int popJump() {
    if (jump_counter <= 0) {
        fprintf(stderr, "Erreur : aucune adresse de jump inconditionnel à patcher\n");
        exit(EXIT_FAILURE);
    }
    int jump_index = Jump_Table[--jump_counter];
    sprintf(Instructions[jump_index], "JMP 0x%x\n", instruction_counter * 4);
	return jump_index;
}

void ASM(enum OpCode op, int a, int b, int c) {
    switch (op) {
        case ADD:
            sprintf(Instructions[instruction_counter++], "ADD 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case MUL:
            sprintf(Instructions[instruction_counter++], "MUL 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case SOU:
            sprintf(Instructions[instruction_counter++], "SOU 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case DIV:
            sprintf(Instructions[instruction_counter++], "DIV 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case COP:
            sprintf(Instructions[instruction_counter++], "COP 0x%x 0x%x\n", a, b);
            break;
        case LCOP:
            sprintf(Instructions[instruction_counter++], "LCOP 0x%x 0x%x\n", a, b);
            break;
        case RCOP:
            sprintf(Instructions[instruction_counter++], "RCOP 0x%x 0x%x\n", a, b);
            break;
        case AFC:
            sprintf(Instructions[instruction_counter++], "AFC 0x%x %d\n", a, b);
            break;
        case LOAD:
            sprintf(Instructions[instruction_counter++], "LOAD 0x%x 0x%x\n", a, b);
            break;
        case STORE:
            sprintf(Instructions[instruction_counter++], "STORE 0x%x 0x%x\n", a, b);
            break;
        case EQU:
            sprintf(Instructions[instruction_counter++], "EQU 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case INF:
            sprintf(Instructions[instruction_counter++], "INF 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case INFE:
            sprintf(Instructions[instruction_counter++], "INFE 0x%x 0x%x #0x%x\n", a, b, c);
            break;
        case SUP:
            sprintf(Instructions[instruction_counter++], "SUP 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case SUPE:
            sprintf(Instructions[instruction_counter++], "SUPE 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case JMP:
            sprintf(Instructions[instruction_counter++], "JMP 0x%x\n", a * 4);
            break;
        case JMPF:
            sprintf(Instructions[instruction_counter++], "JMPF 0x%x 0x%x\n", a * 4, b);
            break;
        case AND:
            sprintf(Instructions[instruction_counter++], "AND 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case OR:
            sprintf(Instructions[instruction_counter++], "OR 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case NOT:
            sprintf(Instructions[instruction_counter++], "NOT 0x%x 0x%x\n", a, b);
            break;
        case XOR:
            sprintf(Instructions[instruction_counter++], "XOR 0x%x 0x%x 0x%x\n", a, b, c);
            break;
        case PRI:
            sprintf(Instructions[instruction_counter++], "PRI %x 0x%x\n",a, b);
            break;
        case READ:
            sprintf(Instructions[instruction_counter++], "READ 0x%x %x\n",a, b);
            break;
    }
}

void writeOutputASM(char *filename) {
    if (file != NULL) {
        fclose(file);
    }

    file = fopen(filename, "w");
    if (file == NULL) {
        perror("Erreur lors de l'ouverture du fichier");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < instruction_counter; i++) {
        fprintf(file, "%x %s", i * 4, Instructions[i]);
    }
    fflush(file);

    if (file != NULL) {
        fclose(file);
        file = NULL;
    }
}

void _binaryToString(char out[ADDRESS_SIZE * 8 + 1], int num) {
    for (int i = ADDRESS_SIZE * 8 - 1; i >= 0; i--) {
        out[ADDRESS_SIZE * 8 - 1 - i] = ((num >> i) & 1) ? '1' : '0';
    }
    out[ADDRESS_SIZE * 8] = '\0';
}
