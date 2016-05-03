/* Analisador Lexico */
%{
    # include "sintatico_tab.h"
%}
%%
while {return WHILE;}
("+"|"-")               {return OP_ADD;}
("*"|"/")               {return OP_MULT;}
("+"|"-")?[0-9]+(".")?[0-9]*	{return NUM;}
[a-zA-Z][a-zA-Z0-9]*	{return ID;}
[ \t\n]+		{;}
.			{return yytext[0];}
%%
int yywrap() {
  return 1;
}