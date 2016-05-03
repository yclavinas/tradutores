prog: bison flex gcc exec
bison:
	bison -d sintatico.y
flex:
	flex lexico.l
gcc:
	gcc sintatico.tab.c lex.yy.c

rm:
	rm sintatico.tab.c sintatico.tab.h lex.yy.c a.out

exec:
	./a.out teste.bla teste
