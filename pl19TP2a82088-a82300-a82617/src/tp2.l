%{
#include "y.tab.h"
%}

%option yylineno
%%

[\n\r\ ]    ;

[A-Za-z]    { yylval.cvalue = *yytext; return CHAR; }

[a-zA-Z]+(\ [a-zA-Z\(\)]+\n)* { yylval.svalue = strdup(yytext); return PALAVRAS; }

\ + ;

.   return ERRO;

