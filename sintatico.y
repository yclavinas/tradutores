/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h> 
%}

%union {
	char *cadeia;
}

%token AND
%token ARITMETICO
%left ARITMETICO /*shift_reduce solver*/
%token ATRIBUICAO
%token BOOLEAN
%token CLASS
%token ELSE
%token <cadeia>ID
%token IF
%token INT
%token NUM
%token RELACIONAL
%left RELACIONAL /*shift_reduce solver*/
%token WHILE
%%
/* Regras definindo a GLC e acoes correspondentes */
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
var: type ID 											{printf("%s\n",$2);}
;
type:	INT '['  ']'									{;}
		| BOOLEAN										{;}
		| INT 											{;}
;
lista_cmds:	cmd											{;}
			| cmd ';' lista_cmds 						{;}
;
cmd:		ID ATRIBUICAO exp										{printf("%s\n",$1);}
			| ID '[' exp ']'	ATRIBUICAO exp						{printf("%s\n",$1);}
			| IF '(' exp ')' '{' lista_cmds '}'  ELSE lista_cmds	{;}
			| WHILE '(' exp ')' '{' lista_cmds '}'      			{;}
;
exp:		NUM											{}
		| ID											{printf("%s\n",$1);}
		| exp ARITMETICO exp 							{;}
		| exp RELACIONAL exp 							{;}
		| exp AND exp 									{;}
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
