(in-package :cl-wlc)



;defines setf-able getters for types in list
(unless (fboundp 'ref-int)
  (def-pts-from-list (:int :short :double :float :char)))


(defctype wlc-interface (:struct c-wlc-interface))
(defctype wlc-size (:struct c-wlc-size))
(defctype wlc-modifiers (:struct c-wlc-modifiers))
(defctype wlc-geometry (:struct c-wlc-geometry))
(defctype wlc-origin (:struct c-wlc-origin))


(defctype interface-output (:struct wlc-interface-output))
(defctype interface-view (:struct wlc-interface-view))
(defctype interface-keyboard (:struct wlc-interface-keyboard))
(defctype interface-pointer (:struct wlc-interface-pointer))
(defctype interface-touch (:struct wlc-interface-touch))
(defctype interface-compositor (:struct wlc-interface-compositor))
