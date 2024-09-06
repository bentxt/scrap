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

