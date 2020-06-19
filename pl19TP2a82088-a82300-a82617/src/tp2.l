%{
#include "y.tab.h"
%}

%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z\(\)]|{acentos}      

%%

[A-Za-z]    { yylval.cvalue = *yytext; return CHAR; }

[,;]        return *yytext;

{letra}+(\ \n*\t*{letra}+)*  { yylval.svalue = strdup(yytext); return PALAVRAS; }


\ + ;



.   return ERRO;

