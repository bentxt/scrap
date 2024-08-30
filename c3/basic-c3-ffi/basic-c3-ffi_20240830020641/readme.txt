Basic C3 FFI
============


A simple example that shows how effortless you can call C functions from C3. I'm
not even sure if the term Foreign Function Interface is appropriate here,
because calling C functions does not feel foreign at all.

For me the `c3c` command in the Makefile is the most important part of the whole
demonstration. It was provided to me by the author of the C3 language in the
discord channel only minutes after I asked that question. Very nice! 

```
c3c compile-only -O1 -o c3math c3math.c3 --single-module=yes
```







