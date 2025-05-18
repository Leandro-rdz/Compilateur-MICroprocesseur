#ifndef WRITEASM__H
#define WRITEASM__H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "symbol_table.h"

extern int instruction_counter;

enum OpCode { ADD, MUL, SOU, DIV, COP, AFC, AND, OR, NOT, XOR, LOAD, STORE, EQU, INF, INFE, SUP, SUPE, JMP, JMPF, PRI, RCOP, LCOP};

void pushJumpf(int condition) ;

int popJumpf();

void pushJump();

int popJump();

void ASM(enum OpCode op, int a, int b, int c);

void _binaryToString(char out[ADDRESS_SIZE * 8 + 1], int num);

void writeOutputASM(char * filename);

void writeOutputOPCode(char * filename);

#endif