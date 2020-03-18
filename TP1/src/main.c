/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "lista.h"
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
*/

long numberOfRepliesV1(Nivel n);

Nivel testeInit(){
    // inicializar 1º nivel
    Nivel n1 = (Nivel) malloc(sizeof(struct nivel));
    n1->ant = NULL;
    n1->replies = NULL;
    
    // adicionar o 1º comentario
    Comentario c1 = (Comentario) malloc(sizeof(struct comentario));
    c1->replies = NULL;
    c1->prox = n1->replies;
    n1->replies = c1;
    
    // adicionar o 2º comentario (à cabeça)
    Comentario c2 = (Comentario) malloc(sizeof(struct comentario));
    c2->replies = NULL;
    c2->prox = n1->replies;
    n1->replies = c2;
    
        // inicializar 2º nivel
        Nivel n11 = (Nivel) malloc(sizeof(struct nivel));
        n11->ant = n1;
        n11->replies = NULL;
        
        c2->replies = n11;
        
        // adiciona o 1º comentario
        Comentario c111 = (Comentario) malloc(sizeof(struct comentario));
        c111->replies = NULL;
        c111->prox = n11->replies;
        n11->replies = c111;
    
        // adiciona o 2º comentario
        Comentario c112 = (Comentario) malloc(sizeof(struct comentario));
        c112->replies = NULL;
        c112->prox = n11->replies;
        n11->replies = c112;
        
    // adicionar o 3º comentario (à cabeça)
    Comentario c3 = (Comentario) malloc(sizeof(struct comentario));
    c3->replies = NULL;
    c3->prox = n1->replies;
    n1->replies = c3;
    
        // inicializar 2º nivel
        Nivel n12 = (Nivel) malloc(sizeof(struct nivel));
        n12->ant = n1;
        n12->replies = NULL;
        
        c3->replies = n12;
        
        // adiciona o 1º comentario
        Comentario c121 = (Comentario) malloc(sizeof(struct comentario));
        c121->replies = NULL;
        c121->prox = n12->replies;
        n12->replies = c121;
    
        // adiciona o 2º comentario
        Comentario c122 = (Comentario) malloc(sizeof(struct comentario));
        c122->replies = NULL;
        c122->prox = n12->replies;
        n12->replies = c122;
            
            // inicializar 3º nivel
            Nivel n121 = (Nivel) malloc(sizeof(struct nivel));
            n121->ant = n12;
            n121->replies = NULL;
            
            c122->replies = n121;
            
            // adiciona o 1º comentario
            Comentario c1211 = (Comentario) malloc(sizeof(struct comentario));
            c1211->replies = NULL;
            c1211->prox = n121->replies;
            n121->replies = c1211;
        
            // adiciona o 2º comentario
            Comentario c1212 = (Comentario) malloc(sizeof(struct comentario));
            c1212->replies = NULL;
            c1212->prox = n121->replies;
            n121->replies = c1212;
    
    return n1;
}



long repliesV1(Comentario c){
    long replies = 0;
    while(c){
        ++replies;
        replies += numberOfRepliesV1(c->replies);
        c = c->prox;
    }
    return replies;
}

long numberOfRepliesV1(Nivel n){
    long replies = 0;
    if(n){
        replies = repliesV1(n->replies);
    }
    return replies;
}

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
    
}

int main()
{
    
    Nivel r = testeInit();
    
    printf("Número total de filhos de forma acumulativa: %ld\n", numberOfRepliesV1(r));
    
    printf("Número total de filhos directos: %ld\n", numberOfRepliesV2(r));
    
    // freeNivel(r);

    // freeAll(r);

    printf("Número total de filhos de forma acumulativa: %ld\n", numberOfRepliesV1(r));
    
    printf("Número total de filhos directos: %ld\n", numberOfRepliesV2(r));

    
    return 0;
}
