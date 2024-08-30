.PHONY: all clean

all: main
	./main

main:
	ocamlopt -c hello_stubs.c
	ocamlopt -o main main.ml hello_stubs.o

clean:
	rm -f main
	rm -f *.o
	rm -f *.cm*

