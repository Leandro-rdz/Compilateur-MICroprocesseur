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
%type <nb> Condition
%type <nb> Variables
%right tNegate
%nonassoc LOWER_THAN_ELSE
%nonassoc tElse
%left tAdd tSub
%left tMul tDiv
%start Code

%%

Code:
      Declarations {   writeOutputASM("out/output.asm"); }
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
      tWhile tOP Condition tCP ControlBody { printf("While\n"); }
    ;

For: 
      tFor tOP Expression tSC Condition tSC Expression tCP ControlBody { printf("For\n"); }
    ;

Condition: 
      Condition tLT Condition { ASM(INF,$1, $1, $3);removeFromSymbolTable($3); $$ =$1; }
    | Condition tGT Condition { ASM(SUP,$1, $1, $3);removeFromSymbolTable($3); $$ =$1;}
    | Condition tGE Condition { ASM(SUPE,$1, $1, $3);removeFromSymbolTable($3); $$ =$1;}
    | Condition tLE Condition { ASM(INFE,$1, $1, $3);removeFromSymbolTable($3); $$ =$1;}
    | Condition tEqq Condition{ ASM(EQU,$1, $1, $3);removeFromSymbolTable($3); $$ =$1;}
    //| Value BoolOp Value
    //| Value tAnd Value 
    //| Value tOr Value
    //| tTrue 
    //| tFalse
    | Value {int addr = addToSymbolTable("__tmp","int"); ASM(AFC,addr,$1,0); $$=addr;}
    //| tNegate Value
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
    | Variables tEq Expression tSC { ASM(COP,$1,$3,0);removeFromSymbolTable($3);}
    ;

Variables : 
       Type tID { addToSymbolTable($2,$1); Symbol * s =searchSymbol($2); $$=s->address;};
      |Type tID { addToSymbolTable($2,$1);} tComa tID { addToSymbolTable($5,$1); } ; 


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
      //tNegate Expression |
      Expression tAdd Expression { ASM(ADD, $1,$1,$3); removeFromSymbolTable($3); $$ =$1; }
    | Expression tSub Expression { ASM(SOU, $1,$1,$3);removeFromSymbolTable($3); $$ = $1; }
    | Expression tMul Expression { ASM(MUL, $1,$1,$3); removeFromSymbolTable($3);$$ =$1; }
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
      printf("Compilateur C\n\n");
      yyparse();
      return 0;
}

/* Error handling */
void yyerror(const char *s) {
      fprintf(stderr, "Erreur: %s\n", s);
}
