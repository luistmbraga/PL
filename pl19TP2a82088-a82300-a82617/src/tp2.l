%{
#include "y.tab.h"
#include <ctype.h>
#include <stdio.h>

void strip_linebreak(char* str);
void strip_extra_spaces(char* str);
void push(char);
int pop();
int find_top();
int checkParentesis(char * a);
void initParentesis();
void initStack();

int top = -1;
char stack[100];
int beginread = 0;
int parentesisok = 1;
int skipline = 0;
int skipcomposto = 0;
char parentesis[500];
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

(__BEGIN__)(\r\n)+       { beginread = 1; }               

[A-Za-z]\ *[\r\n]+    { 
						if(beginread){
							if(parentesisok){
								yylval.cvalue = *yytext; 
								return CHAR; 
							}
						}
					  }

[\r\n] ;

[:]         { 
				if(beginread && parentesisok){
                    skipcomposto = 1;
					return *yytext;
				} 
			} 

^{palavras}[\r\n]+\ {1,2}{palavras}{palavrasinc} { if(beginread) skipline = 1;   }

{palavras}\-/[\r\n]+\ {1,4}{palavrasinc}   {
												if(beginread){
													if(parentesisok){ 
														if(!skipline){
															skipline = 1;
															yylval.svalue = strdup(yytext); 
															return PALAVRAS;
														}
													} 
												}
										   }

^{palavras}([\r\n]+\ {1,2}{palavras})* { 
										if(beginread){
											if(parentesisok){
												if(checkParentesis(yytext) ){ 
													strip_linebreak(yytext); 
													strip_extra_spaces(yytext);
													yylval.svalue = strdup(yytext); 
													skipcomposto = 0;
													skipline = 0;
													return PALAVRAS; 
												}
												else{
													strncpy(parentesis, yytext, yyleng);
													printf("%s\n", parentesis);
												}
											}
											else{
												strncat(parentesis, yytext, yyleng);
												printf("%s ", parentesis);
												printf("valor check: %d\n", checkParentesis(parentesis));
											}

										}
									  }

^{palavras}\:(\r\n)+/{palavras}  ;

^\ {1,2}{palavras}\:(\ +{palavras}\ +{palavras})?(\r\n)+/\ {1,4}{palavrasinc}  ;

^{palavras}\:{palavras}\ +{palavras}[\r\n]+/{palavras}  ;

{palavras} { 
				if(beginread){
					if(parentesisok){ 
						if(!skipline){
							skipline = 1;
							yylval.svalue = strdup(yytext); 
							return PALAVRAS;
						}
					} 
				}
			}

{palavras}([\r\n]+[\ \t]{8,}{palavras})+  { 
											if(beginread){
												if(parentesisok){ 
													if(!skipline){
														skipline = 1;
														strip_linebreak(yytext); 
														strip_extra_spaces(yytext); 
														yylval.svalue = strdup(yytext); return PALAVRAS; 
													}
												} 
											}
									
										  }


^\ {1,4}{palavrasinc}([\r\n]+\ {1,4}{palavrasinc})*  { 
															if(beginread){
																if(parentesisok){
																	if(skipcomposto){ 
																		skipline = 0;
																		yylval.svalue = strdup(yytext); 
																		return PALAVRASINC; 
																	}
																	else
																		skipline = 1;
																}
															}
														}

{palavrasinc}                   {
									if(beginread && parentesisok){
										skipline = 1;
									}
								}

^\ {1,4}{palavrasinc}[\r\n]+/{palavras}    ;

\ {palavras}[\r\n]+       ;

^{palavras}(\r\n)+     ;


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

void initParentesis(){
	for(int j = 0; j < 500; j++)
		parentesis[j] = 0;
}

void initStack(){
	for(int j = 0; j < 100; j++)
		stack[j] = 0;
}

int checkParentesis(char * a){

	initStack();

    int i;

    int result = 1;
    
	for (i = 0; a[i] != '\0';i++)
	{
		if (a[i] == '(')
		{
			push(a[i]);
		}
		else if (a[i] == ')')
		{
			result = pop();
		}
	}
    if(result)
	    result = find_top();
	
	result = 1;

	parentesisok = result;

	if(result) initParentesis();

	top = -1;

	return result;
}

// to push elements in stack

void push(char a)

{

	stack[top] = a;

	top++;

}

 

// to pop elements from stack

int pop(){
	if (top == -1)
	{
		return 0;
	}	
	else
	{		
		top--;
	}
}

 

// to find top element of stack

int find_top(){
	if (top == -1){
		return 1;
	}
	else{
		return 0;
	}
}