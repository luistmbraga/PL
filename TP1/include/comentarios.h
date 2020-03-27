#ifndef __Comentarios_H__

typedef struct nivel *Nivel;

typedef struct comentario *Comentario;

Nivel createNivel(Nivel ant);

void addComment(Nivel atual);

Nivel addNivelToComment(Nivel atual);

Nivel getAnt(Nivel atual);

long depthOfNivel(Nivel n);

long numberOfReplies(Nivel n);

long replies(Comentario c);

void freeAll(Nivel n);

void freeC(Comentario c);

#endif