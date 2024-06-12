(declare
 (extended-bindings) ;; allow using ##inline-host-XXX
)

;;; ##inline-host-XXX procedures and @scm2host@/@host2scm@ provide a low-level
;;; API to interface with Javascript code. With Six (see next chapter) this
;;; can be avoided.

(define (alert obj)
  ;;; ##inline-host-statement's are executed for their side-effects
  (##inline-host-statement "print(@scm2host@(@1@))" obj))

(define (prompt msg)
  ;;; ##inline-host-expression return a value
  (##inline-host-expression "@host2scm@(prompt(@scm2host@(@1@)))"
                            (if (string? msg)
                                msg
                                (object->string msg))))

(alert "hello")
;(alert (string-append "Hello "
;                      (prompt "Enter your name: ")
;                      "!"))

