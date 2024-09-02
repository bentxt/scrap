#include <stdio.h>
#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include "basicmath.h"


// CAMLprim is not neccessary
//CAMLprim value caml_basicmath_plusone(value number_val){
int caml_basicmath_plusone(value number_val){
    int number = Int_val(number_val);
    printf("Stub arg: %i\n", number);
    int res = plusone(number);
    printf("Stub res: %i\n", res);
    return Val_int(res);
}


