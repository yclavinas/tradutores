%{
#include <stdio.h> 
#include "sintatico.tab.h"
%}

%%
main 							{return CLASS;}
int								{return INT;}
boolean							{return BOOLEAN;}
if 								{return IF;}
else							{return ELSE;}
while 							{return WHILE;}
("+"|"-")?[0-9]+(".")?[0-9]*	{return NUM;}
_?[a-zA-Z][a-zA-Z]*				{return ID;}
"="								{return ATRIBUICAO;}
("<"|">")						{return RELACIONAL;}
("+"|"/"|"-"|"*")				{return ARITMETICO;}
[ \n\t]+						{;}
.								{return yytext[0];}
%%

int yywrap() {
	return 1;
}