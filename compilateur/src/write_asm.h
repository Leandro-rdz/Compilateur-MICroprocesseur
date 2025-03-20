#ifndef WRITEASM__H
#define WRITEASM__H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

enum OpCode { ADD, MUL, SOU, DIV, COP, AFC, LOAD, STORE, EQU, INF, INFE, SUP, SUPE, JMP, JMPF};

void ASM(enum OpCode op, int a, int b, int c);

void writeOutputASM(char * filename);

#endif