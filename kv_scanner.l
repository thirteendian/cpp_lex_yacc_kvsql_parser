%{
#include <string>

/*Implementation of yyFlexScanner*/
#include "kv_scanner.hpp"
#undef YY_DECL
#define YY_DECL int KV::KV_Scanner::yylex(KV::KV_Parser::semantic_type* const lval, KV::KV_Parser::location_type* location)//, kv::Driver& driver)

/*To keep classical "token" been used below, but as own defined one*/
using token = KV::KV_Parser::token;

#define yyterminate() return token::END
#define YY_NO_UNISTD_H 
/*Update location on matching*/
#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

%}


%option debug
%option nodefault
%option yyclass="MC::MC_Scanner"
%option noyywrap
%option c++

%x STRING_QUOTATION
%%

%{  /*Executed at the beginning of yylex*/
    yylval = lval;
%}

[ \t\n]+		;
\"                          {in_string_quotes=1; BEGIN(STRING_QUOTATION);}
<STRING_QUOTATION>\"        { 
                                printf("String value: %s\n", string_value); 
                                string_len=0; 
                                in_string_quotes=0; 
                                yylval.str = string_value;
                                BEGIN(INITIAL);
                                return STRING;
                            }
<STRING_QUOTATION>\\t       { string_value[string_len++] = '\t';}
<STRING_QUOTATION>\\n       { string_value[string_len++] = '\n';}
<STRING_QUOTATION>\\r       { string_value[string_len++] = '\r';}
<STRING_QUOTATION>\\b       { string_value[string_len++] = '\b';}
<STRING_QUOTATION>\\f       { string_value[string_len++] = '\f';}
<STRING_QUOTATION>\\(.|\n)  { string_value[string_len++] = yytext[1];}
<STRING_QUOTATION>[^\\\n\"]+ { 
                                char *p = yytext;
                                while(*p) {
                                    string_value[string_len++] = *p++;
                                }
                            }
<STRING_QUOTATION><<EOF>>   {printf("Error: unmatched string: %s\n",yytext); return 0;}

CREATE        {printf("%s\t\tCREATE\n",yytext); return CREATE; }//yytext point to matched input
SELECT        {printf("%s\t\tSELECT\n",yytext); return SELECT; }
KEYS          {printf("%s\t\tKEYS\n",yytext); return KEYS; }
GET           {printf("%s\t\tGET\n",yytext); return GET; }
FROM          {printf("%s\t\tFROM\n",yytext); return FROM; }
TO            {printf("%s\t\tTO\n",yytext); return TO; }
GETCS         {printf("%s\t\tGETCS\n",yytext); return GETCS; }
AND           {printf("%s\t\tAND\n",yytext); return AND; }
EXISTS        {printf("%s\t\tEXISTS\n",yytext); return EXISTS; }
SET           {printf("%s\t\tSET\n",yytext); return SET; }
APPEND        {printf("%s\t\tAPPEND\n",yytext); return APPEND; }
GETL          {printf("%s\t\tGETL\n",yytext); return GETL; }
GETLEN        {printf("%s\t\tGETLEN\n",yytext); return GETLEN; }
PUSH          {printf("%s\t\tPUSH\n",yytext); return PUSH; }
INSERT        {printf("%s\t\tINSERT\n",yytext); return INSERT; }
GETS          {printf("%s\t\tGETS\n",yytext); return GETS; }
ADD           {printf("%s\t\tADD\n",yytext); return ADD; }
DELETE        {printf("%s\t\tDELETE\n",yytext); return DELETE; }
RENAME        {printf("%s\t\tRENAME\n",yytext); return RENAME; }
COPY          {printf("%s\t\tCOPY\n",yytext); return COPY; }
LS            {printf("%s\t\tLS\n",yytext); return LS; }
POP           {printf("%s\t\tPOP\n",yytext); return POP; }
REMOVE        {printf("%s\t\tREMOVE\n",yytext); return REMOVE; }
FLUSH         {printf("%s\t\tFLUSH\n",yytext); return FLUSH; }
MOVE          {printf("%s\t\tMOVE\n",yytext); return MOVE; }

"("							{printf("%s\t\t(\n",yytext); return '('; }
")"							{printf("%s\t\t)\n",yytext); return ')'; }
";"							{printf("%s\t\t;\n",yytext); return ';'; }
","							{printf("%s\t\tCOMMA\n",yytext); return COMMA; }
"["                            {printf("%s\t\t[\n",yytext); return '['; }
"]"                           {printf("%s\t\t]\n",yytext); return ']'; }
(([a-zA-Z][a-zA-Z0-9]{0,127})(\.([a-zA-Z][a-zA-Z0-9]{0,127}))?)		{printf("%s\t\tIDENTIFIER\n",yytext); return IDENTIFIER; }
[0-9]+							{printf("%s\t\tNUMBER\n",yytext); return NUMBER; }
%%