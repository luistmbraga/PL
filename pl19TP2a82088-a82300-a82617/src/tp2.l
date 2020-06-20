%{
#include "y.tab.h"
#include <ctype.h>
#include <stdio.h>

void strip_linebreak(char* str);
void strip_extra_spaces(char* str);
%}

%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z\(\)-\/]|{acentos}
palavras   {letra}{1,}(\ {letra}{1,})*
palavrasinc ((\ {0,1}{letra}{1,})|(\ {0,2}(\-(\ {0,1}))))*

%%

[A-Za-z]\ *[\r\n]+    { yylval.cvalue = *yytext; return CHAR; }

[\r\n] ;

[,;:]        return *yytext;

^{palavras}  { yylval.svalue = strdup(yytext); return PALAVRAS; }

^{palavras}\:(\r\n)+/{palavras}  ;

{palavras}  { yylval.svalue = strdup(yytext); return PALAVRAS; }

{palavras}([\r\n]+[\ \t]{8,}{palavras})+  { strip_linebreak(yytext); strip_extra_spaces(yytext); yylval.svalue = strdup(yytext); return PALAVRAS; }


^\ {1,4}{palavrasinc} { yylval.svalue = strdup(yytext); return PALAVRASINC; }

\ + ;



.   return ERRO;

%%

void strip_linebreak(char* str) {
    int i;
    for(i=0; str[i]; ++i)
        if(str[i] == '\n' || str[i] == '\r' || ( i > 0 && str[i] == '\n' && str[i-1] == '\r'))
            str[i] = ' ';
}

void strip_extra_spaces(char* str) {
  int i, x;
  for(i=x=0; str[i]; ++i)
    if(str[i] == '\n' || str[i] == '\r')
        str[i] = ' ';
    if(!isspace(str[i]) || (i > 0 && !isspace(str[i-1]))      )
      str[x++] = str[i];
  str[x] = '\0';
}

