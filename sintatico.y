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
%token INT
%token BOOLEAN
%token ELSE
%token IF
%token CLASS
%%
/* Regras definindo a GLC e acoes correspondentes */
/* neste nosso exemplo quase todas as acoes estao vazias */
/*input:    /* empty */
/*        | input line
;
line:     '\n'
        | programa '\n'  
;*/
programa:	type CLASS '(' var_declaration ')' '{' var_declaration lista_cmds '}' 	{ printf ("Programa sintaticamente correto!\n"); }
;
var_declaration: var 									{;}
				| var ',' var_declaration 				{;}
;
var: type ID 
;
type:	INT '['  ']';
		| BOOLEAN
		| INT
;
lista_cmds:	cmd											{;}
			| cmd ';' lista_cmds 						{;}
;
cmd:		ID ATRIBUICAO exp									{;}
			| ID '[' exp ']'	ATRIBUICAO exp					{;}
			| IF '(' exp ')' '{' lista_cmds '}'  ELSE lista_cmds{;}
			| WHILE '(' exp ')' '{' lista_cmds '}'      		{;}
;
exp:		NUM											{;}
		| ID											{;}
		| exp ARITMETICO exp 							{;}
		| exp RELACIONAL exp 							{;}
		| exp '&&' exp 									{;}
		| exp '[' exp ']' 								{;}
		| '!' exp  										{;}
		| '(' exp ')'									{;}
		| 'true' 										{;}
		| 'false'  										{;}
;

%%
int main (int argc, char *argv[]) 
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
