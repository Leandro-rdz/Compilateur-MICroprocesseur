#ifndef WRITEASM__H
#define WRITEASM__H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int instruction_counter;
enum OpCode { ADD, MUL, SOU, DIV, COP, AFC, LOAD, STORE, EQU, INF, INFE, SUP, SUPE, JMP, JMPF};
void pushJumpf(int condition) ;
int popJumpf();
void pushJump();
int popJump();
void ASM(enum OpCode op, int a, int b, int c);

void writeOutputASM(char * filename);

#endif