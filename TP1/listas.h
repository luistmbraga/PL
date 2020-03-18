typedef struct nivel {
    struct nivel *ant;
    struct comentario *replies;
} *Nivel;

typedef struct comentario {
    struct comentario *prox;
    struct nivel *replies;
} *Comentario;

