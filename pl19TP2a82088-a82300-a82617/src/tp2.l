%{
#include "y.tab.h"
%}

%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z\(\)-]|{acentos}
palavras   {letra}{1,}(\ {letra}{1,})*
palavrasinc ((\ {0,7}{letra}{1,})|(\ {0,7}(\-(\ {1,2}))))*

%%

[A-Za-z]\ *[\r\n]+    { yylval.cvalue = *yytext; return CHAR; }

[\r\n] ;

[,;:]        return *yytext;

^{palavras}  { yylval.svalue = strdup(yytext); return PALAVRAS; }

^{palavras}\:(\r\n)+/{palavras}  ;

{palavras}  { yylval.svalue = strdup(yytext); return PALAVRAS; }

{palavras}([\r\n]+[\ \t]{3,}{palavras})+  { yylval.svalue = strdup(yytext); return PALAVRAS; }


^\ {palavrasinc} { yylval.svalue = strdup(yytext); return PALAVRASINC; }

\ + ;



.   return ERRO;

