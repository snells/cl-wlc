(in-package :cl-wlc)


;;; callbacks that return type bool should return lisp boolean (t nil)
;;; means 0 is also true

(defvar callback-fn-output-created
  (lambda (output)
    (format out "output created~a~%" output) 1))
(defvar callback-fn-output-destroyed
  (lambda (output)
    (format out "output destroyed ~a~%" output)))
(defvar callback-fn-output-focus
  (lambda (output focus)
    (format out "output focus~%")))
(defvar callback-fn-output-resolution
  (lambda (output size-from size-to)
    (format out "output resolution~%")))
(defvar callback-fn-view-created
  (lambda (view)
    (format out "view created~a~%" view)
    (view-set-state view +state-activated+ t)
    (view-bring-to-front view)
    (view-focus view) 1))

(defvar callback-fn-view-destroyed
  (lambda (view)
    (format out "view-destroyed~a~%" view)))

(defvar callback-fn-view-focus
  (lambda (view focus)
    (format out "view-focus~a geo ~a~%" view (view-geometry view))
    (view-set-state view +state-activated+ t)
    (view-bring-to-front view)
    (view-focus view) 1))

(defvar callback-fn-view-move-to-output
  (lambda (view output-from output-to)
    (format out "view ~a moved from ~a to ~a~%" view from to)))

;;; shift 1 caps 2 ctrl 4 alt 8 mod2 16 mod3 32 log0 64 mod5 128
;;; for some reason every key press and mouse button press is
;;; received 2 times
;;; we use exec-delay to prevent the second press
(defvar exec-delay nil)
(defvar callback-fn-keyboard-key
  (lambda (view time modifiers key sym state)
    (format out "Keyboard event view ~a time ~a key ~a sym ~a state ~a mod ~a~%"
	    view time key sym (ref-wlc-modifiers modifiers) state)
    (let ((bit (parse-mod-bit modifiers)))
      (cond ((/= 0 (logand bit 4)) ; ctrl
	     (cond (exec-delay (setf exec-delay nil)) ; prevent second press
		((= sym 101) ; #\e
		 (format out "trying weston~%")
		 (cl-exec "weston-terminal")
		 (setf exec-delay t) nil)
		((= sym #x71) ; #\q
		 (format out "closing view ~a~%" view)
		 (view-close view)
		 (setf exec-delay t) nil)
		((= sym #xff1b) ;#\Escape
		 (format out "terminating~%")
		 (wlc-terminate))
		(t 1)))
	    ((/= 0 (logand bit 8)) ; alt
	     (test-view-fns view sym)) ; test.lisp
	    (t t))))) ; key not handled return true
(defvar callback-fn-pointer-button
  (lambda (view time modifiers button state)
    (format out "pointer-button~%")
    (when (/= view 0)
      (view-focus view))
    1))

  (defvar callback-fn-pointer-scroll
  (lambda (view time modifiers axis amount)
    1))

(defvar callback-fn-pointer-motion (lambda (view time origin) 1))

(defvar callback-fn-touch-touch (lambda (view time modifiers type slot origin) 1))

(defvar callback-fn-compositor-ready (lambda ()))


(defcallback output-created bool
    ((output wlc-handle))
  (funcall callback-fn-output-created output))
  
(defcallback output-destroyed :void
  ((output wlc-handle))
  (funcall callback-fn-output-destroyed output))

(defcallback output-focus :void
  ((output wlc-handle)
   (focus bool))
  (funcall callback-fn-output-focus output focus))

(defcallback output-resolution :void
    ((output wlc-handle)
     (from (:pointer wlc-size))
     (to (:pointer wlc-size)))
    (funcall callback-fn-output-resolution output from to))

(defcallback view-created :int
  ((view wlc-handle))
  (funcall callback-fn-view-created view))
  
(defcallback view-focus :void
  ((view wlc-handle)
   (focus bool))
  (funcall callback-fn-view-focus view focus))
  
(defcallback view-destroyed :void
  ((view wlc-handle))
  (funcall callback-fn-view-destroyed))

(defcallback view-move-to-output :void
  ((view wlc-handle)
   (from wlc-handle)
   (to wlc-handle))
  (funcall callback-fn-view-move-to-output view from to))

(defcallback keyboard-key bool
    ((view wlc-handle)
     (time :uint32)
     (modifiers c-wlc-modifiers)
     (key :uint32)
     (sym :uint32)
     (state wlc-key-state))
    (funcall callback-fn-keyboard-key view time modifiers key sym state))

(defcallback pointer-button bool
  ((view wlc-handle)
   (time :uint32)
   (modifiers c-wlc-modifiers)
   (button :uint32)
   (state wlc-button-state))
  (funcall callback-fn-pointer-button view time modifiers button state))

(defcallback pointer-scroll bool
  ((view wlc-handle)
   (time uint32-t)
   (modifiers c-wlc-modifiers)
   (axis uint8-t)
   (amount :pointer))
  (funcall callback-fn-pointer-scroll view time modifiers axis amount))

(defcallback pointer-motion bool
  ((view wlc-handle)
   (time :uint32)
   (origin :pointer))
  (funcall callback-fn-pointer-motion view time origin))

(defcallback touch-touch bool
  ((view wlc-handle)
   (time uint32-t)
   (modifiers c-wlc-modifiers)
   (type wlc-touch-type)
   (slot int32-t)
   (origin c-wlc-origin))
  (funcall callback-fn-touch-touch view time modifiers type slot origin))

(defcallback compositor-ready :void
  ()
  (funcall callback-fn-compositor-ready))
