;;;; package.lisp

(defpackage #:cl-wlc
  (:use #:cl #:cffi)
  (:export :run-wm
	   :bare-wm
	   
	   :output-views
	   :focused-output
	   :get-outputs
	   :output-mask
	   :focused-output-mask
	   :output-resolution
	   :output-focus
	   
	   :view-mask
	   :view-state
	   :view-set-state
	   :view-type
	   :view-output
	   :view-parent
	   :view-close
	   :view-focus
	   :view-bring-to-front
	   :view-bring-above
	   :view-send-below
	   :view-send-to-back
	   :view-geometry
	   :view-output
	   :view-title
	   :view-id
	   

	   :managedp
	   :override-redirectp
	   :test-view-state
	   :test-view-type
	   :view-fullscreenp
	   :view-splashp
	   :view-focus
	   

	   :ref-wlc-modifiers
	   :ref-wlc-size
	   :ref-wlc-origin
	   :ref-wlc-size
	   :ref-wlc-geometry
	   :view-geometry
	   :geometry-size
	   :geometry-origin

	   :exec-term
	   :exec
	   :c-wlc-exec))
	   

	   
	   
	   
	   
	   


(in-package :cl-wlc)
(define-foreign-library wlc
    (:unix (:or "libwlc.so.0" "libwlc.so"))
  (t (:default "libwlc")))
   
(use-foreign-library wlc)

(define-foreign-library wayland-util
    (:unix (:or "libwayland-server.so.0"
		"libwayland-server.so")))
(use-foreign-library wayland-util)



(defvar out *standard-output*)
(defvar *cl-wlc-debug* nil)
(defctype bool :boolean)
