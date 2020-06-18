yfile = tp2.y
lfile = tp2.l

tp2 : y.tab.o lex.yy.o
	gcc -o tp2 y.tab.o lex.yy.o -ll

y.tab.o : y.tab.c
	gcc -c y.tab.c

lex.yy.o : lex.yy.c
	gcc -c lex.yy.c

y.tab.c y.tab.h : $(yfile)
	yacc -d $(yfile)

lex.yy.c :  $(lfile) y.tab.h
	flex $(lfile)

dot:
	yacc -g $(yfile)
	dot -Tpdf y.dot > automato.pdf