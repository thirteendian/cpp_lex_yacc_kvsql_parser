make_yacc: yacc -d mylang.y
make_lex: lex mylang.l
make_gcc: gcc -o mylang lex.yy.c y.tab.c -ll
all: make_yacc make_lex make_gcc
clean: rm -f lex.yy.c y.tab.c y.tab.h mylang
