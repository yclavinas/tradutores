/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ST.h"

#define YYDEBUG 1

int errors = 0;

install ( char *sym_name ) {
	symrec *s;
	s = getsym (sym_name);
	if (s == 0) {
		s = putsym (sym_name);
		s->used = 0;
	}
	else {
		printf( "ERROR: '%s' is already defined.\n", sym_name );
		errors++;
	}
}

int context_check ( char *sym_name ) {
	if ( getsym( sym_name ) == 0 ) {
		printf( "ERROR: '%s' is an undeclared identifier.\n", sym_name );
		errors++;
		return 0;
	}
	return 1;
}

mark_used (char *sym_name) {
	symrec *s;
	s = getsym (sym_name);
	s->used = 1;
}

int is_used (char * sym_name) {
	symrec *ptr;
	for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next) {
		if (strcmp (ptr->name,sym_name) == 0){
			if (ptr->used != 0) {
				return 1;
			}
		}
	}
	return 0;
}

%}

%union {
	char *cadeia;
}

%token ABRE_COLCHETE
%left ABRE_COLCHETE
%token AND
%left AND 			/*shift_reduce solver*/
%token ARITMETICO
%left ARITMETICO 	/*shift_reduce solver*/
%token ATRIBUICAO
%token BOOLEAN
%token CLASS
%token ELSE
%token FECHA_COLCHETE
%left FECHA_COLCHETE
%token <cadeia>ID
%token IF
%token INT
%token NUM
%token NOT
%left NOT
%token RELACIONAL
%left RELACIONAL 	/*shift_reduce solver*/
%token WHILE
%%
/* Regras definindo a GLC e acoes correspondentes */
/*input:    /* empty */
/*        | input line
;
line:     '\n'
        | programa '\n'  
;*/
programa:	type CLASS '(' var_declaration ')' '{' var_declaration lista_cmds '}' 	{ printf ("Programa sintaticamente correto!\n\n"); }
;

var_declaration: 	var 												{;}
					| var ',' var_declaration 							{;}
					|													{;}
;

var: type ID 															{install($2);}
;

type:	BOOLEAN															{;}
		| INT 															{;}
		| INT '['  ']'													{;}
;

lista_cmds:	cmd															{;}
			| cmd lista_cmds 											{;}
			
; 

cmd:	ID ATRIBUICAO exp												{if(context_check($1)) {mark_used($1);}}
		| ID '[' exp ']'	ATRIBUICAO exp								{if(context_check($1)) {mark_used($1);}}
		| IF '(' exp ')' '{' lista_cmds '}'  ELSE '{' lista_cmds '}' 	{;}
		| WHILE '(' exp ')' '{' lista_cmds '}' 							{;}
;

;
exp:	exp ARITMETICO exp 												{;}
		| exp RELACIONAL exp 											{;}
		| exp AND exp 													{;}
		| exp  ABRE_COLCHETE exp FECHA_COLCHETE 						{;}
		| ID															{if(context_check($1)) {mark_used($1);}}
		| NOT exp  														{;}
		| NUM															{;}
		| '(' exp ')'													{;}
		| 'true' 														{;}
		| 'false'  														{;}
;

%%
int main (int argc, char *argv[]) 
{
	extern FILE *yyin;
	extern FILE *yyout;

	/* abre arquivo de entrada se houver */
	++argv; --argc;
	if(argc > 0)
		yyin = fopen(argv[0],"rt");
	else
		yyin = stdin;

	/* cria arquivo de saida se especificado */
	if(argc > 1)
		yyout = fopen(argv[1],"wt");
	else
		yyout = stdout;

	yyparse ();

	/* Percorre a tabela de símbolos para achar ids declarados mas não utilizados */
	symrec *ptr;
	ptr = sym_table;
	while (ptr != NULL) {
		if (!is_used(ptr->name)) {
			printf("WARNING: '%s' declared but not used.\n", ptr->name);
		}
		ptr = ptr->next;
	}
	
	/* conta a quantidade de erros na analise semantica*/
	if (errors > 0) {
		printf("\n\nProblema com a analise semantica!\n");
	}
	printf("Total of errors: %d\n", errors);


	fclose(yyin);
	fclose(yyout);
}
yyerror (s) /* Called by yyparse on error */
	char *s;
{
	printf ("Problema com a analise sintatica!\n", s);
}
