(hall-description
  (name "prescheme")
  (prefix "guile")
  (version "0.1-pre")
  (author "Andrew Whatson")
  (copyright (2022))
  (synopsis
    "Guile port of Pre-Scheme, a Scheme-like systems language")
  (description
    "guile-prescheme is a port of the Pre-Scheme compiler from Scheme 48.  Pre-Scheme is a statically typed dialect of Scheme which offers the efficiency and low-level machine access of C while retaining many of the desirable features of Scheme.")
  (home-page
    "https://notabug.org/flatwhatson/guile-prescheme")
  (license bsd-3)
  (dependencies `())
  (skip ())
  (files (libraries
           ((directory
              "language"
              ((directory
                 "prescheme"
                 ((scheme-file "core")
                  (scheme-file "spec")))))
            (directory
              "prescheme"
              ((directory
                 "bcomp"
                 ((scheme-file "binding")
                  (scheme-file "cenv")
                  (scheme-file "interface")
                  (scheme-file "mtype")
                  (scheme-file "name")
                  (scheme-file "node")
                  (scheme-file "package")
                  (scheme-file "read-form")
                  (scheme-file "schemify")
                  (scheme-file "syntax")
                  (scheme-file "transform")
                  (scheme-file "transform4")
                  (scheme-file "usual")))
               (directory
                 "env"
                 ((scheme-file "stubs")))
               (scheme-file "environment")
               (scheme-file "filename")
               (scheme-file "locations")
               (scheme-file "memory")
               (scheme-file "platform")
               (scheme-file "population")
               (scheme-file "prescheme")
               (scheme-file "ps-defenum")
               (scheme-file "ps-record-types")
               (scheme-file "record-discloser")
               (scheme-file "s48-defenum")
               (scheme-file "s48-defrecord")
               (scheme-file "scheme48")
               (scheme-file "syntax-utils")))
            (directory
              "ps-compiler"
              ((directory
                 "front"
                 ((scheme-file "cps")
                  (scheme-file "jump")
                  (scheme-file "top")))
               (directory
                 "node"
                 ((scheme-file "arch")
                  (scheme-file "let-nodes")
                  (scheme-file "node-check")
                  (scheme-file "node-equal")
                  (scheme-file "node-letrec")
                  (scheme-file "node")
                  (scheme-file "node-util")
                  (scheme-file "pp-cps")
                  (scheme-file "primop")
                  (scheme-file "variable")
                  (scheme-file "vector")))
               (scheme-file "param")
               (directory
                 "prescheme"
                 ((directory
                    "primop"
                    ((scheme-file "arith")
                     (scheme-file "base")
                     (scheme-file "c-arith")
                     (scheme-file "c-base")
                     (scheme-file "c-io")
                     (scheme-file "c-primop")
                     (scheme-file "c-vector")
                     (scheme-file "io")
                     (scheme-file "primop")
                     (scheme-file "scm-arith")
                     (scheme-file "scm-memory")
                     (scheme-file "scm-record")
                     (scheme-file "scm-scheme")
                     (scheme-file "vector")))
                  (scheme-file "c")
                  (scheme-file "c-call")
                  (scheme-file "c-decl")
                  (scheme-file "c-util")
                  (scheme-file "display")
                  (scheme-file "eval")
                  (scheme-file "expand")
                  (scheme-file "external-value")
                  (scheme-file "flatten")
                  (scheme-file "form")
                  (scheme-file "front-end")
                  (scheme-file "hoist")
                  (scheme-file "inference")
                  (scheme-file "infer-early")
                  (scheme-file "linking")
                  (scheme-file "merge")
                  (scheme-file "node-type")
                  (scheme-file "primitive")
                  (scheme-file "ps-syntax")
                  (scheme-file "record")
                  (scheme-file "spec")
                  (scheme-file "substitute")
                  (scheme-file "to-cps")
                  (scheme-file "top")
                  (scheme-file "type-scheme")
                  (scheme-file "type")
                  (scheme-file "type-var")))
               (directory
                 "simp"
                 ((scheme-file "call")
                  (scheme-file "flow-values")
                  (scheme-file "join")
                  (scheme-file "let")
                  (scheme-file "pattern")
                  (scheme-file "remove-cells")
                  (scheme-file "simplify")))
               (directory
                 "util"
                 ((scheme-file "byte-vector")
                  (scheme-file "dominators")
                  (scheme-file "expand-vec")
                  (scheme-file "separators")
                  (scheme-file "ssa")
                  (scheme-file "strong")
                  (scheme-file "syntax")
                  (scheme-file "transitive")
                  (scheme-file "util")
                  (scheme-file "z-set")))))))
         (tests ((directory "tests" ())))
         (programs ((directory "scripts" ())))
         (documentation
           ((directory "doc" ((texi-file "prescheme")))
            (text-file "COPYING")
            (text-file "HACKING")
            (symlink "README" "README.org")
            (org-file "README")))
         (infrastructure
           ((scheme-file "hall")
            (text-file ".gitignore")
            (scheme-file "guix")))))
