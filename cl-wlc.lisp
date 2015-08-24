
(in-package #:cl-wlc)


;;; see callback.lisp for callback-fn prototypes


(defun run-wm (argv &key threaded
		      view-created view-destroyed view-focus
		      view-move-to-output
		      output-created output-destroyed output-focus
		      output-resolution keyboard-key pointer-button
		      pointer-scroll pointer-motion touch compositor-ready)

  (if view-created (setf callback-view-created view-created))
  (if view-destroyed (setf callback-view-destroyed view-destroyed))
  (if view-focus (setf callback-view-focus view-focus))
  (if view-move-to-output (setf callback-view-move-to-output view-move-to-output))

  (if output-created (setf callback-output-created output-created))
  (if output-destroyed (setf callback-output-destroyed output-destroyed))
  (if output-focus (setf callback-output-focus output-focus))
  (if output-resolution (setf callback-output-resolution output-resolution))

  (if keyboard-key (setf callback-keyboard-key keyboard-key))

  (if pointer-button (setf callback-pointer-button pointer-button))
  (if pointer-motion (setf callback-pointer-motion pointer-motion))
  (if pointer-scroll (setf callback-pointer-scroll pointer-scroll))

  (if touch (setf callback-touch-touch touch))

  (if compositor-ready (setf callback-compositor-ready compositor-ready))
  
  (let* ((interface ;(alloc 'c-wlc-interface))
	  ;; I made c function to return pointer to interface
	  ;; because the program would not run or would be really unstable
	  (foreign-funcall "bare_s_interface" :pointer))
	 (argc (length argv))
	 (c-argv (foreign-alloc :string
				:initial-contents argv
				:null-terminated-p t))
	 (output (alloc 'interface-output))
	 (keyboard (alloc 'interface-keyboard))
	 (view (alloc 'interface-view))
	 (pointer (alloc 'interface-pointer))
	 (touch (alloc 'interface-touch)))
    (set-struct-val output 'interface-output 'created (callback output-created))
    (set-struct-val output 'interface-output 'resolution (callback output-resolution))
    (set-struct-val output 'interface-output 'destroyed (callback output-destroyed))
    (set-struct-val interface 'wlc-interface 'output output)
    (set-struct-val pointer 'interface-pointer 'button (callback pointer-button))
    (set-struct-val interface 'wlc-interface 'pointer pointer)
    (set-struct-val view 'interface-view 'created (callback view-created))
    (set-struct-val view 'interface-view 'focus (callback view-focus))
    (set-struct-val view 'wlc-interface-view 'destroyed (callback view-destroyed))
    (set-struct-val interface 'wlc-interface 'view view)
    (set-struct-val keyboard 'interface-keyboard 'key (callback keyboard-key))
    (set-struct-val interface 'wlc-interface 'keyboard keyboard)
    ;(set-struct-val touch 'interface-touch 'touch (callback touch-touch))
    ;(set-struct-val interface 'wlc-interface 'touch touch)
    
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
	  (format out "cl-wlc freeing lisp allocated variables~%")
	  (free output keyboard view pointer touch c-argv)
	  (format out "cl-wlc free success~%")))))



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
