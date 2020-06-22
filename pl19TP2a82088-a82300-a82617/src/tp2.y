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
    : PALAVRAS  { $$ = $1; }
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
    //yyparse();
}

void splitSignificado(char* sig, char* simb){
   // Extract the first token
   char * token = strtok(sig, simb);
   // loop through the string to extract all other tokens
   while( token != NULL ) {
      printf( " %s\n", token ); //printing each token
      token = strtok(NULL, simb);
   }
}

int findSep(char * sig, char sep){
    
    int result = 0;

    int len = strlen(sig);
    
    for(int i = 0; i < len && result!=1; i++)
        if(sig[i] == sep) result = 1;

    printf("%d\n", result);

    return result;
}



char *replaceWord(const char *s, const char *oldW, 
								const char *newW) 
{ 
	char *result; 
	int i, cnt = 0; 
	int newWlen = strlen(newW); 
	int oldWlen = strlen(oldW); 

	// Counting the number of times old word 
	// occur in the string 
	for (i = 0; s[i] != '\0'; i++) 
	{ 
		if (strstr(&s[i], oldW) == &s[i]) 
		{ 
			cnt++; 

			// Jumping to index after the old word. 
			i += oldWlen - 1; 
		} 
	} 

	// Making new string of enough length 
	result = (char *)malloc(i + cnt * (newWlen - oldWlen) + 1); 

	i = 0; 
	while (*s) 
	{ 
		// compare the substring with the result 
		if (strstr(s, oldW) == s) 
		{ 
			strcpy(&result[i], newW); 
			i += newWlen; 
			s += oldWlen; 
		} 
		else
			result[i++] = *s++; 
	} 

	result[i] = '\0'; 
	return result; 
} 