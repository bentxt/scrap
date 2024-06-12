#include "prescheme.h"
#include "ps-init.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define long int

long main(long, char**);


//int main (int argc_0X, char * argv_1X) 
long main(long argc_0X, char **argv_1X)
{
  FILE * out_3X;
  FILE * out_2X;
 {  if ((2 == argc_0X)) {
    out_2X = stdout;
    ps_write_string("Hello, world, ", out_2X);
    ps_write_string((*(argv_1X + 1)), out_2X);
    { long ignoreXX;
    PS_WRITE_CHAR(33, out_2X, ignoreXX) }
    { long ignoreXX;
    PS_WRITE_CHAR(10, out_2X, ignoreXX) }
    return 0;}
  else {
    out_3X = stderr;
    ps_write_string("Usage: ", out_3X);
    ps_write_string((*(argv_1X + 0)), out_3X);
    ps_write_string(" <user>", out_3X);
    { long ignoreXX;
    PS_WRITE_CHAR(10, out_3X, ignoreXX) }
    ps_write_string("  Greets the world & <user>.", out_3X);
    { long ignoreXX;
    PS_WRITE_CHAR(10, out_3X, ignoreXX) }
    return -1;}}
}
