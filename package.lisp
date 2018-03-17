;;;; package.lisp


(defpackage #:utility
  (:use #:cl :local-time)
  (:export :hello
   :make-date
   :date-range))

(defpackage #:soko
  (:use #:cl :local-time :utility))


