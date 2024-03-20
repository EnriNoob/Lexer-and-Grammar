%{
    #include <ctype.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>
    int yylex();
    int yyparse();
    void yyerror(char const* s);
    // ci sono 26 lettere nell'alfabeto italiano
    unsigned int regs[26] = {0};
    
    // funzione per convertire un binario in valore decimale 
    // salvato in un unsigned int 
    unsigned int retrieve_uivalue(char *myString){

        int i = strlen(myString) - 1;
        int pot = 0;
        unsigned int res = 0;
        for(; i >= 0 ; i--){
            if (myString[i] == '1'){
                res = res + (pow(2,pot));
                pot++;
            }
            else{
                pot++;
            }
        }
        return res;

    }
    // funzione che salva nell'array regs il binario inserito nella corrispettiva lettera
    void store(char *myString,int letter){
        unsigned int res = 0;
        res = retrieve_uivalue(myString);
        printf("%d\n", res);
        regs[letter] = res;
    }
    // funzione che mi converte il value_of_set nel corrispettivo valore in binario 
    char* retrieve_binary(unsigned int value_of_set){

        int temp[32];
        int cont = 0;
        int storenumber = value_of_set;
        while(cont < 32){
            temp[cont] = (value_of_set % 2);
            value_of_set = value_of_set / 2;
            cont++;
        }
        printf("cont: %d\n", cont);
        int i = 0;
        // abbiamo bisogno di 33 spazi nella stringa res (quindi una stringa lunga 33)
        // 32 per i bit e 1 per il '\0'
        // dobbiamo mettere '\0' nella posizione res[32] (ultima indice dell'array)
        // e guarda caso cont dopo il while è 32 piccolo pagliaccio che non sono altro
        char *res = (char*) malloc((cont + 1) *sizeof(char));
        res[cont] = '\0';
        int j = 0;
        for (i = cont - 1; i >= 0 ; i--){
            res[j] = temp[i] + '0';
            j++;
            
        }
        return res;
    }
    // funzione che implementa "add ix to sY"
    void modifySet(int index, char* myString, int letter){
        if(myString[(strlen(myString) - 1) - index] == '0'){
            myString[(strlen(myString) - 1) - index] = '1';
        }
        store(myString,letter);
    }
    // funzione che fa l'unione di due set 
    char* unioN(char *myString1, char *myString2){
        unsigned int set1 = retrieve_uivalue(myString1);
        unsigned int set2 = retrieve_uivalue(myString2);
        
        unsigned int res = set1 | set2;
        return retrieve_binary(res);

    }
    // funzione che fa l'intersezione di due set
    char * Intersect(char *myString1, char *myString2){
        unsigned int set1 = retrieve_uivalue(myString1);
        unsigned int set2 = retrieve_uivalue(myString2);
        
        unsigned int res = set1 & set2;
        return retrieve_binary(res);
    }
    // funzione che fa la negazione di un set
    char* Negate(char *myString){
        unsigned int res = ~(retrieve_uivalue(myString));
        return retrieve_binary(res);   
    }
%}

%union {
    char* string;
    int ival;
}

%token LBRA RBRA UNION INTERSECT NOT ADD TO
%token <ival> LETTER INTEGER INDEX
%token <string> BINARY   
%type <string>  factor term expr 
%%
lines:lines line
	 |line

;

line: expr'\n' {printf("= %s\n", $1);}
    | LETTER '=' BINARY'\n'{
        store($3,$1);
        printf("%s\n", $3);
        }
;

expr : expr UNION term 
                        { $$ = unioN($1,$3);}
        |expr INTERSECT term   
                        { $$ = Intersect($1,$3);}
        |term { $$ = $1;}
;

term : NOT factor {$$ = Negate($2);}
        |factor {$$ = $1;}
;

factor :LBRA expr RBRA {$$ = $2;}
        |LETTER {$$ = retrieve_binary(regs[$1]);}
        |ADD INDEX INTEGER TO 's' LETTER{
            modifySet($3,retrieve_binary(regs[$6]),$6);
            $$ = retrieve_binary(regs[$6]);
        
        }
        |BINARY{$$ = retrieve_binary(retrieve_uivalue($1));}
;
%%
int main(void){
    yyparse();
    return 0;
}
void yyerror(char const*s) {
  fprintf(stderr,"%s\n",s);
}