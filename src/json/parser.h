
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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
     TOKEN_STRING = 258,
     TOKEN_INTEGER = 259,
     TOKEN_DECIMAL = 260,
     TOKEN_TRUE = 261,
     TOKEN_FALSE = 262,
     TOKEN_NULL = 263,
     TOKEN_LBRACE = 264,
     TOKEN_RBRACE = 265,
     TOKEN_LBRACKET = 266,
     TOKEN_RBRACKET = 267,
     TOKEN_COMMA = 268,
     TOKEN_COLON = 269
   };
#endif
/* Tokens.  */
#define TOKEN_STRING 258
#define TOKEN_INTEGER 259
#define TOKEN_DECIMAL 260
#define TOKEN_TRUE 261
#define TOKEN_FALSE 262
#define TOKEN_NULL 263
#define TOKEN_LBRACE 264
#define TOKEN_RBRACE 265
#define TOKEN_LBRACKET 266
#define TOKEN_RBRACKET 267
#define TOKEN_COMMA 268
#define TOKEN_COLON 269




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 19 "src/json/json.y"

    struct token litera;
    struct node *node;



/* Line 1676 of yacc.c  */
#line 87 "src/json/parser.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


