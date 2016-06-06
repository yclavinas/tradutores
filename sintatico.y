/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ST.h"

#define YYDEBUG 1
#define IMPRIMIR_TABELA_SIMBOLOS 1
//global var
extern FILE *yyin;
extern FILE *yyout;
int errors = 0;
/* pc = program counter  */
#define  pc 7

/* mp = "memory pointer" points
 * to top of memory (for temp storage)
 */
#define  mp 6

/* gp = "global pointer" points
 * to bottom of memory for (global)
 * variable storage
 */
#define gp 5

/* accumulator */
#define  ac 0

/* 2nd accumulator */
#define  ac1 1


//stepTM
//code from louden
void emitRO( char *op, int r, int s, int t, char *c)
{ fprintf(yyout,":  %5s  %d,%d,%d \n",op,r,s,t);
  // if (TraceCode) fprintf(code,"\t%s",c) ;
  // fprintf(code,"\n") ;
  // if (highEmitLoc < emitLoc) highEmitLoc = emitLoc ;
} /* emitRO */

/* Procedure emitRM emits a register-to-memory
 * TM instruction
 * op = the opcode
 * r = target register
 * d = the offset
 * s = the base register
 * c = a comment to be printed if TraceCode is TRUE
 */
void emitRM( char * op, int r, int d, int s, char *c)
{ 
	printf("%d\n", d);
	fprintf(yyout,":  %5s  %d,%d(%d) \n",op,r,d,s);
  // if (TraceCode) fprintf(code,"\t%s",c) ;
  // fprintf(code,"\n") ;
  // if (highEmitLoc < emitLoc)  highEmitLoc = emitLoc ;
} /* emitRM */

void install ( char *sym_name ) {
	symrec *s;
	s = getsym (sym_name);
	if (s == 0) {
		s = putsym (sym_name); /* colocar parametro de install: char *type_name, adicionar à chamada de putsym */
	}
	else {
		printf( "ERROR: '%s' is already defined.\n", sym_name );
		errors++;
	}
}

int contextCheck ( char *sym_name ) {
	if ( getsym( sym_name ) == 0 ) {
		printf( "ERROR: '%s' is an undeclared identifier.\n", sym_name );
		errors++;
		return 0;
	}
	return 1;
}

void markUsed (char *sym_name) {
	symrec *s;
	s = getsym (sym_name);
	s->used = 1;
}

int isUsed (char * sym_name) {
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
	int inteiro;
}

%token ABRE_COLCHETE
%left ABRE_COLCHETE
%token AND
%left AND 			/*shift_reduce solver*/
%token ARITMETICO
%left ARITMETICO 	/*shift_reduce solver*/
%token ATRIBUICAO
%token BOOLEAN /*token <cadeia>BOOLEAN. Para pegar nome do tipo.*/
%token CLASS
%token ELSE
%token FECHA_COLCHETE
%left FECHA_COLCHETE
%token <cadeia>ID
%token IF
%token INT /*token <cadeia>INT. Para pegar nome do tipo.*/
%token <inteiro>NUM
%token NOT
%left NOT
%token RELACIONAL
%left RELACIONAL 	/*shift_reduce solver*/
%token WHILE
%token ESCREVA //code from wiki
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

var: type ID 															{install($2);} /* {install($1, $2);} */
;

/*
type:	BOOLEAN															{$$=$1;}
		| INT 															{$$=$1;}
		| INT '['  ']'													{$$=$1;}
;

Ele reclama que 'var' e 'type' não tem tipos declarados.
sintatico1.y:96.138-139: $1 of `var' has no declared type
sintatico1.y:99.130-131: $$ of `type' has no declared type
sintatico1.y:100.138-139: $$ of `type' has no declared type
sintatico1.y:101.130-131: $$ of `type' has no declared type
*/
type:	BOOLEAN															{;}
		| INT 															{;}
		| INT '['  ']'													{;}
;

lista_cmds:	cmd															{;}
			| cmd lista_cmds 											{;}
			
; 

cmd:	ID ATRIBUICAO exp												{if(contextCheck($1)) {markUsed($1);}}
		| ID '[' exp ']' 	ATRIBUICAO exp								{if(contextCheck($1)) {markUsed($1);}}
		| IF '(' exp ')' '{' lista_cmds '}'  ELSE '{' lista_cmds '}' 	{;}
		| WHILE '(' exp ')' '{' lista_cmds '}' 							{;}
		| ESCREVA '(' exp ')'			 								{emitRO("OUT",ac,0,0,"write ac");}//code from wiki
;

;
exp:	exp ARITMETICO exp 												{;}
		| exp RELACIONAL exp 											{;}
		| exp AND exp 													{;}
		| exp  ABRE_COLCHETE exp FECHA_COLCHETE 						{;}
		| ID															{if(contextCheck($1)) {markUsed($1);}}
		| NOT exp  														{;}
		| NUM															{emitRM("LDC",ac,$1,0,"load const");}//code from wiki
		| '(' exp ')' 													{;}
		| 'true' 														{;}
		| 'false'  														{;}
;
//code from wiki


%%
int main (int argc, char *argv[]) 
{

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

	//code from wiki
	//emitComment("Standard prelude:");
	emitRM("LD",mp,0,ac,"load maxaddress from location 0");
	emitRM("ST",ac,0,ac,"clear location 0");
	//emitComment("End of standard prelude.");
	yyparse ();
	//emitComment("End of execution.");
	emitRO("HALT",0,0,0,"");
	//code from wiki

	/* Percorre a tabela de símbolos para achar ids declarados mas não utilizados */
	symrec *ptr;
	ptr = sym_table;
	while (ptr != NULL) {
		if (!isUsed(ptr->name)) {
			printf("WARNING: '%s' declared but not used.\n", ptr->name);
		}
		ptr = ptr->next;
	}
	
	/* conta a quantidade de erros na analise semantica*/
	if (errors > 0) {
		printf("\n\nProblema com a analise semantica!\n");
	}
	printf("Total of errors: %d\n", errors);


	if (IMPRIMIR_TABELA_SIMBOLOS) {
		/* Percorre a tabela de símbolos, caso setado*/
		printf("\n******************");
		printf("\nTABELA DE SIMBOLOS\n");
		printf("******************");
		printf("\nID\tUsado");
		printf("\n--------------\n");
		ptr = sym_table;
		while (ptr != NULL) {
			printf("%s\t%s\n", ptr->name, ptr->used!=0? "sim" : "nao");
			ptr = ptr->next;
		}
	}

	fclose(yyin);
	fclose(yyout);
}
yyerror (s) /* Called by yyparse on error */
	char *s;
{
	printf ("Problema com a analise sintatica!\n", s);
}
