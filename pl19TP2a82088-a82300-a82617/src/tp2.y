%{
#include <stdio.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char* yytext;

void yyerror();
void erroSem(char*);
%}

%union{
    char* svalue;
    char cvalue;
}

%token ERRO
%token <svalue> PALAVRAS
%token <cvalue> CHAR
%token <svalue> BEGI
%type <svalue> Original
%type <svalue> Significado
%type <cvalue> Letra
%%

DicFinance
    : Capitulos
    ;

Capitulos
    : Capitulos Capitulo
    |
    ;

Capitulo
    : Letra { printf("Capitulo - %c\n", $1); } Traducoes
    ;

Letra
    : CHAR   { $$ = $1; }
    ;

Traducoes
    : Traducoes Traducao
    |
    ;
         

Traducao
    : Original Significado { printf("%s -> %s\n", $1, $2); }
    ;

Original
    : PALAVRAS  { $$ = $1; }
    ;

Significado
    : PALAVRAS  { $$ = $1; } 
    ;

%%
int main(){
    yyparse();
    return 0;
}

void erroSem(char *s){
    printf("Erro Semântico na linha: %d: %s\n", yylineno, s);
    yyparse();
}

void yyerror(){
    printf("Erro Sintático ou Léxico na linha: %d, com o texto: %s\n", yylineno, yytext);
    yyparse();
}
