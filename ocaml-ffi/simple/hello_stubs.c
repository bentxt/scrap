#include<stdio.h>
#include<caml/mlvalues.h>
#include "hellolib.h"
CAMLprim value caml_print_hello()
{
    sayhello();
    return Val_unit;
}
