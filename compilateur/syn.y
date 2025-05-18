%{
#include <stdlib.h>
#include <stdio.h>
#include "symbol_table.h"
#include "write_asm.h"


#define YYDEBUG 1

%}

%union {
    int nb;
    char id[16];
    float nbf;
    char string[64];
    char type[16];
}
//TODO: Implementer And or negate ect.... Donc faire NOT 
//TODO: Implementer les fonctions(maybe les for / tab)
//TODO: Implementer l'emulateur
//FIXME: Clean code

%token tOB tCB tConst tEq tSub tAdd tMul tDiv tOP tCP tComa tSC tRET tPrint tLT tGT tGE tLE tAddr tDif tXor tIf tElse tFor tWhile tAnd tOr tEqq tNegate 
%token <nb> tNB
%token <id> tID
%token <nbf> tNBF
%token <string> tSTRING
%token <type> tInt
%token <type> tFloat
%token <type> tChar
%token <type> tVoid
%type <type> Type
%type <nb> Expression
%type <nb> Value
%type <nb> Condition
%type <nb> Variables
%right tNegate
%nonassoc LOWER_THAN_ELSE
%nonassoc tElse
%left tAdd tSub
%left tMul tDiv
%left tLT tGT tGE tLE tDif tEqq
%left tAnd tOr tXor
%start Code

%%

Code:
      Declarations { writeOutputASM("out/output.asm"); writeOutputOPCode("out/output.opcode");}
    ;

Declarations:
      Declaration
    | Declarations Declaration
    ;

Declaration: 
      Function  { printf("Declaration de fonction \n"); }
    | VariableDeclaration { printf("Declaration de variable \n"); }
    | ConstantDeclaration { printf("Declaration de constante \n"); }
    ;


Function:
      Type tID { addToSymbolTable($2,$1,0,0);} tOP Parameters tCP Body { printf("Function %s\n", $2); }
    ;

Parameters:
      /* empty */
    | ParamList
    ;

ParamList:
      Parameter 
    | ParamList tComa Parameter
    ;

Body:
      tOB { enterScope(); } Instructions tCB { exitScope(); }
    ;

Instructions:
      Instruction Instructions 
    | /* empty */
    ;

Instruction:
      VariableDeclaration
    | ConstantDeclaration
    | Statement
    | If 
    | While 
    | For
    ;

If:
      tIf tOP Condition {pushJumpf($3); }tCP ControlBody   Else 
    ;

Else : 
      %prec LOWER_THAN_ELSE   { popJumpf(); }
      |  tElse  {pushJump(); popJumpf();}  ControlBody {popJump();} ;

ControlBody:
      Body
    | Instruction
    ;

While:
      tWhile tOP Condition {pushJumpf($3); } tCP ControlBody  {  pushJump(); int addr = popJumpf(); popJump();instruction_counter--; ASM(JMP, addr-1,0,0); }
    ;

For: 
      tFor tOP Expression tSC Condition tSC Expression tCP ControlBody { printf("For\n"); }
    ;

