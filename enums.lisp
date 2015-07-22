(in-package :cl-wlc)
(defcenum wlc-view-ack
  :ack-none
  :ack-pending
  :ack-net-commit)
(defcenum log-type
  :log-info 
  :log-warn
  :log-error)
(defcenum view-state-bit
  (:maximized 1)
  (:fullscreen 2)
  (:resizing 4)
  (:moving 8)
  (:activated 16))

(defcenum view-type-bit
  (:bit-override-redirect 1)
  (:bit-unmanaged 2)
  (:bit-splash 4)
  (:bit-modal 8)
  (:bit-poput 16))

(defvar enum-to-constant-list
  '(((ack-none)
     (ack-pending)
     (ack-net-commit))
    ((log-info)
     (log-warn)
     (log-error))
    ((state-maximized . 1)
     (state-fullscreen . 2)
     (state-resizing . 4)
     (state-moving . 8)
     (state-activated . 16))
    ((bit-override . 1)
     (bit-unmanaged . 2)
     (bit-splash . 4)
     (bit-modal . 8)
     (bit-popup . 16))
    ((key-released)
     (key-pressed))
    ((button-released)
     (button-pressed))))
     
(unless (boundp (intern (format nil "+~a+"
				(caaar enum-to-constant-list))))
  (dolist (lst enum-to-constant-list)
    (let ((i 0))
      (dolist (x lst)
	(let ((symb (intern (format nil "+~a+" (car x))))
	      (val (if (cdr x) (cdr x) i)))
	  (eval `(defvar ,symb ,val))
	  (incf i))))))



(defcenum modifier-bit
	      (:bit-mod-shift 1)
	      (:bit-mod-caps 2)
	      (:bit-mod-ctrl 4)
	      (:bit-mod-alt  8)
	      (:bit-mod-mod2 16)
	      (:bit-mod-mod3 32)
	      (:bit-mod-logo 64)
	      (:bit-mod-mod5 128))

(defcenum button-state
  (:button-state-released 0)
  (:button-state-pressed 1))

(defcenum key-state
  :key-state-released
  :key-state-pressed)

(defcenum scroll-axis-bit
  (:scroll-axis-vertical 1)
  (:scroll-axis-horizontal 2))


    
