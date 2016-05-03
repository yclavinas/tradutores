/* Nosso projeto coletivo */
%{
#include <stdio.h> 
%}
%token NUM
%token ID
%token OP_ADD
%token OP_MULT
%token WHILE
%%
programa:	'{' lista_cmds '}'	{printf ("Programa sintaticamente correto!\n");}
;
lista_cmds:	cmd				{;}
		| cmd ';' lista_cmds	{;}
;
cmd:		cmd_atribuicao			{;}
		| WHILE '(' exp ')' '{' lista_cmds '}'      {;}
;
cmd_atribuicao: ID '=' exp {;}
;

exp: exp OP_ADD termo {;}
| termo {;};

termo: termo OP_MULT fator {;}
| fator {;};

fator: '(' exp ')' {;}
| ID {;}
| NUM {;};
%%
main () 
{
	yyparse ();
}
yyerror (s) /* Called by yyparse on error */
	char *s;
{
	printf ("Problema com a analise sintatica!\n", s);
}