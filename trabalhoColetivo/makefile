prog: bison flex gcc exec
bison:
	bison -d sintaticoColetivo.y
flex:
	flex lexicoColetivo.l
gcc:
	gcc sintaticoColetivo.tab.c lex.yy.c

rm:
	rm sintaticoColetivo.tab.c sintaticoColetivo.tab.h lex.yy.c a.out

exec:
	./a.out < casosTestes.txt
