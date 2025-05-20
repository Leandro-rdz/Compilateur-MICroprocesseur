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
        case PRI:
            sprintf(Instructions[instruction_counter++], "PRI 0x%x\n",a);
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


void writeOutputOPCode(char * filename) {
    if (file != NULL) {
        fclose(file);
    }

    file = fopen(filename, "w");
    if (file == NULL) {
        perror("Erreur lors de l'ouverture du fichier");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < instruction_counter; i++) {
        char op[10];
        int a, b, c;
        int opcode = 0;

        int parsed = sscanf(Instructions[i], "%s 0x%x 0x%x 0x%x", op, &a, &b, &c); //parsing

        if (strcmp(op, "ADD") == 0) opcode = 0x01;
        else if (strcmp(op, "MUL") == 0) opcode = 0x02;
        else if (strcmp(op, "SOU") == 0) opcode = 0x03;
        else if (strcmp(op, "DIV") == 0) opcode = 0x04;
        else if (strcmp(op, "COP") == 0) { opcode = 0x05; parsed = 2; }
        else if (strcmp(op, "AFC") == 0) {
            parsed = sscanf(Instructions[i], "%s 0x%x %d", op, &a, &b); // re-parsing car passage de valeur
            opcode = 0x06;
            parsed = 2;
        }
        else if (strcmp(op, "JMP") == 0) { opcode = 0x07; parsed = 1; }
        else if (strcmp(op, "JMPF") == 0) { opcode = 0x08; parsed = 2;}
        else if (strcmp(op, "INF") == 0) opcode = 0x09;
        else if (strcmp(op, "SUP") == 0) opcode = 0x0A;
        else if (strcmp(op, "EQU") == 0) opcode = 0x0B;
        else if (strcmp(op, "PRI") == 0) { opcode = 0x0C; parsed = 1; }

        else if (strcmp(op, "INFE") == 0) opcode = 0x0D;
        else if (strcmp(op, "SUPE") == 0) opcode = 0x0E;
        else if (strcmp(op, "LOAD") == 0) { opcode = 0x0F; parsed = 2; }
        else if (strcmp(op, "STORE") == 0) { opcode = 0x10; parsed = 2; }
        else if (strcmp(op, "LCOP") == 0) { opcode = 0x1A; parsed = 2; }
        else if (strcmp(op, "RCOP") == 0) { opcode = 0x1B; parsed = 2; }

        else if (strcmp(op, "AND") == 0) opcode = 0x14;
        else if (strcmp(op, "OR") == 0) opcode = 0x15;
        else if (strcmp(op, "NOT") == 0) { opcode = 0x17; parsed = 2; }
        else if (strcmp(op, "XOR") == 0) opcode = 0x16;


        char opcode_out[ADDRESS_SIZE * 8 + 1], addr[ADDRESS_SIZE * 8 + 1], a_out[ADDRESS_SIZE * 8 + 1], b_out[ADDRESS_SIZE * 8 + 1], c_out[ADDRESS_SIZE * 8 + 1], zero[ADDRESS_SIZE * 8 + 1];
        _binaryToString(opcode_out, opcode);
        _binaryToString(addr, i*4);
        _binaryToString(a_out, a);
        _binaryToString(b_out, b);
        _binaryToString(c_out, c);
        _binaryToString(zero, 0);

        if (parsed == 2) {
            fprintf(file, "%s %s %s %s %s\n", addr, opcode_out, a_out, b_out, zero);
            if(debug) {
                if(strcmp(op, "AFC") == 0) {
                    fprintf(file, "0x%x 0x%x(%s) 0x%x %x\n", i*4, opcode, op, a, b);
                } else {
                    fprintf(file, "0x%x 0x%x(%s) 0x%x 0x%x\n", i*4, opcode, op, a, b);
                }
            }
        } else if (parsed == 1) {
            fprintf(file, "%s %s %s %s %s\n", addr, opcode_out, a_out, zero, zero);
            if(debug) {
                fprintf(file, "0x%x 0x%x(%s) 0x%x\n", i*4, opcode, op, a);
            }
        } else if (parsed == 0) {
            fprintf(file, "%s %s %s %s %s\n", addr, opcode_out, zero, zero, zero);
            if(debug) {
                fprintf(file, "0x%x 0x%x(%s)\n", i*4, opcode, op);
            }
        } else {
            fprintf(file, "%s %s %s %s %s\n", addr, opcode_out, a_out, b_out, c_out);
            if(debug) {
                fprintf(file, "0x%x 0x%x(%s) 0x%x 0x%x 0x%x\n", i*4, opcode, op, a, b, c);
            }
        }
    }
    fflush(file);

    if (file != NULL) {
        fclose(file);
        file = NULL;
    }
}
