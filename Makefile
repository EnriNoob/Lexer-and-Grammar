first: yacc1 lexer1
	gcc y.tab.c lex.yy.c -ll -lm

yacc1: grammar.y
	yacc -d grammar.y

lexer1: lexer.l
	lex lexer.l

second: yacc2 lexer2
	gcc y.tab.c lex.yy.c -ll

yacc2: ast.y
	yacc -d ast.y
lexer2: lexer.l
	lex lexer.l
 
clean:
	rm -rf y.tab.c y.tab.h lex.yy.c a.out

