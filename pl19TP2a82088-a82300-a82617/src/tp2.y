%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h> 
#include <unistd.h>

extern int yylex();
extern int yylineno;
extern char* yytext;
extern int yy_flex_debug;
extern FILE *yyin;

void yyerror();
void erroSem(char*);
void printTradSimples(char* sig);
void splitSignificado(char* sig, char* simb);
int findSep(char * sig, char sep);
char *replaceWord(const char *s, const char *oldW, 
								const char *newW);
void printTradIncompleto(char* orig, char* sig);
void help();

char* originalstr;
FILE *yyout;
%}

%union{
    char* svalue;
    char cvalue;
}

%token ERRO
%token <svalue> PALAVRAS
%token <svalue> PALAVRASINC
%token <cvalue> CHAR
%type <svalue> Original
%type <svalue> Significado
%type <svalue> OriginalIncompleto
%type <cvalue> Letra
%%

DicFinance
    : Capitulos
    ;

Capitulos
    : Capitulos Capitulo
    |
    ;

Capitulo
    : Letra { fprintf(yyout, "%c\n\n", $1); } Traducoes
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
int main(int argc, char* argv[]){

    if(argc < 2){
		help();
		return 0;
	}
	
	if(access(argv[1], F_OK) != -1){

		if(access(argv[1], R_OK) != -1){

            int len = strlen(argv[1]);

			// definir nome do ficheiro final
			char* nome = (char *) malloc(9 + len + 1);
			
            strcpy(nome, argv[1]);
            nome[len-4] = '\0';

			strcat(nome, "Saida.txt");

            yyout = fopen(nome, "w");
			
			// abrir o ficheiro a ler
			yyin = fopen(argv[1], "r");

			clock_t start = clock();
            
			// inicializar a leitura
            //yy_flex_debug = 1;
            yyparse();

			fclose(yyin);
			fclose(yyout);
			
			
			clock_t end = clock(); 
			float seconds = (float)(end - start) / CLOCKS_PER_SEC; 
			printf("Programa demorou: %fs\n", seconds);
            free(nome);
		}
		else{
			printf("Não possui permissão de leitura sobre o ficheiro fornecido!\n");
		}
	}
	else{
		printf("O ficheiro dado como argumento não existe !\n");
	}

	return 0;
    
}


void help(){

	printf("\n");
	printf("****************************Reverse Engineering dum Dicionario Financeiro**************************\n");
	printf("**                                                                                               **\n");
	printf("**                                                                                               **\n");
	printf("***********************************************HELP************************************************\n");
	printf("**                                                                                               **\n");
	printf("**    Utilização:                                                                                **\n");
	printf("**                 1- make                                                                       **\n");
	printf("**                 2- ./tp2 [nome do ficheiro a processar]                                       **\n");
	printf("**                                                                                               **\n");
	printf("**    Notas:                                                                                     **\n");
	printf("**    O ficheiro resultante vai para a mesma pasta com o mesmo                                   **\n");
	printf("**       nome do original, apenas com a modificação de ter                                       **\n");
	printf("**       \"JSON.txt\" no final.                                                                **\n");
	printf("**                                                                                               **\n");
	printf("***********************************************HELP************************************************\n");

}


void yyerror(){
    printf("Erro Sintático ou Léxico na linha: %d, com o texto: %s\n", yylineno, yytext);
}

void printTradSimples(char* sig){
    fprintf(yyout, "EN %s\n", originalstr);

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

    fprintf(yyout, "EN %s\n", result);
    fprintf(yyout, "+base %s\n", originalstr);

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
      fprintf(yyout, "PT %s\n", token );
      token = strtok(NULL, simb);
   }
   fprintf(yyout, "%s", "\n");
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