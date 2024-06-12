;;; Copyright 2022 Andrew Whatson

(define-module (prescheme record-discloser)
  #:use-module (srfi srfi-9 gnu)
  #:export (define-record-discloser))

(define (define-record-discloser type discloser)
  (set-record-type-printer! type
    (lambda (record port)
      (let* ((vals (discloser record))
             (specs (string-join (make-list (length vals) "~a")))
             (template (string-append "{" specs "}")))
        (apply format port template vals)))))
