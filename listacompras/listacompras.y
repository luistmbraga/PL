%code{
#include <stdio.h>
extern int yylex();
int yyerror(char* s);
}

%union{char* txt; float flot; int it;}

%token <txt>TEXTO
%token <flot>FLOAT
%token <it>INT

%%

Compras : Listacompras
        ;

Listacompras : Seccao '\n' Listacompras
             | Seccao
             ;

Seccao : Categoria ':' '[' '\r\n' Produtos ']'
       ;

Categoria : TEXTO
          ;

Produtos : Produto
         | Produto '\n' Produtos
         ;

Produto : Codigo ',' Designacao ',' Preco ',' '(' Quantidade ')'

Codigo : INT
       ;

Designacao : TEXTO
           ;

Preco : FLOAT
      ;

Quantidade : Unidade ',' Valor

Unidade : FLOAT ':' TEXTO
        ;

Valor : FLOAT
      ;

%%

#include "lex.yy.c"

int main(){
	yyparse();
	return 0;
}

int yyerror(char* s){
	printf("erro %d: %s junto a '%s'\n", yylineno, s, yytext);
}