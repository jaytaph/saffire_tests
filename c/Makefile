all:
	lex -d c.l 
	bison -d -v c.y 
	gcc -g -c -o c.tab.o c.tab.c
	gcc -g -c -o lex.yy.o lex.yy.c
	gcc -g -c -o main.o main.c
	gcc -g -o main main.o c.tab.o lex.yy.o
