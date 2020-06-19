%{
#include "y.tab.h"
%}

%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z\(\)]|{acentos} 
palavras   {letra}{2,}(\ {letra}{2,})*
palavrasinc (\ {0,1}\-\ {1,2}{letra}{2,})?((\ {0,1}{letra}{2,})|(\ {0,1}(\-(\ {1,2}))))*

%%

[A-Za-z]    { yylval.cvalue = *yytext; return CHAR; }

[\r\n] ;

[,;:\ ]        return *yytext;


{palavras}([\r\n]+[\ \t]+{palavras})+  { yylval.svalue = strdup(yytext); return PALAVRAS; }

{palavras}  { yylval.svalue = strdup(yytext); return PALAVRAS; }

{palavrasinc} { yylval.svalue = strdup(yytext); return PALAVRAS; }

\ + ;



.   return ERRO;

