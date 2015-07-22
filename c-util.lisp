(in-package :cl-wlc)

(defun free (&rest pts)
  (dolist (pt pts)
    (foreign-free pt)))
  
(defun alloc (type &optional (count 1))
  (foreign-alloc type :count count))

; tests if obj would be true/false in c
(defun cp (obj)
  (cond ((and (pointerp obj) (null-pointer-p obj)) nul)
  	((and (numberp obj) (zerop obj)) nil)
  	((not (null  obj)) t)))


; c struct getters + setters
(defun struct-val (pt type slot)
  (foreign-slot-value pt type slot))
  
(defun struct-pt (pt type slot)
  (foreign-slot-pointer pt type slot))
  
(defun set-struct-val (pt type slot val)
  (setf (foreign-slot-value pt type slot) val))
  
(defun struct-nested (lst &optional (fn #'struct-val))
  (if (null (cdr lst))
      (apply fn (car lst))
      (progn (push (apply #'struct-pt (car lst))
  		   (cadr lst))
  	     (struct-nested (cdr lst) fn))))
  
(defun set-struct-nest (lst)
  (struct-nested lst #'set-struct-val))
  
(defun struct-nested-val (lst)
  (struct-nested lst #'struct-val))
(defun struct-nested-pt (lst)
  (struct-nested lst #'struct-pt))

;defines setfable getter function for foreign-type
; (def-pt-ref int) => (ref-int pointer-to-int), (setf (ref-int pointer-to-int) 10)
(defmacro def-pt-ref (type)
  `(progn (defun ,(intern
		   (string-upcase
		    (format nil "REF-~a" type))) (pt)
	    (mem-ref pt ,type))
	  (defun (setf ,(intern
			 (string-upcase
			  (format nil "REF-~a" type)))) (val pt)
	    (setf (mem-ref pt ,type) val))))
(defmacro def-pts-from-list (lst)
  `(progn ,@(mapcar (lambda (item)
		      `(def-pt-ref ,item))
		    lst)))


; makes pointer to foreign structure and push the pointer to pointers
; symbol is the key to be used for the key-value pair in the pointers
; struct test_x { int x, int y };   (defcstuct test-x (x :int) (y :int))
; (make-struct 'my-struct 'test-x :vals '((x 10) (y 20))) => pointer-to-struct
; (get-pointer 'my-struct) => pointer-to-struct
; (struct-val (get-pointer 'my-struct) 'test-x 'x) => 10
; (free-pointer 'my-struct) ;;; you can also pass the pointer of (get-pointer 'my-struct) to free-pointer
; use free-pointer only when freeing pointer made with make-struct
(defvar pointers nil)
(defun make-struct (symbol type &key (vals nil) (count 1))
  (unwind-protect
       (handler-case
	   (let ((pt (alloc type count))
		 (names (foreign-slot-names type)))
	     (dotimes (x (length vals))
	       (let* ((val (nth x vals))
		      (slot (if (null (cdr val))
				(nth x names)
				(car val)))
		      (v (if (null (cdr val))
			     (car val)
			     (cadr val))))
		 (set-struct-val pt type slot v)))
	     (push (cons symbol pt) pointers)
	     pt)
	 (error (e)
	   (format t "error ~a~%" e)
	   (free-pointer symbol)))))
(defmacro with-struct ((symbol type &key (vals nil) (count 1)) &rest body)
  (let* ((symb (gensym))
	 (pt (make-struct symb type :vals vals :count count)))
    `(let ((,symbol ,pt))
       (progn ,@body)
       (free-pointer ,pt))))


(defun get-from-pointers (key)
  (if (pointerp key)
      (rassoc key pointers :test #'pointer-eq)
      (assoc key pointers)))
(defun get-pointer (key)
  (when key
    (cdr (get-from-pointers key))))

(defun free-pointer (key)
  (when (get-pointer key)
    (free (get-pointer key))
    (setf pointers (remove (get-from-pointers key) pointers))))
