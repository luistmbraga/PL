#ifndef __HASHTABLE_H__
#define __HASHTABLE_H__

#include "lan.h"


typedef struct hash *HashTable;

void HashTableN(HashTable *h, long n);

void HashTableS(HashTable *h);

void insertHashTable(HashTable *h, long id, LAN la);

LAN getLAN(HashTable h, long id);

void testa(HashTable *h);

long getSize(HashTable h);

int containsKey(HashTable h, long id);

void clearTable(HashTable h);


#endif