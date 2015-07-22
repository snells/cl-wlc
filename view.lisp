(in-package :cl-wlc)

(defun view-geometry (view)
  (ref-wlc-geometry (wlc-view-get-geometry view)))

(defun (setf view-geometry) (val view)
  (with-foreign-object (g 'wlc-geometry)
    (setf (ref-wlc-geometry g) val)
    (wlc-view-set-geometry view g)))

(defun view-mask (view)
  (wlc-view-get-mask view))
(defun (setf view-mask) (mask view)
  (wlc-view-set-mask view mask))

(defun view-state (view)
  (wlc-view-get-state view))
(defun view-set-state (view state toggle)
  (wlc-view-set-state view state toggle))

(defun view-type (view)
  (wlc-view-get-type view))
(defun view-set-type (view type toggle)
  (wlc-view-set-type view type toggle))

(defun view-output (view)
  (wlc-view-get-output view))
(defun (setf view-output) (val view)
  (wlc-view-set-output view val))

(defun view-parent (view)
  (wlc-view-get-parent view))
(defun (setf view-parent) (parent view)
  (wlc-view-set-parent view parent))
(defun view-close (view)
  (if (not (zerop view))
      (wlc-view-close view)))
(defun view-focus (view)
  (wlc-view-focus view))

(defun managedp (view)
  (let ((type (view-type view)))
    (if (or (zerop (logand type +bit-unmanaged+))
	    (zerop (logand type +bit-popup+))
	    (zerop (logand type +bit-splash+)))
	nil t)))
(defun override-redirectp (view)
  (if (zerop (logand (view-type view) +bit-override+)) nil t))


(defun zero-andp (&rest numbers)
  (if (zerop (apply #'logand numbers)) t nil))
(defun test-view-state (view state)
  (if (zero-andp (view-state view) state) nil t))
(defun test-view-type (view type)
  (if (zero-andp (view-type view) type) nil t))
(defun view-fullscreenp (view)
  (test-view-state view +state-fullscreen+))
(defun view-splashp (view)
  (test-view-type view +bit-splash+))

(defun view-bring-to-front (view)
  (wlc-view-bring-to-front view))

(defun view-bring-above (view other)
  (wlc-view-bring-above view other))

(defun view-send-below (view other)
  (wlc-view-send-below view other))

(defun view-send-to-back (view other)
  (wlc-view-send-to-back view other))

(defun view-title (view)
  (wlc-view-get-title view))
(defun (setf view-title) (name view)
  (wlc-view-set-title view name))

(defun view-id (view)
  (wlc-view-get-app-id view))
(defun (setf view-id) (id view)
  (wlc-view-set-app-id view id))












