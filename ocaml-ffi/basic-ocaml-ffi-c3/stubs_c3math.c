#include <stdio.h>
#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/memory.h>

extern int square(int);


//CAMLprim value caml_square(value number_val){
//
int caml_square(value number_val){
    int number = Int_val(number_val);
    printf("Stub arg: %i\n", number);
    int res = square(number);
    printf("Stub res: %i\n", res);
    return Val_int(res);
}

