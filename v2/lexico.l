%{
#include <stdio.h> 
#include <string.h>
#include "sintatico.tab.h"

%}

%%
"&&"							{return AND;}
main 							{return CLASS;}
(INTEIRO|boolean)				{yylval.cadeia= (char *) strdup(yytext); return TIPO;}
if 								{return IF;}
else							{return ELSE;}
while 							{return WHILE;}
("+"|"-")?[0-9]+(".")?[0-9]*	{return NUM;}
_?[a-zA-Z][a-zA-Z]*				{yylval.cadeia= (char *) strdup(yytext); return ID;}
"="								{return ATRIBUICAO;}
("<"|">")						{return RELACIONAL;}
("+"|"/"|"-"|"*")				{return ARITMETICO;}
"["								{return ABRE_COLCHETE;}
"]"								{return FECHA_COLCHETE;}
"!"								{return NOT;}
[ \n\t]+						{;}
.								{return yytext[0];}
%%

int yywrap() {
	return 1;
}