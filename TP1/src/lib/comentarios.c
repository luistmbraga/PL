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

void freeC(Comentario c){
    Comentario c1;
    while(c){
        c1 = c->prox;
        freeAll(c->replies);
        free(c);
        c = c1;
    }
}

void freeAll(Nivel n){
    if(n){
        if(n->replies)
            freeC(n->replies);
        free(n);
    }
}
