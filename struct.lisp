(in-package :cl-wlc)

(defctype wlc-handle :uintptr)
(defctype u32 :uint32)
(defctype int32 :int32)
(defctype u8 :uint8)
(defctype uint :uint)

(defcstruct wlc-interface-output
  (created :pointer)
  (destroyed :pointer)
  (focus :pointer)
  (resolution :pointer))

(defcstruct wlc-interface-view-request
  (geometry :pointer)
  (state :pointer)
  (move :pointer)
  (resize :pointer))

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



(defcstruct c-wlc-interface
  (output (:struct wlc-interface-output))
  (view (:struct wlc-interface-view))
  (keyboard (:struct wlc-interface-keyboard))
  (pointer (:struct wlc-interface-pointer))
  (touch (:struct wlc-interface-touch))
  (compositor (:struct wlc-interface-compositor)))

(defctype wlc-interface (:struct c-wlc-interface))

(defcstruct c-wlc-size
  (w u32)
  (h u32))
(defctype wlc-size (:struct c-wlc-size))

(defcstruct c-wlc-origin
  (x u32)
  (y u32))
(defctype wlc-origin (:struct c-wlc-origin))

(defcstruct c-wlc-geometry
  (origin wlc-origin)
  (size wlc-size))
(defctype wlc-geometry (:struct c-wlc-geometry))

(defcstruct c-wlc-modifiers
  (leds u32)
  (mods u32))
(defctype wlc-modifiers (:struct c-wlc-modifiers))


