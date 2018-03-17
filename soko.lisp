;;;; soko.lisp

(in-package #:soko)

(defvar *db* nil)

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

(defstruct task date short-name num-slots assigned type)

(defstruct schedule-def name start end task-defs)

(defstruct task-def short-name num-slots dow type)

(defstruct assignment name note tag)


(defun make-tasks (start end task-def)
  "Make a bunch of tasks from start date to end date"
  (let ((days (date-range start end (task-def-dow task-def))))
    (mapcar (lambda (d) (make-task :date (format-timestring nil d) 
                              :short-name (task-def-short-name task-def) 
                              :num-slots (task-def-num-slots task-def) 
                              :assigned nil
                              :type (task-def-type task-def))) 
            days)))


(defun add-task (task)
  (push task *db*))

;;DB IO functions
(defun dump-db () 
 (dolist (tsk *db*)
    (format t "~{~a:~10t~a~%~}~%" tsk)))

(defun clear-db ()
  (setf *db* nil))

(defun save-db (filename)
  (with-open-file (out filename
                   :direction :output
                   :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))



(defun new-task-def (short-name &optional (ns 1) (dow (list 1 2 3 4 5)) (type :required))
  (make-task-def :short-name short-name
                 :num-slots ns
                 :dow dow
                 :type type))

(defun build-schedule (schedule-def)
  (apply #'append 
         (mapcar (lambda (t-def) (make-tasks (schedule-def-start schedule-def)
                                        (schedule-def-end schedule-def)
                                        t-def))
                 (schedule-def-task-defs schedule-def))))



(defun assign (&key person to on (&optional repeat skip) )
  "hello")


;;;;
(defvar *start* (make-date 6 22 2018))
(defvar *end* (make-date 12 22 2018))

(defparameter *task-defs* (list (new-task-def "WMR-BODY")
                                (new-task-def "WMR-NEURO")
                                (new-task-def "WMR-FLUORO")
                                (new-task-def "WMR-PEDS")
                                (new-task-def "WMR-VASC1")
                                (new-task-def "WMR-VASC2")
                                (new-task-def "WMR-EVE1")
                                (new-task-def "WMR-EVE2")
                                (new-task-def "WMR-LATE" 1 (list 0 1 2 3 4 5 6 ))
                                (new-task-def "WMC-MAMMO" 1 (list 1 3 5))
                                (new-task-def "WMC-VASC")
                                (new-task-def "WMC-FLUORO")
                                (new-task-def "WM-NORTH")
                                (new-task-def "WM-APEX")
                                (new-task-def "WMRMP-MAMMO" 1 (list 2 4))
                                (new-task-def "WMRMP-GEN" 1 (list 1 3 5))
                                (new-task-def "RR-NEURO")
                                (new-task-def "RR-ORTHO")
                                (new-task-def "RR-MSK" 1 (list 1))
                                (new-task-def "RR-MSC" 1 (list 2 4))
                                (new-task-def "RR-CVA")
                                (new-task-def "RR-BRO")
                                (new-task-def "RR-CED")
                                (new-task-def "RR-RRC")
                                (new-task-def "RR-CLA" 1 (list 2 5))
                                (new-task-def "RR-WFO" 1 (list 1 3 4))
                                (new-task-def "RR-BKU")
                                ))


(setf *my-def* (make-schedule-def 
                :name "Fall 2018" 
                :start *start* 
                :end *end* 
                :task-defs *task-defs*))

(defparameter *s1* (build-schedule *my-def*))


