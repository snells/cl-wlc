(in-package :cl-wlc)
(defcenum wlc-view-ack
  :ack-none
  :ack-pending
  :ack-net-commit)
(defcenum wlc-log-type
  :log-info 
  :log-warn
  :log-error)
(defcenum wlc-view-state
  (:maximized 1)
  (:fullscreen 2)
  (:resizing 4)
  (:moving 8)
  (:activated 16))

(defcenum wlc-view-type
  (:override-redirect 1)
  (:unmanaged 2)
  (:splash 4)
  (:modal 8)
  (:poput 16))

(defcenum modifier-bit
	      (:mod-shift 1)
	      (:mod-caps 2)
	      (:mod-ctrl 4)
	      (:mod-alt  8)
	      (:mod-mod2 16)
	      (:mod-mod3 32)
	      (:mod-logo 64)
	      (:mod-mod5 128))

(defcenum wlc-button-state
  (:released 0)
  (:pressed 1))

(defcenum wlc-touch-type
  :down
  :up
  :motion
  :frame
  :cancel)

(defcenum wlc-key-state
  :released
  :pressed)

(defcenum wlc-scroll-axis
  (:vertical 1)
  (:horizontal 2))




(defvar enum-to-constant-list
  '(((ack-none)
     (ack-pending)
     (ack-net-commit))
    ((log-info)
     (log-warn)
     (log-error))
    ((maximized . 1)
     (fullscreen . 2)
     (resizing . 4)
     (moving . 8)
     (activated . 16))
    ((override . 1)
     (unmanaged . 2)
     (splash . 4)
     (modal . 8)
     (popup . 16))
    ((released)
     (pressed))
    ((mod-shift . 1)
     (mod-caps . 2)
     (mod-ctrl . 4)
     (mod-alt . 8)
     (mod-mod2 . 16)
     (mod-mod3 . 32)
     (mod-logo . 64)
     (mod-mod5 . 128))))
    
(unless (boundp (intern (format nil "+~a+"
				(caaar enum-to-constant-list))))
  (dolist (lst enum-to-constant-list)
    (let ((i 0))
      (dolist (x lst)
	(let ((symb (intern (format nil "+~a+" (car x))))
	      (val (if (cdr x) (cdr x) i)))
	  (eval `(defvar ,symb ,val))
	  (incf i))))))





    
