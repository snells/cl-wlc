(in-package :cl-wlc)

(defcstruct wlc-interface-output
  (created :pointer)
  (destroyed :pointer)
  (focus :pointer)
  (resolution :pointer))

(defcstruct wlc-interface-view-request
  (geometry :pointer)
  (state :pointer))

(defcstruct wlc-interface-view
  (created :pointer)
  (destroyed :pointer)
  (focus :pointer)
  (move-to-output :pointer)
  (request (:struct wlc-interface-view-request)))

(defcstruct wlc-interface-keyboard
  (key :pointer))

(defcstruct wlc-interface-pointer
  (button :pointer)
  (scroll :pointer)
  (motion :pointer))

(defcstruct wlc-interface-touch
    (touch :pointer))

(defcstruct wlc-interface-compositor
    (ready :pointer))

;(defcstruct wlc-interface
; (output wlc-interface-output)
; (view wlc-interface-view)
; (keyboard wlc-interface-keyboard)
; (pointer wlc-interface-pointer)
; (touch wlc-interface-touch)
; (compositor wlc-interface-compositor))

