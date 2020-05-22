#include "html.h"


char* constroi_paginicial(char* informacao){

	char* result;

	asprintf(&result,"<h1 style=\"color:white;\">\"%s\"</h1>\n",informacao);


	return result;
}


char* constroi_pagcreditos(char * informacao){
	
	char* result;
	asprintf(&result,"<center><h1 style=\"color:white;\">Créditos</h1>\n <p>\"%s\"</p>\n</center>",informacao);
	return result;
}

void constroi_pagina(char* informacao, int i){
	char str[150];

	sprintf(str, "html/%d.html", i);

	FILE* fich = fopen(str,"w+");

	fprintf(fich,"<!doctype html>\n");
	fprintf(fich,"<html lang='en'>");
	fprintf(fich,"<head>\n");
	fprintf(fich,"\t<meta charset='utf-8'>\n");
	fprintf(fich,"<style>.bottomright {position: absolute;bottom: 8px;right: 16px;font-size: 18px;}.parent {text-align: center;}.parent > ul {display: inline-block;}</style>\n");
	
	fprintf(fich,"\t<title>PL TP3</title>\n");
	fprintf(fich,"</head>\n");
	fprintf(fich,"<body style = \"background-color:coral;\">\n");
	fprintf(fich, "<center><p>%s</center></p>", informacao);
	fprintf(fich, "<div class=\"container\"><div class=\"bottomright\">%d</div></div>", i+1);
	fprintf(fich,"</body>\n");
	fprintf(fich,"</html>\n");

	fclose(fich);
}

