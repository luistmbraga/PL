%{
#include <stdio.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char* yytext;
extern int yy_flex_debug;

void yyerror();
void erroSem(char*);
void printTradSimples(char* sig);
void splitSignificado(char* sig, char* simb);
int findSep(char * sig, char sep);
char *replaceWord(const char *s, const char *oldW, 
								const char *newW);
void printTradIncompleto(char* orig, char* sig);

char* originalstr;
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
    : Letra { printf("%c\n\n", $1); } Traducoes
    ;

Letra
    : CHAR { $$ = $1;}
    ;

Traducoes
    : Original { originalstr = strdup($1); } Traducao Traducoes 
    |
    ;

Traducao
    : TraducaoSimples
    | ':' TraducaoComplexa  
    ;

TraducaoSimples
    : Significado  { printTradSimples($1);  }
    ;

TraducaoComplexa
    : Significado TraducoesIncompletas
    | TraducoesIncompletas
    ;

TraducoesIncompletas
    : TraducoesIncompletas TraducaoIncompleta
    | TraducaoIncompleta
    ;

TraducaoIncompleta
    : OriginalIncompleto Significado  { printTradIncompleto($1, $2); }
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
}

void yyerror(){
    printf("Erro Sintático ou Léxico na linha: %d, com o texto: %s\n", yylineno, yytext);
}

void printTradSimples(char* sig){
    printf("EN %s\n", originalstr);

    if(findSep(sig, ','))
        splitSignificado(sig, ",");
    else
        splitSignificado(sig, ";");
}

void printTradIncompleto(char* orig, char* sig){
    
    char *result = NULL; 
    char *comespacos = (char *) malloc(2 + strlen(originalstr) + 1);

    strcpy(comespacos, " ");
    strcat(comespacos, originalstr);
    strcat(comespacos, " ");

    result = replaceWord(orig, " - ", comespacos);

    printf("EN %s\n", result);
    printf("+base %s\n", originalstr);

    free(result);
    free(comespacos);

    if(findSep(sig, ','))
        splitSignificado(sig, ",");
    else
        splitSignificado(sig, ";");
}

void splitSignificado(char* sig, char* simb){

   char * token = strtok(sig, simb);
   
   while( token != NULL ) {
      printf( "PT %s\n", token );
      token = strtok(NULL, simb);
   }
   printf("\n");
}

int findSep(char * sig, char sep){
    
    int result = 0;

    int len = strlen(sig);
    
    for(int i = 0; i < len && result!=1; i++)
        if(sig[i] == sep) result = 1;


    return result;
}



char *replaceWord(const char *s, const char *oldW, 
								const char *newW) 
{ 
	char *result; 
	int i, cnt = 0; 
	int newWlen = strlen(newW); 
	int oldWlen = strlen(oldW); 
 
	for (i = 0; s[i] != '\0'; i++) 
	{ 
		if (strstr(&s[i], oldW) == &s[i]) 
		{ 
			cnt++; 
 
			i += oldWlen - 1; 
		} 
	} 

	result = (char *)malloc(i + cnt * (newWlen - oldWlen) + 1); 

	i = 0; 
	while (*s) 
	{ 
        
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