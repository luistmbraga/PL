#include <stdlib.h>
#include <stdio.h>
#include "HashTable.h"

struct hash{
	LAN *l;								// a hash para os termos
	long size;							// o tamanho da respetiva hash
};


void HashTableN(HashTable *h, long n){

	*h = malloc(sizeof(struct hash));

	long s = (*h)->size = n + n/6 + 250;     // se o utilzador só quiser 5 tuplos, haveria problemas por começarem os id's me 200 e tal, portanto, usa-se o o '+250' por proteção

	(*h)->l = malloc(s*sizeof(LAN));		  // alocamento de memória para a hash

	for(long i = 0; i < s; i++){		  // inicializa a hashTable
		(*h)->l[i] = NULL;
	}

}

void HashTableS(HashTable *h){
	HashTableN(h, 1000000);				// se não for especificado o tamanho 
}

void insertHashTable(HashTable *h, long id, LAN la){
	long s= (*h)->size;

	if(id >= s){
		long new_size = s*2;
		printf("HeashTable realloc \n");
		(*h)->l = realloc((*h)->l, sizeof(LAN)*new_size);
		for(long i = s; i<new_size; i++){
			(*h)->l[i] = NULL;
		}
		(*h)->size = new_size;
		insertHashTable(h, id, la);
		return;
	}

	(*h)->l[id] = la;
}

LAN getLAN(HashTable h, long id){
	LAN r = NULL;

	if (containsKey(h, id)){
		r = h->l[id];
	}

	return r;
}

long getSize(HashTable h){
	return h->size;
}

int containsKey(HashTable h, long id){
	if(id < h->size){
		return (h->l[id] != NULL);
	}

	return 0;
}


void clearTable(HashTable h){
	long s = h->size;
	for(long i = 0; i < s; i++){
		free(h->l[i]);
	}
	free(h);
}