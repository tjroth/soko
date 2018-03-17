;;;; utility.lisp

(in-package #:utility)


;;; Utility functions
(defun make-date (m d y)
  "Creates a timestamp object from month date and year"
  (encode-timestamp 0 0 0 0 d m y))



(defun date-range (start end &optional dows)
  "Returns a list of dates from start to end, limit to days of week (list of integers)
   (dows), 0 sunday 1 monday ..."
  (let  ((ds (cons start
                   (loop for i from 1
                         for d = (timestamp+ start i :day)
                         while (timestamp<= d end)
                         collect d))))
    (if dows
        (remove-if-not (lambda (d) (find (timestamp-day-of-week d) dows)) ds)
        ds)))



(defun hello (nm)
  (format t "hello ~a" nm))


(hello "boo")
