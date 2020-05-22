make : diap.fl
	flex diap.fl
	yacc -v diap.y
	cc -o diap y.tab.c html.c
		
vm: p.vm
	vms -g p.vm 

vmg: p.vm
	vms -g p.vm	&	

clean:
	rm diap lex.yy.o lex.yy.c y.tab.c y.tab.h y.tab.o y.output