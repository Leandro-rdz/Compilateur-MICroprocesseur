%{
#include <stdlib.h>
#include <stdio.h>
%}

%union {
    int nb;
    char id[16];
}

%token tMain tOB tCB tConst tInt tFloat tEq tSub tAdd tMul tDiv tOP tCP tComa tSC tRET tSTRING tPrint tNBF tLT tGT tGE tLE tDif tIf tElse tFor tWhile tVoid tAnd tOr tChar tEqq tTrue tFalse
%token <nb> tNB
%token <id> tID
%nonassoc tElse

%left tAdd tSub
%left tMul tDiv
%start Code

%%

Code:
      Functions 
    ;  { printf("Code\n");}

Functions:
      Function
    | Functions Function
    ;

Function:
      FType tMain tOP Parameters tCP Body
    ; { printf("Function\n");}

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
  tIf tOP Condition tCP ControlBody %prec tElse
  | tIf tOP Condition tCP ControlBody tElse ControlBody 
  ; { printf("IF\n");}

ControlBody :
  Body
  | Instruction
  ;

While :
  tWhile tOP Condition tCP ControlBody
  ; { printf("While\n");}

For : 
  tFor tOP Expression tSC Condition tSC Expression tCP ControlBody
  ; { printf("For\n");}


Condition: Value BoolOp Value 
| tTrue 
| tFalse
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
  | Type Affectation;

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
      tID tEq Expression tSC
    ; { printf("Affect %s\n",$1);}

/* Instruction d'affichage : printf(expression); */
Print:
      tPrint tOP Expression tCP tSC
    ; { printf("print ");}

/* Instruction de retour : return expression; */
Return:
      tRET Expression tSC
    ; { printf("Return ");}

Expression: Expression Arithmetic Expression
| Value
; { printf("Expression\n");}

Value: tNB
| tNBF
| tSTRING
| tID
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
