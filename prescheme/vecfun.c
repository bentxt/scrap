#include "prescheme.h"
#include "ps-init.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long main(void);
static long *Qvec_a;

long main(void) {
  long *arg3K1;
  char **arg2K1;
  long arg0K1;
  long arg0K0;
  long merged_arg0K1;
  long merged_arg0K0;

#ifdef USE_DIRECT_THREADING
  void *procD0_return_address;
#else
  int procD0_return_tag;
#endif
  long procD00_return_value;
#ifdef USE_DIRECT_THREADING
  void *procD1_return_address;
#else
  int procD1_return_tag;
#endif
  char *procD10_return_value;
  long val1_0X;
  long val2_1X;
  long val_2X;
  long src_26X;
  long tgt_25X;
  long ix_24X;
  char *target_23X;
  long total_22X;
  long len_21X;
  long i_20X;
  char *val_19X;
  long i_18X;
  char *v_17X;
  char **result_16X;
  long i_15X;
  long val_14X;
  char *v_13X;
  long i_12X;
  long v_11X;
  long *result_10X;
  long i_9X;
  long v_8X;
  long result_7X;
  long i_6X;
  long val_5X;
  long i_4X;
  FILE *out_3X;
  {
    out_3X = stdout;
    ps_write_string("Print vec-a with vector-for-each:\n", out_3X);
    arg0K0 = 0;
    goto L401;
  }
L401 : {
  i_4X = arg0K0;
  if ((5 == i_4X)) {
    ps_write_string("Print the last value of vec-a with vector-fold:\n",
                    out_3X);
    arg0K0 = 0;
    arg0K1 = -1;
    goto L418;
  } else {
    val_5X = *(Qvec_a + i_4X);
    ps_write_string(" vec-a[", out_3X);
    ps_write_integer(i_4X, out_3X);
    ps_write_string("] = ", out_3X);
    ps_write_integer(val_5X, out_3X);
    {
      long ignoreXX;
      PS_WRITE_CHAR(10, out_3X, ignoreXX)
    }
    arg0K0 = (1 + i_4X);
    goto L401;
  }
}
L418 : {
  i_6X = arg0K0;
  result_7X = arg0K1;
  if ((5 == i_6X)) {
    ps_write_string(" vec-a[-1] = ", out_3X);
    ps_write_integer(result_7X, out_3X);
    {
      long ignoreXX;
      PS_WRITE_CHAR(10, out_3X, ignoreXX)
    }
    ps_write_string("Compute the sum of two vectors with vector-map:\n",
                    out_3X);
    merged_arg0K0 = (*(Qvec_a + 0));
    merged_arg0K1 = (*(Qvec_a + 0));
#ifdef USE_DIRECT_THREADING
    procD0_return_address = &&procD0_return_0;
#else
    procD0_return_tag = 0;
#endif
    goto procD0;
  procD0_return_0:
    v_8X = procD00_return_value;
    arg0K0 = 0;
    arg3K1 = ((long *)malloc(sizeof(long) * 5));
    goto L442;
  } else {
    arg0K0 = (1 + i_6X);
    arg0K1 = (*(Qvec_a + i_6X));
    goto L418;
  }
}
L442 : {
  i_9X = arg0K0;
  result_10X = arg3K1;
  if ((5 == i_9X)) {
    arg0K0 = 0;
    goto L468;
  } else {
    merged_arg0K0 = (*(Qvec_a + i_9X));
    merged_arg0K1 = (*(Qvec_a + i_9X));
#ifdef USE_DIRECT_THREADING
    procD0_return_address = &&procD0_return_1;
#else
    procD0_return_tag = 1;
#endif
    goto procD0;
  procD0_return_1:
    v_11X = procD00_return_value;
    *(result_10X + i_9X) = v_11X;
    arg0K0 = (1 + i_9X);
    arg3K1 = result_10X;
    goto L442;
  }
}
L468 : {
  i_12X = arg0K0;
  if ((5 == i_12X)) {
    free(result_10X);
    ps_write_string("Build a vector of strings with vector-map:\n", out_3X);
    merged_arg0K0 = (*(Qvec_a + 0));
#ifdef USE_DIRECT_THREADING
    procD1_return_address = &&procD1_return_0;
#else
    procD1_return_tag = 0;
#endif
    goto procD1;
  procD1_return_0:
    v_13X = procD10_return_value;
    arg0K0 = 0;
    arg2K1 = ((char **)malloc(sizeof(char *) * 5));
    goto L486;
  } else {
    val_14X = *(result_10X + i_12X);
    ps_write_string(" sums[", out_3X);
    ps_write_integer(i_12X, out_3X);
    ps_write_string("] = ", out_3X);
    ps_write_integer(val_14X, out_3X);
    {
      long ignoreXX;
      PS_WRITE_CHAR(10, out_3X, ignoreXX)
    }
    arg0K0 = (1 + i_12X);
    goto L468;
  }
}
L486 : {
  i_15X = arg0K0;
  result_16X = arg2K1;
  if ((5 == i_15X)) {
    arg0K0 = 0;
    goto L504;
  } else {
    merged_arg0K0 = (*(Qvec_a + i_15X));
#ifdef USE_DIRECT_THREADING
    procD1_return_address = &&procD1_return_1;
#else
    procD1_return_tag = 1;
#endif
    goto procD1;
  procD1_return_1:
    v_17X = procD10_return_value;
    *(result_16X + i_15X) = v_17X;
    arg0K0 = (1 + i_15X);
    arg2K1 = result_16X;
    goto L486;
  }
}
L504 : {
  i_18X = arg0K0;
  if ((5 == i_18X)) {
    arg0K0 = 0;
    goto L520;
  } else {
    val_19X = *(result_16X + i_18X);
    ps_write_string(" strs[", out_3X);
    ps_write_integer(i_18X, out_3X);
    ps_write_string("] = \"", out_3X);
    ps_write_string(val_19X, out_3X);
    {
      long ignoreXX;
      PS_WRITE_CHAR(34, out_3X, ignoreXX)
    }
    {
      long ignoreXX;
      PS_WRITE_CHAR(10, out_3X, ignoreXX)
    }
    arg0K0 = (1 + i_18X);
    goto L504;
  }
}
L520 : {
  i_20X = arg0K0;
  if ((5 == i_20X)) {
    free(result_16X);
    return 0;
  } else {
    free((*(result_16X + i_20X)));
    arg0K0 = (1 + i_20X);
    goto L520;
  }
}
procD1 : {
  val_2X = merged_arg0K0;
  {
    len_21X = strlen((char *)"x");
    total_22X = len_21X * val_2X;
    target_23X = (char *)calloc(1, 1 + total_22X);
    arg0K0 = 0;
    goto L108;
  }
L108 : {
  ix_24X = arg0K0;
  if ((ix_24X == total_22X)) {
    procD10_return_value = target_23X;
#ifdef USE_DIRECT_THREADING
    goto *procD1_return_address;
#else
    goto procD1_return;
#endif
  } else {
    arg0K0 = ix_24X;
    arg0K1 = 0;
    goto L41;
  }
}
L41 : {
  tgt_25X = arg0K0;
  src_26X = arg0K1;
  if ((src_26X == len_21X)) {
    arg0K0 = (ix_24X + len_21X);
    goto L108;
  } else {
    *(target_23X + tgt_25X) = (*("x" + src_26X));
    arg0K0 = (1 + tgt_25X);
    arg0K1 = (1 + src_26X);
    goto L41;
  }
}
#ifndef USE_DIRECT_THREADING
procD1_return:
  switch (procD1_return_tag) {
  case 0:
    goto procD1_return_0;
  default:
    goto procD1_return_1;
  }
#endif
}

procD0 : {
  val1_0X = merged_arg0K0;
  val2_1X = merged_arg0K1;
  {
    procD00_return_value = (val1_0X + val2_1X);
#ifdef USE_DIRECT_THREADING
    goto *procD0_return_address;
#else
    goto procD0_return;
#endif
  }
#ifndef USE_DIRECT_THREADING
procD0_return:
  switch (procD0_return_tag) {
  case 0:
    goto procD0_return_0;
  default:
    goto procD0_return_1;
  }
#endif
}
}
void ps_init(void) {
  Qvec_a = malloc(5 * sizeof(long));
  Qvec_a[0] = 0;
  Qvec_a[1] = 1;
  Qvec_a[2] = 4;
  Qvec_a[3] = 9;
  Qvec_a[4] = 16;
}
