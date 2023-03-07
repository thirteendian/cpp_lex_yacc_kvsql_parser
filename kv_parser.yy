
//C++ version of Bison
//generate stack.hh location.hh and position.hh
//defined class yy::parser
%skeleton "lalr1.cc"
%require  "3.0"
%debug 
%defines
%define api.namespace {KV}
%define parser_class_name {KV_Parser}

%code requires{
    namespace KV{
        class KV_Driver;
        class KV_Scanner;
    }
//Bug removes this defination in Bison 3.0 thus we add it here
# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif
    
}
%parse-param {KV::KV_Scanner& scanner}
%parse-param {KV::KV_Driver& driver}

%code{
    #include <iostream>
    #include <cstdlib>
    #include <fstream>
    #include "kv_driver.hpp"
#undef yylex
#define yylex scanner.yylex
}

#define api.value.type variant
#define parse.assert



