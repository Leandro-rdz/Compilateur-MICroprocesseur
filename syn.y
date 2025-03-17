%{
#include <stdlib.h>
#include <stdio.h>

#define YYDEBUG 1
%}

%union {
    int nb;
    char id[16];
    float nbf;
    char string[64];
}

%token tOB tCB tConst tInt tFloat tEq tSub tAdd tMul tDiv tOP tCP tComa tSC tRET tPrint tLT tGT tGE tLE tDif tIf tElse tFor tWhile tVoid tAnd tOr tChar tEqq tTrue tNegate tFalse
%token <nb> tNB
%token <id> tID
%token <nbf> tNBF
%token <string> tSTRING
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
      Type tID tOP Parameters tCP Body { printf("Function %s\n", $2); }
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
      tOB Instructions tCB
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
      ConstType Affectation
    ;

VariableDeclaration:
      Type tID tSC
    | Type Affectation
    | Type tID tComa Affectation { printf("Double Affect and first is %s\n", $2); }
    ;

Type: 
      tInt
    | tFloat 
    | tChar
    | tVoid
    ;

ConstType:
      tConst Type
    ;

Statement:
      Affectation
    | Print
    | Return
    ;

/* Affectation: id = expression ; */
Affectation:
      tID tEq Expression tSC { printf("Affect %s\n", $1); }
    ;

/* Print statement: printf(expression); */
Print:
      tPrint tOP Expression tCP tSC { printf("printf \n"); }
    ;

/* Return statement: return expression; */
Return:
      tRET Expression tSC { printf("Return \n"); }
    ;

Expression:
      tNegate Expression
    | Expression tAdd Expression { printf("Add\n"); }
    | Expression tSub Expression { printf("Sub\n"); }
    | Expression tMul Expression { printf("Mul\n"); }
    | Expression tDiv Expression { printf("Div\n"); }
    | Value
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
      tNB { printf("int : %d\n", $1); }
    | tNBF { printf("float : %f\n", $1); }
    | tSTRING { printf("string : %s\n", $1); }
    | tID { printf("id : %s\n", $1); }
    ; 

%%

/* Main code */
int main(void) {
    yydebug = 0; 
    printf("Compilateur C\n\n");
    yyparse();
    return 0;
}

/* Error handling */
void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}
