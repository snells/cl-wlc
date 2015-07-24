
(in-package #:cl-wlc)


;;; see callback.lisp for callback-fn prototypes

;;; use bare reference to structures
;;; Otherwise the program will be very unstable or crash right away
;;; is it safe to use ctypes defined with (:struct type) elsewhere?
;;; or should you just use the deprecated bare reference?


(defun run-wm (argv &key threaded
		      view-created view-destroyed view-focus
		      view-move-to-output
		      output-created output-destroyed output-focus
		      output-resolution keyboard-key pointer-button
		      pointer-scroll pointer-motion touch compositor-ready)

  (if view-created (setf callback-fn-view-created view-created))
  (if view-destroyed (setf callback-fn-view-destroyed view-destroyed))
  (if view-focus (setf callback-fn-view-focus view-focus))
  (if view-move-to-output (setf callback-fn-view-move-to-output view-move-to-output))

  (if output-created (setf callback-fn-output-created output-created))
  (if output-destroyed (setf callback-fn-output-destroyed output-destroyed))
  (if output-focus (setf callback-fn-output-focus output-focus))
  (if output-resolution (setf callback-fn-output-resolution output-resolution))

  (if keyboard-key (setf callback-fn-keyboard-key keyboard-key))

  (if pointer-button (setf callback-fn-pointer-button pointer-button))
  (if pointer-motion (setf callback-fn-pointer-motion pointer-motion))
  (if pointer-scroll (setf callback-fn-pointer-scroll pointer-scroll))

  (if touch (setf callback-fn-touch-touch touch))

  (if compositor-ready (setf callback-fn-compositor-ready compositor-ready))
  
  (let* ((interface ;(alloc 'c-wlc-interface))
	  ;; I made c function to return pointer to interface
	  ;; because the program would not run or would be really unstable
	  (foreign-funcall "bare_s_interface" :pointer))
	 (argc (length argv))
	 (c-argv (foreign-alloc :string
				:initial-contents argv
				:null-terminated-p t))
	 (output (alloc 'wlc-interface-output))
	 (keyboard (alloc 'wlc-interface-keyboard))
	 (view (alloc 'wlc-interface-view))
	 (pointer (alloc 'wlc-interface-pointer)))
    (set-struct-val output 'wlc-interface-output 'created (callback output-created))
    (set-struct-val output 'wlc-interface-output 'resolution (callback output-resolution))
					;(set-struct-val output 'wlc-interface-output 'destroyed (callback output-destroyed))
    (set-struct-val interface 'wlc-interface 'output output)
    (set-struct-val pointer 'wlc-interface-pointer 'button (callback pointer-button))
    (set-struct-val interface 'wlc-interface 'pointer pointer)
    (set-struct-val view 'wlc-interface-view 'created (callback view-created))
    (set-struct-val view 'wlc-interface-view 'focus (callback view-focus))
					;(set-struct-val view 'wlc-interface-view 'destroyed (callback view-destroyed))
    (set-struct-val interface 'wlc-interface 'view view)
    (set-struct-val keyboard 'wlc-interface-keyboard 'key (callback keyboard-key))
    (set-struct-val interface 'wlc-interface 'keyboard keyboard)
    (format out "cl-wlc init~%")
    (if threaded
	(bt:make-thread (lambda ()
			  (unless (zerop (wlc-init interface argc c-argv))
			  (format out "cl-wlc init success~%cl-wlc running~%")
			  (wlc-run)
			  (format out "cl-wlc freeing lisp allocated variables~%")
			  (free output keyboard view pointer c-argv)
			  (format out "cl-wlc free success~%"))))
	(unless (zerop (wlc-init interface argc c-argv))
	  (wlc-run)
	  (free output keyboard view pointer c-argv)))))







(defcallback bare-kb bool
    ((view wlc-handle)
     (time :uint32)
     (modifiers c-wlc-modifiers)
     (key :uint32)
     (sym :uint32)
     (state wlc-key-state))
    (cond ((= sym #xff1b) ;#\escape
	   (wlc-terminate))
	  ((= sym #x31) ;#\1
	   (cl-exec "weston-terminal"))
	  (t 1)))

(defcallback bare-view-created bool
    ((view wlc-handle))
  (format out "view created ~a~%" view)
  (wlc-view-bring-to-front view)
  (wlc-view-focus view) t)
(defcallback bare-view-focus :void
    ((view wlc-handle)
     (focus bool))
  (wlc-view-set-state +state-activated+ focus))
(defun bare-wm ()
  (let* ((interface ;(alloc 'wlc-interface))
	  (foreign-funcall "bare_s_interface" :pointer))
	 (argc 1)
	 (argv (foreign-alloc :string
			      :initial-contents '("dummy"); "--log" "/home/log")
			      :null-terminated-p t))
	 (keyboard (alloc 'wlc-interface-keyboard))
	 (view (alloc 'wlc-interface-view)))
    (set-struct-val view 'wlc-interface-view 'created (callback bare-view-created))
    (set-struct-val view 'wlc-interface-view 'focus (callback bare-view-focus))
    (set-struct-val interface 'wlc-interface 'view view)
    ;(set-struct-val keyboard 'wlc-interface-keyboard 'key (callback bare-kb))
    ;(set-struct-val interface 'wlc-interface 'keyboard keyboard)
    (format out "cl-wlc init~%")
    (bt:make-thread (lambda ()
		      (unless (zerop (wlc-init interface argc argv))
			(format out "cl-wlc init success~%cl-wlc running~%")
			(wlc-run)
			(format out "cl-wlc freeing lisp allocated variables~%")
					;(foreign-string-free argv)
			(free keyboard view argv)
			(format out "cl-wlc free success~%")
			(wlc-terminate))))))
