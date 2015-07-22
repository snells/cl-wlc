(in-package :cl-wlc)
;(include "wlc.h")
(in-package :cl-wlc)
(include "sys/syscall.h")
(include "wlc/wlc.h")
(include "wlc/geometry.h")
(ctype size-t "size_t")

(ctype ssize-t "ssize_t")
(ctype intptr-t "intptr_t")
(ctype uintptr-t "uintptr_t")
(ctype uint8-t "uint8_t")
(ctype int32-t "int32_t")
(ctype uint32-t "uint32_t")
(ctype wlc-handle "uintptr_t")
(cstruct c-wlc-interface "struct wlc_interface"
  	 (output "output" :type (:struct wlc-interface-output))
  	 (view "view" :type (:struct wlc-interface-view))
  	 (keyboard "keyboard" :type (:struct wlc-interface-keyboard))
  	 (pointer "pointer" :type (:struct wlc-interface-pointer))
  	 (touch "touch" :type (:struct wlc-interface-touch))
  	 (compositor "compositor" :type (:struct wlc-interface-compositor)))

;(cstruct c-wlc-interface "struct wlc_interface"
;  	 (output "output" :type  wlc-interface-output)
;  	 (view "view" :type  wlc-interface-view)
;  	 (keyboard "keyboard" :type  wlc-interface-keyboard)
;  	 (pointer "pointer" :type  wlc-interface-pointer)
;  	 (touch "touch" :type  wlc-interface-touch)
;  	 (compositor "compositor" :type  wlc-interface-compositor))
;

(cstruct c-wlc-modifiers "struct wlc_modifiers"
	 (leds "leds" :type uint32-t)
	 (mods "mods" :type uint32-t))
(cstruct c-wlc-size "struct wlc_size"
	  (w "w" :type uint32-t)
	  (h "h" :type uint32-t))
(cstruct c-wlc-origin "struct wlc_origin"
	 (x "x" :type int32-t)
	 (y "y" :type int32-t))
(cstruct c-wlc-geometry "struct wlc_geometry"
	 (origin "origin" :type (:struct c-wlc-origin))
	 (size "size" :type (:struct c-wlc-size)))
	 
(cenum wlc-log-type
  	      ((:log-info "WLC_LOG_INFO"))
  	      ((:log-warn "WLC_LOG_WARN"))
  	      ((:log-error "WLC_LOG_ERROR")))
(cenum (wlc-view-state-bit :define-constants t)
       ((:maximized "WLC_BIT_MAXIMIZED"))
       ((:fullscreen "WLC_BIT_FULLSCREEN"))
       ((:resizing "WLC_BIT_RESIZING"))
       ((:moving "WLC_BIT_MOVING"))
       ((:activated "WLC_BIT_ACTIVATED")))
	      
;  
;  
(cenum (wlc-view-type-bit :define-constants t)
	      ((:bit-override-redirect "WLC_BIT_OVERRIDE_REDIRECT"))
  	      ((:bit-unmanaged "WLC_BIT_UNMANAGED"))
  	      ((:bit-splash "WLC_BIT_SPLASH"))
  	      ((:bit-modal "WLC_BIT_MODAL"))
  	      ((:bit-poput "WLC_BIT_POPUP")))
  
;(cenum (wlc-modifier-bit :define-constants t)
(cenum (wlc-modifier-bit :define-constants t)
       ((:bit-mod-shift "WLC_BIT_MOD_SHIFT"))
       ((:bit-mod-caps "WLC_BIT_MOD_CAPS"))
       ((:bit-mod-ctrl "WLC_BIT_MOD_CTRL"))
       ((:bit-mod-alt "WLC_BIT_MOD_ALT"))
       ((:bit-mod-mod2 "WLC_BIT_MOD_MOD2"))
       ((:bit-mod-mod3 "WLC_BIT_MOD_MOD3"))
       ((:bit-mod-logo "WLC_BIT_MOD_LOGO"))
       ((:bit-mod-mod5 "WLC_BIT_MOD_MOD5")))

(cenum wlc-button-state
  	      ((:button-state-released "WLC_BUTTON_STATE_RELEASED"))
  	      ((:button-state-pressed "WLC_BUTTON_STATE_PRESSED")))
;(constantenum key-state
;  	      ((:key-state-released "WLC_KEY_STATE_RELEASED"))
;  	      ((:key-state-pressed "WLC_KEY_STATE_PRESSED")))
(cenum wlc-key-state
       ((:released "WLC_KEY_STATE_RELEASED"))
       ((:pressed "WLC_KEY_STATE_PRESSED")))

(cenum wlc-touch-type
       ((:down "WLC_TOUCH_DOWN"))
       ((:up "WLC_TOUCH_UP"))
       ((:motion "WLC_TOUCH_MOTION"))
       ((:frame "WLC_TOUCH_FRAME"))
       ((:cancel "WLC_TOUCH_CANCEL")))
