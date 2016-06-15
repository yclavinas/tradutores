/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ABRE_COLCHETE = 258,
     AND = 259,
     ARITMETICO = 260,
     ATRIBUICAO = 261,
     BOOLEAN = 262,
     CLASS = 263,
     ELSE = 264,
     FECHA_COLCHETE = 265,
     ID = 266,
     IF = 267,
     INT = 268,
     NUM = 269,
     NOT = 270,
     RELACIONAL = 271,
     WHILE = 272,
     ESCREVA = 273,
     LEIA = 274
   };
#endif
/* Tokens.  */
#define ABRE_COLCHETE 258
#define AND 259
#define ARITMETICO 260
#define ATRIBUICAO 261
#define BOOLEAN 262
#define CLASS 263
#define ELSE 264
#define FECHA_COLCHETE 265
#define ID 266
#define IF 267
#define INT 268
#define NUM 269
#define NOT 270
#define RELACIONAL 271
#define WHILE 272
#define ESCREVA 273
#define LEIA 274




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 160 "sintatico.y"
{
	char *cadeia;
	int inteiro;
}
/* Line 1529 of yacc.c.  */
#line 92 "sintatico.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

