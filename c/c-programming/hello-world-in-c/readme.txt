# Hello World in C

## A minimal C Program

``` { .c 
#include <stdio.h>
main() {
    puts("Hello, World!");
}
```

This very minimal Hello World can be compiled with gcc smaller than version 14.
Yes it yields an error because the missing return type for `main`, but it
compiles. 

After version gcc-14 you have to explicitly define the return type as `int` or
an error is thrown like so:

```
    gcc-14 hello.c
    base.c:3:1: error: return type defaults to 'int' [-Wimplicit-int]
        3 | main() {
          | ^~~~
```

## A modern, valid Hello World


```
1. #include <stdio.h>
2. int main() {
3.    puts("Hello, World!");
4.    return 0;
   }
```

Explanations

    1. An `include` mechanism 
        if there are external libraries are needed

    2. An `main` function as entry point
        older C compiler where OK with return type 'void'

    3. A simple function like `puts` that does something, 
        `puts` is defined in the included `<stdio.h>` library

    4. A return function that satisfies the function type for `main`
        also older C compilers did not need that
        



#include <stdio.h>

void print_name(char *name) {
    while (*name) {
        putchar(*name++);
    }
}

int main(int argc, char **argv) {

    int i;
    for (i = 1; i < argc; i++){
        printf("%s ", "Hello");
        print_name(argv[i]);
        printf("\n");
    }

    return(0);
}





hello.c:3:1: warning: return type of 'main' is not 'int' [-Wmain-return-type]
void main() {
^
hello.c:3:1: note: change return type to 'int'
void main() {
^~~~
int
1 warning generated.
#include <stdio.h>
