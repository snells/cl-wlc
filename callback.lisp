(in-package :cl-wlc)


;;; callbacks that return type bool should return lisp boolean t or nil, number 0 is considered true


(defvar callback-output-created
  (lambda (output)
    (format out "output created~a~%" output) 1))
(defvar callback-output-destroyed
  (lambda (output)
    (format out "output destroyed ~a~%" output)))
(defvar callback-output-focus
  (lambda (output focus)
    (format out "output focus~%")))
(defvar callback-output-resolution
  (lambda (output size-from size-to)
    (format out "output resolution~%")))

(defvar callback-view-created
  (lambda (view)
    (format out "view created~a~%" view)
    (view-set-state view +activated+ t)
    (view-set-state view +fullscreen+ t)
    (format out "geometry ~a ~a~%" (wlc-view-get-geometry view)
	    (ref-wlc-geometry (wlc-view-get-geometry view)))
    (view-bring-to-front view)
    (view-focus view) 1))
  
(defvar callback-view-destroyed
  (lambda (view)
    (format out "view-destroyed~a~%" view)))

(defvar callback-view-focus
  (lambda (view focus)
    (format out "view-focus~a geo ~a~%" view (view-geometry view))
    (view-set-state view +activated+ t)
    (view-bring-to-front view)
    (view-focus view) 1))

(defvar callback-view-move-to-output
  (lambda (view output-from output-to)
    (format out "view ~a moved from ~a to ~a~%" view from to)))

;;; shift 1 caps 2 ctrl 4 alt 8 mod2 16 mod3 32 log0 64 mod5 128
;;; for some reason every key press and mouse button press is
;;; received 2 times
;;; we use exec-delay to prevent the second press
(defvar exec-delay nil)
(defvar callback-keyboard-key
  (lambda (view time modifiers key sym state)
    (format out "Keyboard event view ~a time ~a key ~a sym ~a state ~a mod ~a~%"
	    view time key sym state (ref-wlc-modifiers modifiers))
    (let ((bit (parse-mod-bit modifiers)))
      (cond ((/= 0 (logand bit 4)) ; ctrl
	     (cond (exec-delay (setf exec-delay nil)) ; prevent second press
		((= sym 101) ; #\e
		 (format out "trying weston~%")
		 (cl-exec "weston-terminal")
		 (setf exec-delay t) nil)
		((= sym #x31) ;#\1
		 (view-focus (get-topmost-view (view-output view))))
		((= sym #x32)
		 (format out "all views ~a~%" (output-views (focused-output))))
		((= sym #x71) ; #\q
		 (let ((output (view-output view)))
		   (format out "closing view ~a~%" view)
		   (view-close view)
		   (focus-view (get-topmost-view output))
		   (setf exec-delay t) nil))
		((= sym #xff1b) ;#\Escape
		 (format out "terminating~%")
		 (wlc-terminate))
		(t t)))
	    ((/= 0 (logand bit 8)) ; alt
	     (test-view-fns view sym)) ; test.lisp
	    (t t))))) ; key not handled return true
(defvar callback-pointer-button
  (lambda (view time modifiers button state)
    (format out "pointer-button~%")
    (when (/= view 0)
      (view-set-state view +activated+ t)
      (view-focus view)
      (view-bring-to-front view))					
    1))

  (defvar callback-pointer-scroll
  (lambda (view time modifiers axis amount)
    1))

(defvar callback-pointer-motion (lambda (view time origin) 1))

(defvar callback-touch-touch (lambda (view time modifiers type slot origin) 1))

(defvar callback-compositor-ready (lambda ()))


(defcallback output-created bool
    ((output wlc-handle))
  (funcall callback-output-created output))
  
(defcallback output-destroyed :void
  ((output wlc-handle))
  (funcall callback-output-destroyed output))

(defcallback output-focus :void
  ((output wlc-handle)
   (focus bool))
  (funcall callback-output-focus output focus))

(defcallback output-resolution :void
    ((output wlc-handle)
     (from (:pointer wlc-size))
     (to (:pointer wlc-size)))
    (funcall callback-output-resolution output from to))

(defcallback view-created bool
    ((view wlc-handle))
  (funcall callback-view-created view))
  
(defcallback view-focus :void
  ((view wlc-handle)
   (focus bool))
  (funcall callback-view-focus view focus))
  
(defcallback view-destroyed :void
  ((view wlc-handle))
  (funcall callback-view-destroyed view))

(defcallback view-move-to-output :void
  ((view wlc-handle)
   (from wlc-handle)
   (to wlc-handle))
  (funcall callback-view-move-to-output view from to))

(defcallback keyboard-key bool
    ((view wlc-handle)
     (time u32)
     (modifiers (:pointer wlc-modifiers))
     (key u32)
     (sym u32)
     (state wlc-key-state))
    (funcall callback-keyboard-key view time modifiers key sym state))

(defcallback pointer-button bool
  ((view wlc-handle)
   (time u32)
   (modifiers (:pointer wlc-modifiers))
   (button u32)
   (state wlc-button-state))
  (funcall callback-pointer-button view time modifiers button state))

(defcallback pointer-scroll bool
  ((view wlc-handle)
   (time u32)
   (modifiers (:pointer wlc-modifiers))
   (axis u8)
   (amount :pointer))
  (funcall callback-pointer-scroll view time modifiers axis amount))

(defcallback pointer-motion bool
  ((view wlc-handle)
   (time u32)
   (origin :pointer))
  (funcall callback-pointer-motion view time origin))

(defcallback touch-touch bool
  ((view wlc-handle)
   (time u32)
   (modifiers (:pointer wlc-modifiers))
   (type wlc-touch-type)
   (slot int32)
   (origin (:pointer wlc-origin)))
  (funcall callback-touch-touch view time modifiers type slot origin))

(defcallback compositor-ready :void
  ()
  (funcall callback-compositor-ready))

