%{
#include <stdio.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char* yytext;
extern int yy_flex_debug;

void yyerror();
void erroSem(char*);
%}

%union{
    char* svalue;
    char cvalue;
}

%token ERRO
%token <svalue> PALAVRAS
%token <svalue> PALAVRASINC
%token <cvalue> CHAR
%token <svalue> BEGI
%type <svalue> Original
%type <svalue> Significado
%type <svalue> OriginalIncompleto
%type <cvalue> Letra
%type <svalue> TraducaoSimples
%type <svalue> TraducoesIncompletas
%type <svalue> TraducaoIncompleta
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
    : Significado TraducoesIncompletas   { printf("Trad Inc %s    %s\n", $1, $2); }
    | TraducoesIncompletas               { printf("Trad Inc     %s\n", $1); }
    ;

TraducoesIncompletas
    : TraducoesIncompletas TraducaoIncompleta { $$ = strcat($1, $2); }
    | TraducaoIncompleta                      { $$ = $1; }
    ;

TraducaoIncompleta
    : OriginalIncompleto Significado  { $$ = strcat($1, $2); }
    ; 

OriginalIncompleto
    : PALAVRASINC      { $$ = $1; }
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
    yy_flex_debug = 1;
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
