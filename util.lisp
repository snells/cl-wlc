(in-package :cl-wlc)


(defmacro  print-debug (str &rest args)
  `(if *cl-wlc-debug* (format out ,(concatenate 'string "CL-WLC-DEBUG " str) ,@args)))

(defmacro print-debug-fn (name &rest args)
  `(if *cl-wlc-debug* (format out "CL-WLC-DEBUG FUNCTION ~a WITH ARGSx ~@{~a~^ ~}" ',name ,@args)))
