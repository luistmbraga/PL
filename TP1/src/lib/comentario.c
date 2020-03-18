#include "nivel.h"
#include "comentario.h"

struct comentario {
    struct comentario *prox;
    struct nivel *replies;
};