Condition: 
      Condition tLT Condition {int addr = addToSymbolTable("__tmpCond","int",0,0); ASM(INF,addr, $1, $3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ =addr; }
    | Condition tGT Condition {int addr = addToSymbolTable("__tmpCond","int",0,0); ASM(SUP,addr, $1, $3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ =addr;}
    | Condition tGE Condition {int addr = addToSymbolTable("__tmpCond","int",0,0); ASM(SUPE,addr, $1, $3);removeFromSymbolTable($3);removeFromSymbolTable($1);$$ =addr;}
    | Condition tLE Condition {int addr = addToSymbolTable("__tmpCond","int",0,0); ASM(INFE,addr, $1, $3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ =addr;}
    | Condition tEqq Condition{int addr = addToSymbolTable("__tmpCond","int",0,0); ASM(EQU,addr, $1, $3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ =addr;}
    | Value tDif Value {int addr = addToSymbolTable("__tmpArith","int",0,0); ASM(EQU,addr, $1, $3);ASM(NOT,addr,0,0);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ =addr;}
    | Condition tAnd Condition {int addr = addToSymbolTable("__tmpCond","int",0,0); ASM(AND,addr, $1, $3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ =addr; }
    | Condition tOr Condition   {int addr = addToSymbolTable("__tmpCond","int",0,0); ASM(OR,addr, $1, $3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ =addr; }
    | Condition tXor Condition { int addr = addToSymbolTable("__tmpCond","int",0,0);ASM(XOR,addr, $1, $3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ =addr; }
    | Value {$$ =$1;}
    | tNegate Value {int addr = addToSymbolTable("__tmpCond","int",0,0); ASM(AFC,addr,$2,0); ASM(NOT,addr,0,0); $$=addr;}
    ;

/* Declaration of function parameters */
Parameter:
      Type tID
    ;

ConstantDeclaration:
      tConst Type tID tEq Expression tSC { int addr =addToSymbolTable($3, $2,1,0);ASM(COP,addr,$5,0); removeFromSymbolTable($5);}
    ;

VariableDeclaration:
      Variables tSC 
    | Variables tEq Expression tSC { ASM(COP,$1,$3,0);removeFromSymbolTable($3);}
    ;

Variables : 
       Type tID { addToSymbolTable($2,$1,0,0); Symbol * s =searchSymbol($2); $$=s->address;};
      |Type tID { addToSymbolTable($2,$1,0,0);} tComa tID { addToSymbolTable($5,$1,0,0); } ; 
      |Type tMul tID { addToSymbolTable($3,"int",0,1); Symbol * s =searchSymbol($3); $$=s->address;}; // int car une addresse(ici pointeur) a la taille d'un int
      |Type tMul tID { addToSymbolTable($3,"int",0,1);} tComa tID { addToSymbolTable($6,"int",0,1); } ; 


Type: 
      tInt 
    | tFloat 
    | tChar 
    | tVoid 
    ;


Statement:
      Affectation
    | Print
    | Return
    ;

/* Affectation: id = expression ; */
Affectation:
      tID tEq Expression tSC { Symbol * s =searchSymbol($1); 
                              if(s->const_flag){
                                    printf("Erreur , essai de modifier un const\n");
                                    exit(1);}
                              ASM(COP,s->address,$3,0);
                              removeFromSymbolTable($3);}
      |tMul tID tEq Expression tSC { Symbol * s =searchSymbol($2);
                                    if(s->const_flag){
                                          printf("Erreur , essai de modifier un const\n");
                                    exit(1);}
                                    ASM(RCOP,s->address,$4,0);
                                    removeFromSymbolTable($4);} 
    ;

/* Print statement: printf(expression); */
Print:
      tPrint tOP Expression tCP tSC { ASM(PRI,$3,0,0); }
    ;

/* Return statement: return expression; */
Return:
      tRET Value tSC { printf("Return \n"); }
    ;
//$$ = "remonte la valeur"
Expression:
      //tNegate Expression |
      tOP Expression tCP {$$= $2;}
    | Expression tAdd Expression {int addr = addToSymbolTable("__tmpArith","int",0,0); ASM(ADD, addr,$1,$3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ = addr; }
    | Expression tSub Expression {int addr = addToSymbolTable("__tmpArith","int",0,0); ASM(SOU, addr,$1,$3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ = addr; }
    | Expression tMul Expression {int addr = addToSymbolTable("__tmpArith","int",0,0); ASM(MUL, addr,$1,$3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ = addr; }
    | Expression tDiv Expression {int addr = addToSymbolTable("__tmpArith","int",0,0);  ASM(DIV, addr,$1,$3);removeFromSymbolTable($3);removeFromSymbolTable($1); $$ = addr; }
    | Value {$$=$1;}
    | tMul tID {int addr = addToSymbolTable("__tmpArith","int",0,0); Symbol * ptr = searchSymbol($2); ASM(LCOP,addr,ptr->address,0); $$=addr;} // déréferencement avec '£'
    | tAddr tID {int addr = addToSymbolTable("__tmpArith","int",0,0); Symbol * ptr = searchSymbol($2) ; ASM(AFC,addr,ptr->address,0); $$=addr;} // @ de pointeur avec '&'
   // | tID tOP ArgList tCP { printf("Expression\n"); }
    ;

//ArgList:
//      /* empty */
//    | Arguments
//    ;

//Arguments:
//      Expression
//    | Expression tComa Arguments
//    ;

Value: 
      tNB{int addr = addToSymbolTable("__tmpValue","int",0,0); ASM(AFC,addr,$1,0); $$=addr;} 
    | tNBF {int addr = addToSymbolTable("__tmpValue","float",0,0); ASM(AFC,addr,$1,0); $$=addr;}
    | tSTRING {int addr = addToSymbolTable("__tmpValue","char",0,0); ASM(AFC,addr,atoi($1),0); $$=addr;}
    |tID { Symbol * s =searchSymbol($1);$$=s->address; }

    ; 

%%

/* Main code */
int main(void) {
      yydebug = 0;
      initSymbolTable();
      yyparse();
      return 0;
}

/* Error handling */
void yyerror(const char *s) {
      fprintf(stderr, "Erreur: %s\n", s);
}
