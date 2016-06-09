%{
#include <stdio.h> 
#include <string.h>
#include "sintatico.tab.h"

/*"int"							{yylval.cadeia= (char *) strdup(yytext); return INT;}*/
/*"boolean"						{yylval.cadeia= (char *) strdup(yytext); return BOOLEAN;} */
%}

%%
escreva							{return ESCREVA;}//code from wiki
leia							{return LEIA;}//code from wiki
"&&"							{return AND;}
main 							{return CLASS;}
int								{return INT;}
boolean							{return BOOLEAN;}
if 								{return IF;}
else							{return ELSE;}
while 							{return WHILE;}
("+"|"-")?[0-9]+(".")?[0-9]*	{yylval.inteiro=  atoi(yytext); return NUM;}
_?[a-zA-Z][a-zA-Z]*				{yylval.cadeia= (char *) strdup(yytext); return ID;}
"="								{return ATRIBUICAO;}
("<"|">")						{return RELACIONAL;}
("+"|"/"|"-"|"*")				{yylval.cadeia= (char *) strdup(yytext); return ARITMETICO;}
"["								{return ABRE_COLCHETE;}
"]"								{return FECHA_COLCHETE;}
"!"								{return NOT;}
[ \n\t]+						{;}
.								{return yytext[0];}
%%

int yywrap() {
	return 1;
}