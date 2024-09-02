Basic Ocaml ffi with c library (update)
=======================================



## Update: 
I posted the original article ([basic-ocaml-ffi-cfile_20240829235643](./basic-ocaml-ffi-cfile_20240829235643.html))
also on the Ocaml forum. From a user "nojb" I got the following comment on 
[https://discuss.ocaml.org/t/blog-post-simple-example-where-ocaml-calls-a-c-function/15211](https://discuss.ocaml.org/t/blog-post-simple-example-where-ocaml-calls-a-c-function/15211):

> nojb:
> [...]
> Just a tiny comment: the CAMLprim macro is something used in the compiler codebase, but does not actually do anything for user code (even if some people like to keep it anyway as a kind of reminder that the function is exposed as an OCaml primitive).



## Rest of the original article: Basic Ocaml ffi with c library

url: ([basic-ocaml-ffi-cfile_20240829235643](./basic-ocaml-ffi-cfile_20240829235643.html))

In the previous article I just showed the most basic and simple way to call C
from Ocaml. Read more about here
[./basic-ocaml-ffi_20240828121852.html](./basic-ocaml-ffi_20240828121852.html).

So this is another basic example that shows how to call into a C function from Ocaml. This
time the C function exists in its own library source file inclusive a header
file.

The base and starting point for this article is again an article on
StackOverflow.com under
[https://stackoverflow.com/questions/57029419/unresolved-external-function-while-linking-ocaml-and-c](https://stackoverflow.com/questions/57029419/unresolved-external-function-while-linking-ocaml-and-c)


