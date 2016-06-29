/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ST.h"
// #include "code.h"

#define YYDEBUG 1
#define IMPRIMIR_TABELA_SIMBOLOS 1

//global var
extern FILE *yyin;
extern FILE *yyout;
int errors = 0;
int endMemData = 0;
int memVal=0;
int operador = 0;
static int tmpOffset = 0;
int savedLoc1=0,savedLoc2=0,currentLoc=0, savedLocWhile=0, qtdIF_S1=0;

/* TM location number for current instruction emission */
static int emitLoc = 0;

/* Highest TM location emitted so far
   For use in conjunction with emitSkip,
   emitBackup, and emitRestore */
static int highEmitLoc = 0;

/* pc = program counter  */
#define pc 7

/* mp = "memory pointer" points
 * to top of memory (for temp storage)
 */
#define mp 6

/* gp = "global pointer" points
 * to bottom of memory for (global)
 * variable storage
 */
#define gp 5

/* accumulator */
#define ac 0

/* 2nd accumulator */
#define ac1 1

//end global


void emitRO(char *op, int r, int s, int t, char *c) {
	fprintf(yyout,"%3d:  %5s  %d,%d,%d \n",emitLoc++,op,r,s,t);
	if (highEmitLoc < emitLoc)
		highEmitLoc = emitLoc;
}

void emitRM(char * op, int r, int d, int s, char *c) { 
	fprintf(yyout,"%3d:  %5s  %d,%d(%d) \n",emitLoc++,op,r,d,s);
	if (highEmitLoc < emitLoc)
		highEmitLoc = emitLoc;
} 

void install (char *sym_name) {
	symrec *s;
	s = getsym (sym_name);
	if (s == 0) {
		s = putsym (sym_name, endMemData);
		endMemData++;
	}
	else {
		printf( "ERROR: '%s' is already defined.\n", sym_name );
		errors++;
	}
}

int contextCheck (char *sym_name) {
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

int getMemVal(char *sym_name) {
	symrec *s;
	s = getsym (sym_name);
	return (s->address);
}

int getOp(char *a){
	if (strcmp(a,"+")==0){
		return (1);
	}
	else if (strcmp(a, "-")==0){
		return (2);
	}
	else if (strcmp(a, "/")==0){
		return (3);
	}
	else if (strcmp(a, "*")==0){
		return (4);
	}
	return(0);
}

int emitSkip(int howMany) {
	int i = emitLoc;
	emitLoc += howMany;
	if (highEmitLoc < emitLoc)
		highEmitLoc = emitLoc;
	return i;
} /* emitSkip */


void emitBackup(int loc) { 
  emitLoc = loc ;
} /* emitBackup */

/* Procedure emitRestore restores the current 
 * code position to the highest previously
 * unemitted position
 */
void emitRestore(void) {
	emitLoc = highEmitLoc;
}

/* Procedure emitRM_Abs converts an absolute reference 
 * to a pc-relative reference when emitting a
 * register-to-memory TM instruction
 * op = the opcode
 * r = target register
 * a = the absolute location in memory
 * c = a comment to be printed if TraceCode is TRUE
 */
void emitRM_Abs( char *op, int r, int a, char * c) {
	fprintf(yyout,"%3d:  %5s  %d,%d(%d) \n",emitLoc,op,r,a-(emitLoc+1),pc);
	++emitLoc;
	if (highEmitLoc < emitLoc)
		highEmitLoc = emitLoc;
}
%}

%union {
	char *cadeia;
	int inteiro;
}

%token ABRE_COLCHETE
%token AND
%token <cadeia>ARITMETICO
%token ATRIBUICAO
%token BOOLEAN
%token CLASS
%token ELSE
%token ESCREVA
%token FECHA_COLCHETE
%token <cadeia>ID
%token IF
%token INT
%token LEIA
%token NOT
%token <inteiro>NUM
%token RELACIONAL
%token WHILE

%left AND
%left FECHA_COLCHETE
%left ABRE_COLCHETE
%left NOT
%left ARITMETICO
%left RELACIONAL
%%

programa:	type CLASS '(' var_declaration ')' '{' var_declaration lista_cmds '}'	{printf ("Programa sintaticamente correto!\n\n");}
;

var_declaration: 	var 						{;}
					| var ',' var_declaration 	{;}
					|							{;}
;

var:	type ID 	{install($2);}
;


