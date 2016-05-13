/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h> 
%}

%union {
	char *cadeia;
}

%token NUM
%token <cadeia>ID
%token RELACIONAL
%left RELACIONAL /*shift_reduce solver*/
%token ATRIBUICAO
%token ARITMETICO
%left ARITMETICO /*shift_reduce solver*/
%token WHILE
%token INT
%token BOOLEAN
%token ELSE
%token IF
%token CLASS
%token AND
%left AND /*shift_reduce solver*/
%token  ABRE_COLCHETE
%left  ABRE_COLCHETE
%token  FECHA_COLCHETE
%left  FECHA_COLCHETE
%token  NOT
%left  NOT
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
var_declaration: var 									{printf("var\n");}
				| var ',' var_declaration 				{printf("var, var_declaration\n");}
				|										{printf("empty rule\n");}
;
var: type ID 											{printf("%s\n",$2);}
;
type:	INT '['  ']'									{printf("int []\n");}
		| BOOLEAN										{printf("bool\n");}
		| INT 											{printf("int\n");}
;
lista_cmds:	cmd											{printf("cmd\n");}
			| cmd lista_cmds 						{printf("cmd ; lista_cmds\n");}
			
; 
cmd:		ID ATRIBUICAO exp														{printf("%s\n",$1);}
			| ID '[' exp ']'	ATRIBUICAO exp										{printf("%s\n",$1);}
			| WHILE '(' exp ')' '{' lista_cmds '}' 									{printf("while\n");}
			| IF '(' exp ')' '{' lista_cmds '}'  ELSE '{' lista_cmds '}' 			{printf("entrou no if\n");}
;

;
exp:		NUM											{printf("NUM\n");}
		| ID											{printf("%s\n",$1);}
		| exp ARITMETICO exp 							{printf("ARITMETICO\n");}
		| exp RELACIONAL exp 							{printf("RELACIONAL\n");}
		| exp AND exp 									{printf("AND\n");}
		| exp  ABRE_COLCHETE exp  FECHA_COLCHETE 		{printf("ABRE_COLCHETE exp FECHA_COLCHETE\n");}
		| NOT exp  										{printf("NOT\n");}
		| '(' exp ')'									{printf("(exp)\n");}
		| 'true' 										{printf("true\n");}
		| 'false'  										{printf("false\n");}
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
