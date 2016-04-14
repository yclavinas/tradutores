%{
#include <stdio.h> 
#include "sintatico.tab.h"
%}

%%
while {return WHILE;}
abrebloco	{return ABREBLOCO;}
fechabloco		{return FECHABLOCO;}
"("		{return ABREPAR;}
")"		{return FECHAPAR;}
("+"|"-")?[0-9]+(".")?[0-9]*	{return NUM;}
_[a-zA-Z][a-zA-Z]*		{return ID;}
"="				{return ATRIBUICAO;}
("<"|">")			{return RELACIONAL;}
("+"|"/")			{return ARITMETICO;}
[ \t]+				{;}
.|\n				{return yytext[0];}
%%

int yywrap() {
	return 1;
}