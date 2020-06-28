%{
#include "y.tab.h"
#include <ctype.h>
#include <stdio.h>
#include <time.h> 

void strip_linebreak(char* str);
void strip_extra_spaces(char* str);
void createLogFile();
void printError(int cod);

int beginread = 0;
int skipline = 0;
int zonacomplexa = 0;

FILE *exceptions;
%}

%option yylineno

acentos    \xc3[\x80-\xbf]
hifen1     {letra}\-(\ )?({letra}|[\r\n]+)
hifen2     {letra}(\ )?\-{letra}
aspas1     \"[^\"]+\"
letra      [a-zA-Z\(\)\+\/'0-9,;\.\_]|{acentos}
letras     {letra}|{hifen1}|{hifen2}|{aspas1}
palavras   {letras}{1,}(\ {letras}{1,})*
palavrasinc ((\ {0,1}{letras}{1,})|(\ {0,2}(\-(\ {0,1}))))*

%%

(__BEGIN__)[\r\n]+       { beginread = 1; createLogFile(); return PALAVRAS;}               

[A-Za-z]\ *[\r\n]+    { 
						if(beginread){
							yylval.cvalue = *yytext; 
							return CHAR; 
						}
					  }

[\r\n] ;

[:]         { 
				if(beginread){
                    zonacomplexa = 1;
					return *yytext;
				} 
			} 

^{palavras}[\r\n]+\ {1,2}{palavras}{palavrasinc} { if(beginread){ skipline = 1; printError(1); }  }       

{palavras}\-/[\r\n]+\ {1,4}{palavrasinc}   {
												if(beginread){
													if(!skipline){
														skipline = 1;
														yylval.svalue = strdup(yytext); 
														return PALAVRAS;
													}
													else printError(2);
												}
										   }

^{palavras}([\r\n]+\ {1,2}{palavras})* { 
										if(beginread){
											strip_linebreak(yytext); 
											strip_extra_spaces(yytext);
											yylval.svalue = strdup(yytext); 
											zonacomplexa = 0;
											skipline = 0;
											return PALAVRAS; 	
										}
									  }

^{palavras}\:[\r\n]+/{palavras}  {
									if(beginread){
										printError(3);
									}
                                 }

^\ {1,2}{palavras}\:(\ +{palavras}\ +{palavras})?[\r\n]+/\ {1,4}{palavrasinc}  {
																					if(beginread) 
																						printError(4);
																				}

^{palavras}\:{palavras}\ +{palavras}[\r\n]+/{palavras} 	{
															if(beginread) 
																printError(5);
														}

{palavras} { 
				if(beginread){
					if(!skipline){
						skipline = 1;
						yylval.svalue = strdup(yytext); 
						return PALAVRAS;
					}
					else printError(2); 
				}
			}

{palavras}([\r\n]+[\ \t]{8,}{palavras})+  { 
											if(beginread){
												if(!skipline){
													skipline = 1;
													strip_linebreak(yytext); 
													strip_extra_spaces(yytext); 
													yylval.svalue = strdup(yytext); return PALAVRAS; 
												}
												else printError(2);  
											}
									
										  }


^\ {1,4}{palavrasinc}([\r\n]+\ {1,4}{palavrasinc})* { 
														if(beginread){
															if(zonacomplexa){ 
																skipline = 0;
																strip_linebreak(yytext);
																yylval.svalue = strdup(yytext); 
																return PALAVRASINC; 
															}
															else{
																printError(9);   
																skipline = 1;
															}
														}
													}

{palavrasinc}                   {
									if(beginread){
										skipline = 1;
										printError(6);
									}
								}

^\ {1,4}{palavrasinc}[\r\n]+/{palavras}    	{
												if(beginread) 
													printError(7);
											}



^{palavras}[\r\n]+     	{
							if(beginread) 
								printError(8);
						}


\ + ;


.   { if(beginread){  return ERRO; } }

%%

void printError(int cod){
	fprintf(exceptions, "{ERRO NA LINHA:%d\n", yylineno);
	fprintf(exceptions, "COM O TEXTO:%s\n", yytext);
	fprintf(exceptions, "CODIGO DE ERRO:%d}\n\n", cod);
}

void strip_linebreak(char* str) {
    int i;
    for(i=0; str[i]; ++i)
        if(i > 0 && str[i] == '\n' && str[i-1] == '\r'){
            str[i] = ' ';
            str[i-1] = ' ';
        }
        else if(str[i] == '\n')
            	str[i] = ' ';
}

void strip_extra_spaces(char* str) {
  int i, x;
  for(i=x=0; str[i]; ++i)
    if(!isspace(str[i]) || (i > 0 && !isspace(str[i-1]))      )
      str[x++] = str[i];
  str[x] = '\0';
}


void createLogFile(){

	time_t t = time(NULL);
	struct tm tm = *localtime(&t);
	char nomeFich[100];
	sprintf(nomeFich,"%d-%d-%dT%d_%d_%d", tm.tm_year + 1900, tm.tm_mon +1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);

	char* file = malloc(50);

	strcpy(file, "../errorLogs/");
	strcat(file, "ERRORLOG_");
	strcat(file, nomeFich);
	strcat(file, ".txt");

	exceptions = fopen(file, "w");
}