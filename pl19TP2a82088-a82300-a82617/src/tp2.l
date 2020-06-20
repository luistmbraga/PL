%{
#include "y.tab.h"
#include <ctype.h>
#include <stdio.h>

void strip_linebreak(char* str);
void strip_extra_spaces(char* str);

int beginread = 0;
%}

%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z\(\)-\/'0-9]|{acentos}
palavras   {letra}{1,}(\ {letra}{1,})*
palavrasinc ((\ {0,1}{letra}{1,})|(\ {0,2}(\-(\ {0,1}))))*

%%

(?i:__BEGIN__)       { beginread = 1; }

[A-Za-z]\ *[\r\n]+    { if(beginread) {yylval.cvalue = *yytext; return CHAR; } }

[\r\n] ;

[,;:]       { if(beginread){return *yytext;} } 

^{palavras}((\r\n)\ {1,2}{palavras})* { if(beginread){ strip_linebreak(yytext); strip_extra_spaces(yytext); yylval.svalue = strdup(yytext); return PALAVRAS; } }

^{palavras}\:(\r\n)+/{palavras}  ;

{palavras}  { if(beginread){ yylval.svalue = strdup(yytext); return PALAVRAS;} }

{palavras}([\r\n]+[\ \t]{8,}{palavras})+  { if(beginread){ strip_linebreak(yytext); strip_extra_spaces(yytext); yylval.svalue = strdup(yytext); return PALAVRAS; } }


^\ {1,4}{palavrasinc} { if(beginread){ yylval.svalue = strdup(yytext); return PALAVRASINC; } }

\ + ;


.   { if(beginread){  return ERRO; } }

%%

void strip_linebreak(char* str) {
    int i;
    for(i=0; str[i]; ++i)
        if(i > 0 && str[i] == '\n' && str[i-1] == '\r'){
            str[i] = ' ';
            str[i-1] = ' ';
        }
        if(str[i] == '\n')
            str[i] = ' ';
}

void strip_extra_spaces(char* str) {
  int i, x;
  for(i=x=0; str[i]; ++i)
    if(!isspace(str[i]) || (i > 0 && !isspace(str[i-1]))      )
      str[x++] = str[i];
  str[x] = '\0';
}

