//  dmd -betterC example.d

import core.stdc.stdio;
import core.stdc.stdlib;
// import std.string; // fails bc gc

extern(C):

int main()
{
    auto p = malloc(128);
    // free() will be called when the current scope exits
    scope (exit) free(p);
    // Put whatever if statements, or loops, or early returns you like here
    printf("1 + 1 = %d!\n", 1 + 1);
    return 0;
}
