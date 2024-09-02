.PHONY: clean all all2


simplemath/simplemath.o:
	make -C simplemath

main.o:
	gcc -c main.c # generates the object file main.o


main: main.o func.o
	gcc func.o main.o -o main # generates the executable main

main2: func.o
	gcc func.o -o main2 main.c

all: main
	./main

all2: main2
	./main2


clean:
	make -C simplemath clean
	rm -f main
	rm -f *.o
	


