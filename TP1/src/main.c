/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "comentarios.h"

int LOOP =  0;
/*
1.
    1.
    2.
        1.
        2.
    3.
        1.
        2.
            1.
            2.


long numberOfRepliesV1(Nivel n);

long repliesV2(Comentario c){
    long replies = 0;
    while(c){
        ++replies;
        c = c->prox;
    }
    return replies;
}

long numberOfRepliesV2(Nivel n){
    long replies = 0;
    if(n){
        replies = repliesV2(n->replies);
    }
    return replies;
}

void freeNivel(Nivel n){
    if(n){
        Comentario *c;
        while(n->replies){
            c = &(n->replies->prox);
            free(n->replies);
            n->replies = *c;
        }
        free(n);
    }
    
}

void freeAll(Nivel n){
    if(n){
        int l = ++LOOP;
        printf("LOOP: %d", l);
        Comentario *c;
        while(n->replies){
            freeAll(n->replies->replies);
            c = &(n->replies->prox);
            free(n->replies);
            n->replies = *c;
        }
        free(n);
    }
    
}*/

int main()
{
    
    Nivel r = testeInit();
    
    printf("Número total de filhos de forma acumulativa: %ld\n", numberOfRepliesV1(r));
    
    return 0;
}
