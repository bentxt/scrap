/*
 * Call Pre-Scheme static initialization before main.
 */
__attribute__((constructor))
void ps_init(void);

/*
 * Missing definition for open-input-file.  Probably an oversight, it's
 * defined in scheme48.h but should be in prescheme.h.
 */
#define NO_ERRORS 0
