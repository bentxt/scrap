.PHONY: all clean 

all: main
	./main

main:
	c3c compile-only -O1 -o c3math c3math.c3 --single-module=yes
	ocamlc -c stubs_c3math.c
	ocamlopt -o main c3math.o stubs_c3math.c main.ml 


clean:
	rm -f main
	rm -f *.o
	rm -f *.cm*
	rm -f *.a
	rm -f *.dylib
	

