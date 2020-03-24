#include "comentarios.h"
#include <stdlib.h>


struct nivel {
    struct nivel *ant;
    struct comentario *replies;
};

struct comentario {
    struct comentario *prox;
    struct nivel *replies;
};

Nivel createNivel(Nivel ant){
    Nivel r = (Nivel) malloc(sizeof(struct nivel));
    r->ant = ant;
    r->replies = NULL;

    return r;
}

void addComment(Nivel atual){
    Comentario c = (Comentario) malloc(sizeof(struct comentario));
    c->replies = NULL;
    c->prox = atual->replies;
    atual->replies = c;
}

Nivel addNivelToComment(Nivel atual){
    Nivel r = createNivel(atual);
    atual->replies->replies = r;

    return r;
}

Nivel getAnt(Nivel atual){
    return atual->ant;
}

long depths(Comentario c){
    long depth = 0;
    long temp = 0;
    while(c){
        temp = depthOfNivel(c->replies);
        depth = (temp > depth) ? temp : depth;
        c = c->prox;
    }
    return depth;
}

long depthOfNivel(Nivel n){
    long depth = 0;
    if(n){
        depth = depths(n->replies);
        depth++;
    }
    return depth;
}

long repliesC(Comentario c){
    long replies = 0;
    while(c){
        ++replies;
        replies += numberOfReplies(c->replies);
        c = c->prox;
    }
    return replies;
}

long numberOfReplies(Nivel n){
    long replies = 0;
    if(n){
        replies = repliesC(n->replies);
    }
    return replies;
}

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

