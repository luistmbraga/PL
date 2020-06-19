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
%type <svalue> TraducaoSimples
%type <svalue> TraducoesIncompletas
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
    : Original { printf("Original - %s    ", $1); } Traducao Traducoes 
    |
    ;

Traducao
    : TraducaoSimples       { printf("Trad Simples - %s\n", $1);    }
    | ':' TraducaoComplexa
    ;

TraducaoSimples
    : Significado { $$ = $1; }
    ;

TraducaoComplexa
    : Significado TraducoesIncompletas
    | TraducoesIncompletas
    ;

TraducoesIncompletas
    : TraducoesIncompletas ' ' Original TraducaoSimples { $$ = strcat($3, $4); }
    | ' ' Original TraducaoSimples  { printf("Trad Comp 1 - %s     traducoes -   %s\n", $2, $3); }
    ;

Original
    : PALAVRAS  { $$ = $1; }
    ;

Significado
    : Significado ';' PALAVRAS  { $$ = strcat($1, $3); }
    | Significado ',' PALAVRAS  { $$ = strcat($1, $3); }
    | PALAVRAS  { $$ = $1; }
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
