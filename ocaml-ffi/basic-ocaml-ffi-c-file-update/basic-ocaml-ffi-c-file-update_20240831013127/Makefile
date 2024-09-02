.PHONY: all clean 

all: main
	./main

main:
	gcc -c basicmath.c
	ocamlc -c stubs_basicmath.c
	ocamlopt -o main basicmath.o stubs_basicmath.c main.ml 


clean:
	rm -f main
	rm -f *.o
	rm -f *.cm*
	rm -f *.a
	rm -f *.dylib
	

