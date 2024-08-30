.PHONY: all clean 

all: main
	./main

main:
	c3c compile-only -O1 -o c3math c3math.c3 --single-module=yes
	gcc -o main c3math.o main.c


clean:
	rm -f main
	rm -f *.o
	rm -f *.out
	rm -f *.a
	rm -f *.dylib
	