type:	INT		{;}
		// | BOOLEAN 			{;}
		// | INT '['  ']'	{;}
;

lista_cmds:		cmd					{;}
				| cmd lista_cmds 	{;}
			
;

cmd:	ID
		ATRIBUICAO
		exp 
		{if(contextCheck($1))
			markUsed($1);
		memVal = getMemVal($1);
		emitRM("ST",ac,memVal,gp,"assign: store value");}
		// | IF '(' exp ')' '{' lista_cmds '}'  ELSE '{' lista_cmds '}' 	{;}
		| IF 	'(' exp_rel ')'
				{savedLoc1 = emitSkip(0);
				 emitSkip(1);}
				'{' lista_cmds '}'	{;}
				{qtdIF_S1 = emitLoc - savedLoc1 - 1;
				emitBackup(savedLoc1);
				emitRM("JLE",ac,qtdIF_S1,pc,"br if true");
				emitRestore();}
		// | WHILE {savedLocWhile = emitSkip(0);}
		// 		'(' exp_rel ')'
		// 		{savedLoc1 = emitSkip(1);} 
		// 		{savedLoc2 = emitSkip(1);
		// 		currentLoc = emitSkip(0);
		// 		emitBackup(savedLoc1);
		// 		emitRM_Abs("JEQ",ac,currentLoc,"if: jmp to else");
		// 		currentLoc = emitSkip(0);
		// 		emitBackup(savedLoc2);
		// 		emitRM_Abs("LDA",pc,currentLoc,"jmp to end");
		// 		emitRestore();}
		// 		'{' lista_cmds '}'
		// 		{emitRM_Abs("JEQ",ac,savedLocWhile,"repeat: jmp back to body");}
		| ESCREVA 	'(' exp ')'
					{emitRO("OUT",ac,0,0,"write ac");}
		| LEIA '(' ID ')'
				{emitRO("IN",ac,0,0,"read integer value");
				memVal = getMemVal($3);
	        	emitRM("ST",ac,memVal,gp,"read: store value");}
;

exp_rel:	exp
			{emitRM("ST",ac,tmpOffset--,mp,"op: push left");}
			RELACIONAL
 			exp
 			{emitRM("ST",ac,tmpOffset--,mp,"op: push left");
 			emitRM("LD",ac1,++tmpOffset,mp,"op: load left");
 			emitRM("LD",ac,++tmpOffset,mp,"op: load left");
			emitRO("SUB",ac,ac1,ac,"op <");}
;

exp:	exp 		{emitRM("ST",ac,tmpOffset--,mp,"op: push left");}
		ARITMETICO
		exp 		{emitRM("LD",ac1,++tmpOffset,mp,"op: load left");
					operador=getOp($3);
					if(operador==1) {
						emitRO("ADD",ac,ac1,ac,"op +");
					}
						else if (operador==2) {
							emitRO("SUB",ac,ac1,ac,"op -");
						}
							else if (operador==3) {
								emitRO("DIV",ac,ac1,ac,"op /");
							}
								else if (operador==4){
									emitRO("MUL",ac,ac1,ac,"op *");
								}
					}
		/*| exp AND exp 													{;}*/
		/*| exp ABRE_COLCHETE exp FECHA_COLCHETE 							{;}*/
		| fator {;}
		| '(' exp ')' 	{;}
;

fator:	| ID 	{if(contextCheck($1)) {
					markUsed($1);
				}
				memVal = getMemVal($1);
				emitRM("LD",ac,memVal,gp,"load id value");}
		| NUM	{emitRM("LDC",ac,$1,0,"load const");}
;

%%
int main (int argc, char *argv[])  {
	
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

	//emitComment("Standard prelude:");
	emitRM("LD",mp,0,ac,"load maxaddress from location 0");
	emitRM("ST",ac,0,ac,"clear location 0");
	//emitComment("End of standard prelude.");
	yyparse ();
	//emitComment("End of execution.");
	emitRO("HALT",0,0,0,"");

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
		printf("\n************");
		printf("\nSYMBLE TABLE\n");
		printf("************");
		printf("\nID\tUSED\tADDRESS");
		printf("\n-----------------------\n");
		ptr = sym_table;
		while (ptr != NULL) {
			printf("%s\t%s\t%d\n", ptr->name, ptr->used!=0? "yes" : "no", ptr->address);
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
