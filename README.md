# cpp_lex_yacc_kvsql_parser
This is a mini project for parsing key value sql syntax


## How to compile/run

1. generate yacc function and headers: `yacc -d <.y>`. Note that `-d` will generate corresponding header file `y.tab.h`
2. generate lex.yy.c: `lex <.l>`
3. compile them together : `gcc lex.yy.c y.tab.c -o <program name>`

## misc
1. To use `isupper()` and `islower()`, we must explicitly include `<ctype.h>` 
2. Inside mylang.y, we need delare prototypes for `yylex()` and `yyerror`
right after `include <stdio.h>` at the PART I 

3. using longer match can prevent match keywords within larger words.
This is due to *Shift/Reduce* conflicts and yacc prefer to go *Shift*.
For example `[a-zA-Z_][a-zA-Z_0-9]* {<do nothing related>}` will match all possible word and do thing not relatd to keyword, thus avoid key word inside longer word.
4. yacc *Right is wrong and left is right*.