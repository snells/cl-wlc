(in-package :cl-wlc)

(defun view-geometry (view)
  (ref-wlc-geometry (wlc-view-get-geometry view)))

(defun (setf view-geometry) (val view)
  ;(with-foreign-object (g 'wlc-geometry)
  (let ((g (wlc-view-get-geometry view)))
    (setf (ref-wlc-geometry g) val)
    (wlc-view-set-geometry view 0 g)))

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
    (if (or (zerop (logand type +unmanaged+))
	    (zerop (logand type +popup+))
	    (zerop (logand type +splash+)))
	nil t)))
(defun override-redirectp (view)
  (if (zerop (logand (view-type view) +override+)) nil t))


(defun zero-andp (&rest numbers)
  (if (zerop (apply #'logand numbers)) t nil))
(defun test-view-state (view state)
  (if (zero-andp (view-state view) state) nil t))
(defun test-view-type (view type)
  (if (zero-andp (view-type view) type) nil t))
(defun view-fullscreenp (view)
  (test-view-state view +fullscreen+))
(defun view-splashp (view)
  (test-view-type view +splash+))

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

(defun focus-view (view)
  (cond ((zerop view) (view-focus 0))
	(t 
	 (view-set-state view +activated+ t)
	 (view-bring-to-front view)
	 (view-focus view))))

(defun get-next-view (view)
  (let ((views (output-views-masked (view-output view)))
	(b view)
	(s view))
    (cond ((null views) 0)
	  (t (dolist (v views)
	       (cond ((< v s) (setf s v))
		     ((and (> v view) (< v b))
		      (setf b v))
		     ((and (= b view) (> v b))
		      (setf b v))))
		    (if (> b view) b s)))))


		 
	   
(defun get-previous-view (view)
  (let ((views (output-views-masked (view-output view)))
	(b view)
	(s view))
    (cond ((null views) 0)
	  (t (dolist (v views)
	       (cond ((> v b) (setf b v))
		     ((and (< v view) (> v s))
		      (setf s v))
		     ((and (= s view) (< v s))
		      (setf s v))))
	     (if (< s view) s b)))))

(defun get-topmost-view (output)
  (let ((v (car (output-views-masked output))))
    (if (null v) 0 v)))
