(in-package :cl-wlc)

(defun output-mask (output)
  (wlc-output-get-mask output))
(defun (setf output-mask) (mask output)
  (wlc-output-set-mask output mask))
(defun focused-output-mask ()
  (wlc-output-get-mask (focused-output)))

(defun (setf focused-output-mask) (mask)
  (setf (output-mask (focused-output)) mask))

(defun output-views (output)
  (let ((views)
	(m)
	(ret '()))
    (with-foreign-object (memb 'uint)
      (setf views (wlc-output-get-views output memb))
      (setf m (mem-aref memb 'uint)))
    (dotimes (x m)
      (push (ref-handle views x) ret))
    (reverse ret)))

(defun (setf output-views) (val output)
  (let ((len (length val)))
    (with-foreign-object (views 'wlc-handle len)
      (dotimes (x len)
	(setf (mem-aref views 'wlc-handle) (nth x val)))
      (wlc-output-set-views output views len))))

(defun focused-output ()
  (wlc-get-focused-output))
(defun get-outputs ()
  (let ((pt)
	(count)
	(ret '()))
    (with-foreign-object (memb 'uint)
      (setf pt (wlc-get-outputs memb))
      (setf count (mem-aref memb 'uint)))
    (dotimes (x count)
      (push (ref-handle pt x) ret))
					;(pt-handle pt x) ret))
    (reverse ret)))

(defun output-resolution (output)
  (cond ((zerop output) '(0 0))
	(t (let ((r (wlc-output-get-resolution output))
		 (w)
		 (h))
	     (setf w (struct-val r 'wlc-size 'w)
		   h (struct-val r 'wlc-size 'h))
	     (list w h)))))





(defun (setf output-resolution) (val output)
  (with-foreign-object (r 'wlc-size)
    (setf (ref-wlc-size r) val)
    (wlc-output-set-resolution output r)))

(defun output-focus (output)
  (wlc-output-focus output))


(defun output-views-masked (output)
  (let ((ret '())
	(views (output-views output))
	(o-mask (output-mask output)))
    (dolist (view views)
      (if (= o-mask (view-mask view))
	  (push view ret)))
    (reverse ret)))

