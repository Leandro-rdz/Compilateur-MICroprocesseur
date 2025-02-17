%{
#include <stdlib.h>
#include <stdio.h>
%}

%option noyywrap

%%

[ \t]+	{};
[0-9]+	{	  printf ("%d",yytext); }
"="	{ printf ("="); }
"-"	{ printf ("-"); }
"+"	{ printf ("+"); }
"*"	{ printf ("*"); }
"/"	{ printf ("/"); }
"("	{ printf ("("); }
")"	{ printf (")"); }
[a-z]	{
	
	  printf ("%s", yytext);
	}
\n	{ printf("\n"); }

%%
int main(void){
	yylex();
}