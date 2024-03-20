%{
    #include <stdio.h>
    #include <string.h>
    void yyerror(const char *s);
    int yylex();
    int yywrap();
    typedef union {
        int ival;
        unsigned int uival;
        char *str;
    } node_content_t;

    typedef enum {
        INT, UINTEGER, STRING,
    } node_content_e;

    typedef struct node node_t;

    struct node {
        node_content_t val;
        node_content_e type;
        size_t n;
        node_t *a;
        node_t *b;
    };


    node_t *node(node_content_t val, node_content_e type);
    void add_child(node_t *parent, node_t *child);
    void print_node(node_t *n, size_t indent);

%}


%union {
    struct node *node;
    int ival;
    char * string;
}


%token LBRA RBRA UNION INTERSECT NOT ADD TO SET
%token <ival> LETTER INTEGER INDEX
%token <string> BINARY
%type <node> expr term fact

%%

line : /* empty */
     | line expr '\n'
                        {print_node($2, 0);}
     ;

expr : expr UNION term
                        { node_t *n = node((node_content_t) "unione", STRING);
                          add_child(n, $1);
                          add_child(n, $3);
                          $$ = n; }
     | expr INTERSECT term
                        { node_t *n = node((node_content_t) "intersezione", STRING);
                          add_child(n, $1);
                          add_child(n, $3);
                          $$ = n; }
     | term
                        { $$ = $1; }
     ;

term : NOT fact 
                    { node_t *n = node((node_content_t) "n", STRING);
                      add_child(n, $2);
                      $$ = n; 
                    }
        | fact{ $$ = $1; }
     ;

fact : LBRA expr RBRA
                        { $$ = $2; }
     | LETTER
                        { $$ = node((node_content_t) ($1), UINTEGER);}
     | ADD INDEX INTEGER TO 's' LETTER
                        {node_t *n = node((node_content_t) "Aggiungi", STRING);
                          node_t *c1 = node((node_content_t) ($3), INT);
                          node_t *c2 = node((node_content_t) ($6), UINTEGER);
                          add_child(n, c1);
                          add_child(n, c2);
                          $$ = n; 
                        }
    | BINARY {node_t *n = node((node_content_t) $1, STRING);
              $$ = n;
            }

     ;

%%

node_t *node(node_content_t val, node_content_e type) {
    node_t *n = malloc(sizeof(node_t));
    n->type = type;
    
    if (type == STRING){
        n->val = (node_content_t) strdup(val.str);
    }    
    else{
        n->val = val;
        
    }
    n->n = 0;
    n->a = NULL;
    n->b = NULL;
    return n;
}

void add_child(node_t *parent, node_t *child) {
    if (parent->n == 0) {
        parent->a = child;
        parent->n = parent->n + 1;
    } else if (parent->n == 1) {
        parent->b = child;
        parent->n = parent->n + 1;
    } else {
        yyerror("Can't add a child: node already full of children.\n");
    }
}

void print_node(node_t *n, size_t indent) {
    char *indentation = malloc(sizeof(char) * indent);
    for (size_t i = 0; i < indent; ++i) {
        indentation[i] = ' ';
    }
    switch (n->type) {
        case STRING: 
            printf("%s%s\n", indentation, n->val.str); 
        break;
        case UINTEGER: 
            printf("%s%c\n", indentation, n->val.uival + 'A'); 
        break;
        case INT:
            printf("%s%i\n", indentation, n->val.ival);

    }
    if (n->a)
        print_node(n->a, indent+3);
    if (n->b)
        print_node(n->b, indent+3);
}


int yywrap() {
    return -1;
}

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
     yyparse();
}
