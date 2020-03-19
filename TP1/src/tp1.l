%{
/* Declaracoes C diversas */
#include <comentarios.h>
%}
/* Abreviaturas de ER */

%%

%%
int yywrap()
{ return(1); }

int main(){ 
yylex();

Nivel r = testeInit();

printf("Número total de filhos de forma acumulativa: %ld\n", numberOfRepliesV1(r));

return 0;
}
