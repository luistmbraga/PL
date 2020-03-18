#include "lan.h"
#include <stdlib.h>
#include "string.h"

struct listlan{
		char* value;
		char* lang;
		struct listlan *prox;
};


LAN insertList(LAN l, char* va, char* la){
	LAN aux = l;
	LAN nova = malloc(sizeof(struct listlan));
	nova->value = strdup(va);
	nova->lang = la;
	nova->prox = NULL;
	if(aux == NULL) {return nova;}
	while(aux->prox!=NULL){
		aux = aux->prox;
	}
	aux->prox = nova;
	return l;
}

char* getValue(LAN l){
	return l->value;
}

char* getLang(LAN l){
	return l->lang;
}

LAN avancaL(LAN l){
	return l->prox;
}