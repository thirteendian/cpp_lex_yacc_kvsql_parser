/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CREATE = 258,
    SELECT = 259,
    KEYS = 260,
    GET = 261,
    FROM = 262,
    TO = 263,
    GETCS = 264,
    AND = 265,
    EXISTS = 266,
    SET = 267,
    APPEND = 268,
    GETL = 269,
    GETLEN = 270,
    PUSH = 271,
    SETL = 272,
    INSERT = 273,
    GETS = 274,
    ADD = 275,
    DELETE = 276,
    RENAME = 277,
    COPY = 278,
    LS = 279,
    POP = 280,
    REMOVE = 281,
    FLUSH = 282,
    MOVE = 283,
    COMMA = 284,
    IDENTIFIER = 285,
    STRING = 286,
    NUMBER = 287
  };
#endif
/* Tokens.  */
#define CREATE 258
#define SELECT 259
#define KEYS 260
#define GET 261
#define FROM 262
#define TO 263
#define GETCS 264
#define AND 265
#define EXISTS 266
#define SET 267
#define APPEND 268
#define GETL 269
#define GETLEN 270
#define PUSH 271
#define SETL 272
#define INSERT 273
#define GETS 274
#define ADD 275
#define DELETE 276
#define RENAME 277
#define COPY 278
#define LS 279
#define POP 280
#define REMOVE 281
#define FLUSH 282
#define MOVE 283
#define COMMA 284
#define IDENTIFIER 285
#define STRING 286
#define NUMBER 287

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 25 "mylang.y"

    struct Node* node;
#line 29 "mylang.y"

    char* str;

#line 128 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
