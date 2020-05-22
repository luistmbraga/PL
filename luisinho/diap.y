%{
#include "html.h"
void yyerror (char *s);
int yylex();
int i;
%}

%union{
    char* nome;
    char* tempo;
    char* final;
    char* atributo;
}

%type <nome> NOME
%type <tempo> TEMPO
%type <final> FINAL
%type <atributo> IMAGEM VIDEO TITULO AUDIO PAGINICIAL PAGCREDITOS  TEXTO T M pags pag conteudo cabecalho lista

%token NOME TEMPO IMAGEM VIDEO TITULO AUDIO FINAL TEXTO ITEM 

%%
pags : pags pag                  { constroi_pagina($2, i);
                                    i++; 
                                 }
     | pag                       { constroi_pagina($1, i); 
                                    i++;
                                 }
     ;

pag: cabecalho '{' conteudo '}'  { asprintf(&$$, "%s%s", $1, $3);}
    ;

cabecalho: NOME '/' TEMPO        { asprintf(&$$, "<meta http-equiv=\"REFRESH\" content=\"%s; URL=%d.html\">\n", $3, i+1); }
         | NOME '/' FINAL        { $$ = "";}


conteudo:  conteudo T       { asprintf(&$$, "%s%s",$1, $2); }
          | conteudo TITULO      { asprintf(&$$, "%s<center><h1>%s</h1></center>\n", $1, $2); }
          | conteudo lista       { asprintf(&$$, "%s%s",$1, $2);}
          | conteudo PAGINICIAL  { asprintf(&$$, "%s%s", $1, $2); }
          | conteudo PAGCREDITOS { asprintf(&$$, "%s%s", $1, $2);}
          |                      { $$ = "";}
          ;

PAGINICIAL : '[' TITULO IMAGEM TEXTO ']' { asprintf(&$$, "<center><h1>%s</h1></center>\n <center><p><img src=\"%s\" align=\"middle\" height=\"200\" width=\"520\"></p></center>\n <center><p><p><b>%s</b></p></p></center>\n", $2,$3,$4);}

PAGCREDITOS : '[' TITULO IMAGEM TEXTO TEXTO']' { asprintf(&$$, "<center><h1>%s</h1></center>\n <center><p><img src=\"%s\" align=\"middle\" height=\"200\" width=\"520\"></p></center>\n <center><p><p><b>%s</b></p></p></center>  <center><p><p><b>%s</b></p></p></center>\n ", $2,$3,$4,$5);}

lista:  '[' M ']' { asprintf(&$$, "<div class=\"parent\"><ul> %s </ul></div>", $2); }
       ;

M :  T            { asprintf(&$$, "<li> %s </li>", $1); }
    | M  T        { asprintf(&$$, "%s <li> %s </li>", $1, $2); }

T :  IMAGEM       { asprintf(&$$, "<center><p><img src=\"%s\" align=\"middle\" height=\"200\" width=\"520\"></p></center>\n",$1); }
    | VIDEO       { asprintf(&$$, "<center><p><iframe width=\"420\" height=\"345\" src=\"%s\">\n</iframe></p></center>\n",$1); }
    | TEXTO       { asprintf(&$$, "<center><p><p>%s</p></p></center>\n",$1);}
    | AUDIO       { asprintf(&$$, "<center><p><audio controls><source src=\"%s\" type=\"audio/mpeg\"></audio></p></center>\n", $1); }
%%
#include "lex.yy.c"
int main(int argc, char** argv){

  i = 0;

  yyparse();

  return 0;

}


void yyerror (char *s) {
   fprintf (stderr, "%s\n",s);
}

