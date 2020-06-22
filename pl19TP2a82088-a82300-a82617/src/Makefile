yfile = tp2.y
lfile = tp2.l

tp2 : y.tab.o lex.yy.o
	gcc -o tp2 y.tab.o lex.yy.o -ll

y.tab.o : y.tab.c
	gcc -c y.tab.c

lex.yy.o : lex.yy.c
	gcc -c lex.yy.c

y.tab.c y.tab.h : $(yfile)
	yacc -d -v $(yfile)

lex.yy.c :  $(lfile) y.tab.h
	flex -d $(lfile)

dot:
	yacc -g $(yfile)
	dot -Tpdf y.dot > automato.pdf 

clean: 
	rm lex.yy.c 
	rm lex.yy.o 
	rm y.tab.c 
	rm y.tab.h 
	rm y.tab.o 
	rm y.dot 
	rm automato.pdf 
	rm tp2