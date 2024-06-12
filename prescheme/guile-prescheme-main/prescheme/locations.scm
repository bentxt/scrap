;;; Ported from Scheme 48 1.9.  See file COPYING for notices and license.
;;;
;;; Port Author: Andrew Whatson
;;;
;;; Original Authors: Richard Kelsey, Jonathan Rees
;;;
;;;   scheme48-1.9.2/scheme/alt/locations.scm
;;;
;;; Locations

(define-module (prescheme locations)
  #:use-module (srfi srfi-9)
  #:use-module (prescheme record-discloser)
  #:export (location?
            location-defined?
            location-assigned?
            location-id
            set-location-id!
            make-undefined-location
            set-location-defined?!
            contents
            set-contents!))

(define-record-type :location
  (make-location id defined? contents)
  location?
  (id       location-id       set-location-id!)
  (defined? location-defined? set-defined?!)
  (contents contents          set-contents!))

(define-record-discloser :location
  (lambda (l) `(location ,(location-id l))))

(define (make-undefined-location id)
  (make-location id #f '*empty*))

(define (set-location-defined?! loc ?)
  (set-defined?! loc ?)
  (if (not ?)
      (set-contents! loc '*empty*)))
