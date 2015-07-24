(in-package :cl-wlc)

(defcfun "wlc_get_log_file" :pointer
  (out :pointer))
(defcfun "wlc_set_log_file" :void
  (out :pointer))

(defcfun "wlc_output_get_pixels" :void
  (output wlc-handle)
  (pixels :pointer)
  (arg :pointer))

(defcfun "wlc_view_bring_to_front"  :void
  (view wlc-handle));wlc-handle))

(defcfun "wlc_view_bring_above" :void
  (view wlc-handle)
  (other wlc-handle))

(defcfun "wlc_view_send_below" :void
  (view wlc-handle)
  (other wlc-handle))

(defcfun "wlc_view_send_to_back" :void
  (view wlc-handle))

(defcfun "wlc_output_get_views" :pointer ;(:pointer wlc-handle)
  (output wlc-handle)
  (memb :pointer))


(cffi:defcfun "wlc_view_set_state"  :void
  (view wlc-handle)
  (state wlc-view-state)
  (toggle bool))

(cffi:defcfun "wlc_view_focus" :void
  (view (:pointer wlc-handle)))

;(defcfun ("wlc_interface" get-wlc-interface) :pointer)

(defcfun ("wlc_log" c-wlc-log) :void
  (type wlc-log-type)
  (fmt :pointer))

(defcfun ("wlc_exec" c-wlc-exec) :void
  (bin :string);:pointer)
  (argv :pointer))
					;(args :pointer))
(defcfun "cl_exec" :void
  (bin :string))
(defcfun "bare_s_interface" :pointer)
(defcfun "exec_term" :void)
(defcfun "wlc_terminate" :void)
(defcfun "wlc_view_close" :void
  (view wlc-handle))

(defcfun "wlc_init" :int
  (interface :pointer)
  (argc :int)
  (argv :pointer))


(defcfun "wlc_run" :void)
(defcfun "exec_term" :void)

(defcfun "wlc_handle_set_user_data" :void
  (handle wlc-handle)
  (userdata :pointer))
(defcfun "wlc_handle_get_user_data" :pointer
  (handle wlc-handle))
(defcfun "wlc_get_outputs" :pointer
  (out-memb :pointer))
(defcfun "wlc_get_focused_output" wlc-handle)
(defcfun "wlc_output_get_resolution" :pointer
  (output wlc-handle))
(defcfun "wlc_output_set_resolution" :void
  (output wlc-handle)
  (resolution (:pointer wlc-size)))
(defcfun "wlc_output_get_mask" u32
  (output wlc-handle))
(defcfun "wlc_output_set_mask" :void
  (output wlc-handle)
  (mask u32))
(defcfun "wlc_output_set_views" bool
  (output wlc-handle)
  (views :pointer)
  (memb uint)) ;;; size_t, should it be 8 bytes?
(defcfun "wlc_output_focus" :void
  (output wlc-handle))

(defcfun "wlc_view_focus" :void
  (view wlc-handle))
(defcfun "wlc_view_get_output" wlc-handle
  (view wlc-handle))
(defcfun "wlc_view_set_output" :void
  (view wlc-handle)
  (output wlc-handle))
(defcfun "wlc_view_send_to_back" :void
  (view wlc-handle))
(defcfun "wlc_view_send_below" :void
  (view wlc-handle)
  (other wlc-handle))
(defcfun "wlc_view_get_mask" u32
  (view wlc-handle))
(defcfun "wlc_view_set_mask" :void
  (view wlc-handle)
  (mask u32))
(defcfun "wlc_view_get_state" u32
  (view wlc-handle))
(defcfun "wlc_view_set_state" :void
  (view wlc-handle)
  (type wlc-view-state)
  (toggle bool))
(defcfun "wlc_view_get_geometry" :pointer
  (view wlc-handle))
(defcfun "wlc_view_set_geometry" :void
  (view wlc-handle)
  (geometry :pointer))
(defcfun "wlc_view_get_parent" wlc-handle
  (view wlc-handle))
(defcfun "wlc_view_get_type" u32
  (view wlc-handle))
(defcfun "wlc_view_set_type" :void
  (view wlc-handle)
  (type wlc-view-type)
  (toggle bool))

(defcfun "wlc_view_set_parent" :void
  (view wlc-handle)
  (parent wlc-handle))

(defcfun "wlc_view_get_title" :string
  (view wlc-handle))
(defcfun "wlc_view_set_title" :void
  (view wlc-handle)
  (title :string))

(defcfun "wlc_view_get_class" :string
  (view wlc-handle))
(defcfun "wlc_view_set_class" bool
  (view wlc-handle)
  (class :string))

(defcfun "wlc_view_get_app_id" :string
  (view wlc-handle))
(defcfun "wlc_view_set_app_id" bool
  (view wlc-handle)
  (app-id :string))


