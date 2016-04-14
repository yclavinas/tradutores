/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h> 
%}
%token NUM
%token ID
%token BLOCO
%token RELACIONAL
%left RELACIONAL /*shift/reduce solver*/
%token ATRIBUICAO
%token PRE_
%token ARITMETICO
%left ARITMETICO /*shift/reduce solver*/
%token WHILE
%token FECHABLOCO
%token ABREBLOCO
%token FECHAPAR
%token ABREPAR
%%
/* Regras definindo a GLC e acoes correspondentes */
/* neste nosso exemplo quase todas as acoes estao vazias */
/*input:    /* empty */
/*        | input line
;
line:     '\n'
        | programa '\n'  
;*/
programa:	ABREBLOCO lista_cmds FECHABLOCO		{ printf ("Programa sintaticamente correto!\n"); }
;
lista_cmds:	cmd				{;}
			| cmd ';' lista_cmds 		{;}
;
cmd:		ID ATRIBUICAO exp					{;}
			| WHILE ABREPAR exp FECHAPAR ABREBLOCO lista_cmds FECHABLOCO      {;}
;
exp:		NUM				{;}
		| ID				{;}
		| exp ARITMETICO exp 		{;}
		| exp RELACIONAL exp 		{;}
;
%%
main (int argc, char *argv[]) 
{
	extern FILE *yyin;
	extern FILE *yyout;

	++argv; --argc; 	    /* abre arquivo de entrada se houver */
	if(argc > 0)
		yyin = fopen(argv[0],"rt");
	else
		yyin = stdin;    /* cria arquivo de saida se especificado */
	if(argc > 1)
		yyout = fopen(argv[1],"wt");
	else
		yyout = stdout;

	yyparse ();

	fclose(yyin);
	fclose(yyout);
}
yyerror (s) /* Called by yyparse on error */
	char *s;
{
	printf ("Problema com a analise sintatica!\n", s);
}
