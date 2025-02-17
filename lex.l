%{
#include <stdlib.h>
#include <stdio.h>
%}

%option noyywrap


nb ^[-+][0-9]+\.[0-9]+[eE][-+]?[0-9]+$
string \"[^"]*\"
%%
{nb} { printf ("tNb = %d\n", atoi(yytext));}
"main" { printf("tMain\n");}
"{" {printf ("tOB\n");}
"}" {printf ("tCB\n");}
[ \t]+	{ printf("tTab\n");}
"const "	{	  printf ("tConst\n"); }
"int "	{	  printf ("tInt\n"); }
"="	{ printf ("tEq\n"); }
"-"	{ printf ("tSub\n"); }
"+"	{ printf ("tAdd\n"); }
"*"	{ printf ("tMul\n"); }
"/"	{ printf ("tDiv\n"); }
"("	{ printf ("tOP\n"); }
")"	{ printf ("tCP\n"); }
"," { printf ("tComa\n");}
\n	{ printf ("tEOL\n"); }
";" { printf ("tSC\n");}
"return" {printf ("tRET");}


{string} {	printf ("tString\n", yytext); }
"printf" {printf ("tPrint\n");}
[a-z]+ {printf ("tID\n");}
%%
int main(void){
	yylex();
}
