#ifndef __Comentarios_H__

typedef struct nivel *Nivel;

typedef struct comentario *Comentario;

Nivel testeInit();

Nivel createNivel(Nivel ant);

void addComment(Nivel atual);

Nivel addNivelToComment(Nivel atual);

Nivel getAnt(Nivel atual);

long numberOfReplies(Nivel n);

long replies(Comentario c);

#endif