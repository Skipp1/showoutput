CC=gcc
LEX=flex  
YACC=bison

CFLAGS=-Ofast -march=native -mtune=native -flto -Wall -Wextra 
LINK=-lfl -w

SRC=y.tab.c lex.yy.c

showoutput: ${SRC}
	${CC} ${LINK} ${CFLAGS} $^ -o $@

lex.yy.c: showoutput.l
	${LEX} $<

y.tab.c: showoutput.y
	${YACC} -dyv $<
	
