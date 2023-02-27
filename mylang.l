%{
    #include "y.tab.h"
    #include <stdio.h>
    #include <string.h>
    #define MAX_STRING_SIZE 1024
    char string_value[MAX_STRING_SIZE];
    int string_len = 0;
    int in_string_quotes = 0;//1 if in string quotes, 0 if not
%}
%option noyywrap
/**************** ABOUT LEX OPTION ****************/
/* yywarp() will return 0 to resume scanning if another file come from "yyin"*/
/* Modern Flex do not need it, thus here we always include this option*/
/* option yylineno will count the line number of the input file(auto increase)*/
/* option case-insensitive treat upper and lowercase the same, but not influence reads in yytext*/

/**************** ABOUT LEX FUNCTION ****************/
/* yylval store the value */
/* yylineno is the line number of the input file*/
/* yyterminate() will terminate the scanner return YY_NULL, and bison will interprets as the EOF*/

/**************** ABOUT REGULAR EXPRESSION ****************/
/* [] match any character in the bracket*/
/* () group the regular expression, a(bc|de) = abc or ade*/
/* {} repeat the regular expression, a{3} = aaa, A{1,3} = 1 to 3 As*/
/* | or, a|b = a or b*/
/* ^ match the beginning of the line*/
/* $ match the end of the line*/
/* . match any character except newline*/
/* * repeat the previous regular expression 0 or more times, [ \t]* match optional spaces/tabs */
/* + repeat the previous regular expression 1 or more times, [ \t]+ match 1 or more spaces/tabs */
/* ? repeat the previous regular expression 0 or 1 time, [ \t]? match 0 or 1 spaces/tabs */
/* \ escape the metacharacter, \. match . */
/* "..." anything inside treated literally*/
/* '...' anything inside treated literally*/
/* / match the regular expression followed by another regular expression, a/b = matched a only followed by b*/
/*\'(([^\']|\\\')*[^\\])?\'				{printf("%s\t\tSTRING\n",yytext); return STRING; }*/
/*\"(([^\"]|\\\")*[^\\])?\"				{printf("%s\t\tSTRING\n",yytext); return STRING; }*/
/*<STRING>\\'       { string_value[string_len++] = '\'';}*/
/*<STRING>\\"       { string_value[string_len++] = '\"';}*/
/*// Change \n etc. to it's corresponding character*/

%x STRING_QUOTATION
/**************** ABOUT MATCHING STRING ****************/
/* %x defineds a new state, and the following rules will be applied in this state, here we define a STRING state*/
/* .|\n match everything, but ([^"]|\n)+ can match a long string of text at once*/
/* here we exclude the " so the following rule can match the end of string*/
/* Do not match the STRING in single flex pattern, because it will limit the size to 16K*/
%%
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
/*when program need lex, call yylex() to enter scanner routine above*/

// int yywrap(void)
// {
//     return 1;
// }
