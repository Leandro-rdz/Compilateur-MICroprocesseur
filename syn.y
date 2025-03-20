%{
#include <stdlib.h>
#include <stdio.h>
#include "compilateur/symbol_table.h"
#include "compilateur/write_asm.h"

#define YYDEBUG 1

%}

%union {
    int nb;
    char id[16];
    float nbf;
    char string[64];
    char type[16];
}

%token tOB tCB tConst tEq tSub tAdd tMul tDiv tOP tCP tComa tSC tRET tPrint tLT tGT tGE tLE tDif tIf tElse tFor tWhile tAnd tOr tEqq tTrue tNegate tFalse
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
%type <id> Variables
%right tNegate
%nonassoc LOWER_THAN_ELSE
%left tAdd tSub
%left tMul tDiv
%start Code

%%

Code:
      Declarations { printf("Code\n"); }
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
      Type tID { addToSymbolTable($2,$1);} tOP Parameters tCP Body { printf("Function %s\n", $2); }
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
      tIf tOP Condition tCP ControlBody { printf("IF\n"); }
    | tIf tOP Condition tCP ControlBody tElse ControlBody %prec LOWER_THAN_ELSE  { printf("IF-ELSE\n"); }
    ;

ControlBody:
      Body
    | Instruction
    ;

While:
      tWhile tOP Condition tCP ControlBody { printf("While\n"); }
    ;

For: 
      tFor tOP Expression tSC Condition tSC Expression tCP ControlBody { printf("For\n"); }
    ;

Condition: 
      Value BoolOp Value 
    | tTrue 
    | tFalse
    | Value
    | tNegate Value
    ;

BoolOp:
      tLT
    | tGT
    | tGE
    | tLE
    | tDif
    | tEqq
    | tAnd
    | tOr
    ;

/* Declaration of function parameters */
Parameter:
      Type tID
    ;

ConstantDeclaration:
      tConst Type tID { addToSymbolTable($3, $2);} tEq Expression tSC 
    ;

VariableDeclaration:
      Variables tSC 
    | Variables tEq Expression tSC { Symbol * s =searchSymbol($1); int addr =s->address; ASM(AFC,addr,$3,0);removeFromSymbolTable($3);}
    ;

Variables : 
       Type tID { addToSymbolTable($2,$1); $$=$2}
      |Type tID { addToSymbolTable($2,$1);} tComa tID { addToSymbolTable($5,$1);} ; 


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
      tID tEq Expression tSC { Symbol * s =searchSymbol($1); int addr =s->address; ASM(AFC,addr,$3,0);removeFromSymbolTable($3);}
    ;

/* Print statement: printf(expression); */
Print:
      tPrint tOP Expression tCP tSC { printf("printf \n"); }
    ;

/* Return statement: return expression; */
Return:
      tRET Expression tSC { printf("Return \n"); }
    ;
//$$ = "remonte la valeur"
Expression:
      tNegate Expression
    | Expression tAdd Expression { ASM(ADD, $1,$1,$3);removeFromSymbolTable($3); $$ = $1; }
    | Expression tSub Expression { ASM(SOU, $1,$1,$3);removeFromSymbolTable($3); $$ = $1; }
    | Expression tMul Expression { ASM(MUL, $1,$1,$3);removeFromSymbolTable($3); $$ = $1; }
    | Expression tDiv Expression { ASM(DIV, $1,$1,$3);removeFromSymbolTable($3); $$ = $1; }
    | Value {int addr = addToSymbolTable("__tmp","int"); ASM(AFC,addr,$1,0); $$=addr;}
    | tID tOP ArgList tCP { printf("Expression\n"); }
    ;

ArgList:
      /* empty */
    | Arguments
    ;

Arguments:
      Expression
    | Expression tComa Arguments
    ;

Value: 
      tNB { $$=$1; }
    | tNBF { $$=$1; }
    | tSTRING { $$=atoi($1);}
    | tID { $$=atoi($1);}
    ; 

%%

/* Main code */
int main(void) {
      yydebug = 0; 
      initSymbolTable();
      initOUTPUT("output.asm");
      printf("Compilateur C\n\n");
      yyparse();
      printSymbolTable();
      closeFile();
      return 0;
}

/* Error handling */
void yyerror(const char *s) {
      fprintf(stderr, "Erreur: %s\n", s);
}
