prog: bison flex gcc

bison:
	bison -d sintatico.y

flex:
	flex lexico.l

gcc:
	gcc sintatico.tab.c lex.yy.c

rm:
	del sintatico.tab.c sintatico.tab.h lex.yy.c a.out

deb:
	bison -v sintatico.y

run:
	a.exe teste.mlp teste.tm
