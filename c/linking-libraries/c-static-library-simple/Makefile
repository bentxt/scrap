.PHONY: all clean


all:
	# Compile the source file into an object file
	gcc -c greetings.c -o greetings.o
	# Create the Static Library
	# Use the ar (archiver) command to create the static library (.a file).
	ar rcs libgreetings.a greetings.o
	# -l adds "lib..." and "...a"
	# -L add the path of the library dir
	gcc main.c -L. -lgreetings -o main
	./main



clean:
	rm -f main
	rm -f *.o
	rm -f *.a
