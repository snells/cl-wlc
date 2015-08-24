;(cl:eval-when (:load-toplevel :execute)
;  (asdf:operate 'asdf:load-op 'cffi-grovel))
(asdf:defsystem #:cl-wlc
  :serial t
  :description "Bindings for wlc library"
  :author "Sakari Snäll stesna@utu.fi"
  :license "The MIT License (MIT)"
  :depends-on (#:cffi #:bordeaux-threads)
  :components ((:file "package")
	       (:file "util")
	       (:file "c-util")
	       (:file "enums")
	       (:file "struct")
	       ;(cffi-grovel:grovel-file "grovel")
	       (:file "types")
	       (:file "c-fns")
	       (:file "lispy")
	       (:file "output")
	       (:file "view")
	       ;(:file "test")	       
	       (:file "callback")
	       (:file "cl-wlc")))

