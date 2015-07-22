(in-package :cl-wlc)

(defmacro test-view-fn-list (test-fn fns view)
  (let ((l '()))
    (dolist (fn fns)
      (push `(,test-fn ,fn ,view) l))
    `(progn ,@l)))
    
(defmacro test-view-fn (fn view)
  `(progn (format out "TESTING ~a ON VIEW ~A~%" ',fn ,view)
	  (let ((ret (,fn ,view)))
	  (format out "TEST SUCCESS RETURN VALUE ~a~%~%" ret))))


(defmacro test-view-moving (fn view)
  `(progn (format out "TESTING ~a ON VIEW ~A RELATIVE TO VIEW 2~%" ',fn ,view)
	  (let ((ret (,fn ,view 2)))
	    (format out "TEST SUCCESS RETURN VALUE ~a~%~%" ret))))

(defmacro test-output-fn (fn view &optional parse-fn)
  `(progn (format out "TESTING ~a ON OUTPUT ~A~%" ',fn ,view)
	  (let ((ret (,fn ,view)))
	    (format out "TEST SUCCESS RETURN VALUE ~a~%~%"
		    ,(if parse-fn `(,parse-fn ret) 'ret)))))



(defun test-view-fns (view sym)
  (when (= view 0)
    (format out "TESTING STOPPED BECAUSE NO VIEW IS CURRENTLY FOCUSED~%")
    (return-from test-view-fns))
  (format out "STARTING TEST ON VIEW ~a~%" view)
  (case sym
    ;#\1
    (#x31 
     (test-view-fn-list test-view-fn (view-mask view-type view-output
						view-parent view-geometry
						view-state managedp
						view-id
					;view-title
						override-redirectp) view))
    ;#\2
    (#x32 
     (test-view-fn-list test-view-moving (;view-bring-above
					  view-send-below
					;view-send-to-back
					  )
			view))
    ;#\3
    (#x33 (test-view-fn-list test-output-fn (output-views
					     output-mask
					     output-resolution
					     output-focus) (view-output view)))
    ;#\4
    (#x34 (let ((output (view-output view)))
	    (test-output-fn output-resolution output ref-wlc-size)))))

