%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%option noyywrap

INTEGER   (0|[1-9][0-9]*)([eE][-+]?[0-9]+)?
FLOATNUM  ([0-9]+\.[0-9]+)([eE][-+]?[0-9]+)?
STRING    \"[^"]*\"

%%

{INTEGER}    { yylval.nb = strtod(yytext,NULL); return tNB; }
{FLOATNUM}   { yylval.nbf = strtod(yytext,NULL);return tNBF; }

{STRING} { 
          strncpy(yylval.string, yytext, 63);
          yylval.string[64] = '\0';
          return tSTRING;
     }



"{"          { return tOB; }
"&"          { return tAddr; }   
"£"          { return tPtr; }           
"}"          { return tCB; }
"const"      { return tConst; }
"int"        { strncpy(yylval.string, "int", 15);
                yylval.string[16] = '\0';
               return tInt;}
"float"      { strncpy(yylval.string, "float", 15);
                yylval.string[16] = '\0';
               return tFloat; }
"void"       { strncpy(yylval.string, "void", 15);
                yylval.string[16] = '\0';
               return tVoid; }
"char"       { strncpy(yylval.string, "char", 15);
                yylval.string[16] = '\0';
               return tChar; }
"=="         { return tEqq; }
"="          { return tEq; }
"-"          { return tSub; }
"+"          { return tAdd; }
"*"          { return tMul; }
"/"          { return tDiv; }
"("          { return tOP; }
")"          { return tCP; }
","          { return tComa; }
";"          { return tSC; }
"return"     { return tRET; }
"printf"     { return tPrint; }
"<"          { return tLT; }
">"          { return tGT; }
">="         { return tGE; } 
"<="         { return tLE; }
"!="         { return tDif; }
"if"         { return tIf; }
"else"       { return tElse; }
"for"        { return tFor; }
"while"      { return tWhile; }
"&"          { return tAnd; }
"|"          { return tOr; }
"true"       { return tTrue; }
"false"      { return tFalse; }
"!"          { return tNegate; }
[a-z_][a-z0-9_]*  { 
                        strncpy(yylval.id, yytext, 15);
                        yylval.id[15] = '\0';
                        return tID;
                   }

[ \t\n]+     { /* rien */ }


%%
