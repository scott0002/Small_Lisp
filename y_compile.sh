bison -d -o y.tab.c final_adv.y
gcc -c -g -I.. y.tab.c	
flex -o lex.yy.c final_adv.l
gcc -c -g -I.. lex.yy.c
gcc -o ex1 y.tab.o lex.yy.o -ll
./ex1

