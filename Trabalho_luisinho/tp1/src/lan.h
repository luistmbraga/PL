#ifndef __LAN_H__
#define __LAN_H__

typedef struct listlan *LAN;

LAN insertList(LAN l, char* va, char* la);

char* getValue(LAN l);

char* getLang(LAN l);

LAN avancaL(LAN l);

#endif