%{
#include <stdlib.h>
#include <stdio.h>
%}

%union {
    int nb;
    char id[16];
    float nbf;
    char string[64];
}

%token tMain tOB tCB tConst tInt tFloat tEq tSub tAdd tMul tDiv tOP tCP tComa tSC tRET tPrint tLT tGT tGE tLE tDif tIf tElse tFor tWhile tVoid tAnd tOr tChar tEqq tTrue tNegate tFalse
%token <nb> tNB
%token <id> tID
%token <nbf> tNBF
%token <string> tSTRING
%right tNegate
%left tAdd tSub
%left tMul tDiv
%start Code

%%

Code:
      Functions { printf("Code\n");};

Functions:
      MainFunction
    | Functions Function
    ;

MainFunction:
      FType tMain tOP Parameters tCP Body { printf("Function\n");} ;

Function: 
      FType tID tOP Parameters tCP Body { printf("Function %s\n", $2);};

FType: 
    tInt
    | tFloat
    | tChar
    | tVoid
  ;

Parameters:
      /* vide */
    | ParamList
    ;

ParamList:
      Parameter
    | ParamList tComa Parameter
    ;

Body:
      tOB Instructions tCB
    ;

Instructions :
    Instruction Instructions 
    | /*vide*/
    ;

Instruction:
   Declaration
  | Statement
  | If 
  | While 
  | For
  ;


If :
  tIf tOP Condition tCP ControlBody
  | tIf tOP Condition tCP ControlBody tElse ControlBody  { printf("IF\n");};

ControlBody :
  Body
  | Instruction
  ;

While :
  tWhile tOP Condition tCP ControlBody { printf("While\n");};

For : 
  tFor tOP Expression tSC Condition tSC Expression tCP ControlBody { printf("For\n");};


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

/* Déclaration des paramètres de fonction */
Parameter:
      tInt tID
    | tFloat tID
    | tConst tInt tID
    | tConst tFloat tID
    ;


Declaration:
    Type tID tSC
  | Type Affectation
  | Type tID tComa Affectation;

Type : 
  tInt
  | tFloat
  | tChar
  | tConst tInt
  | tConst tFloat
  | tConst tChar
  ;

Statement:
      Affectation
    | Print
    | Return
    ;

/* Affectation : id = expression ; */
Affectation:
      tID tEq Expression tSC { printf("Affect %s\n",$1);}
    ;

/* Instruction d'affichage : printf(expression); */
Print:
      tPrint tOP Expression tCP tSC { printf("print ");} ;

/* Instruction de retour : return expression; */
Return:
      tRET Expression tSC { printf("Return ");}  ;

Expression:
tNegate Expression
| Expression Arithmetic Expression
| Value
| tID tOP ArgList tCP { printf("Expression\n");} ;

ArgList:
      /* vide */
    | Arguments
    ;

Arguments:
      Expression
    | Expression tComa Arguments
    ;
Value: tNB {printf("int %d\n", $1);}
| tNBF  {printf("float %f\n", $1);}
| tSTRING  {printf("string %s\n", $1);}
| tID {printf("id %s\n", $1);}
; 

Arithmetic: tAdd 
| tSub 
| tMul
| tDiv
;

%%

/* Code principal */
int main(void) {
    printf("Compilateur C\n");
    yyparse();
    return 0;
}

/* Gestion des erreurs */
void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}
