%{
    #include <stdio.h>
    #include "y.tab.h"
    int c; 
%}
%%
[A-Z] {c = yytext[0]; yylval.ival = c - 'A'; return LETTER;}
s[0-1]{1,32} {yylval.string = strdup(yytext) ;return BINARY;}
(?:[0-9]|[1-2][0-9]|3[0-1]) {yylval.ival = atoi(yytext); return INTEGER;}

"(" {return LBRA;}
")" {return RBRA;}
u {return UNION;}
r {return INTERSECT;}
n {return NOT;}
i {return INDEX;}
add {return ADD;}
to {return TO;}

[ \t\r]
\n   {return '\n';}
.   {return yytext[0];}

