# cl-wlc
Common lisp bindings to [wlc](https://github.com/Cloudef/wlc) for making wayland window managers.        


Currently cl-wlc only works properly with ecl.   
It can run on sbcl and ccl but they are more unstable and after you exit the wm you will get errors.   


cl-wlc provides bare but lispy api to wlc.   
All the functions from wlc.h have been translated and most of them work.  
I didn't have success with cffi's translate methods so some callback functions take pointer as parameter but there are functions to get lispy value from them.   


### Dependencies


Build tools for wlc, see https://github.com/Cloudef/wlc   
[quicklisp](https://www.quicklisp.org/beta/)   
cffi    

### Install

cd to your quicklisp local-project directory   
git clone https://github.com/snells/cl-wlc   
cd cl-wlc   
git submodule update --init --recursive   
cd wlc && mkdir target && cd target && cmake .. && make && sudo make install   
now you should be able to succesfully load cl-wlc from your lisp with (ql:quickload :cl-wlc)   


### How it works


You should study [orbment](https://github.com/Cloudef/orbment) to get idea how to really use wlc.  
I'm still learning so this might misguiding and completely wrong.   


Outputs are workspaces, screens or something like that.   
Views are windows and are inside outputs.   
Outputs and views are ctype wlc-handle which is just unsigned integer.   
view/output is bigger than zero and 0 is used for no view/output.   
(view-focus 3) => focuses view 3, (view-focus 0) => no focus.   
There are functions to set focus on different outputs but that does not seems to do anything.   
Outputs and and views have masks which you can use to implement different workspaces.   


### Types   
##### type-name type   
attribute attribute-type - more info


##### Output uint   
views list of views   
mask int   
resolution list of ints (width height)   
##### View int   
mask int   
type int, \*override\* \*unmanaged\* \*splash\* \*modal\* \*popup\*  
state int, \*maximized\* \*fullscreen\* \*resizing\* \*moving\* \*activated\*  
parent view   
output output  
title string   
id   string   
geometry list of origin and size   
##### Origin list   
x int   
y int   
##### Size list   
int w   
int h   
calbacks that take size as parameter receive pointer, you can use function (ref-wlc-size size) => (w h)   
##### Modifiers pointer   
c-struct that has byte mods and byte leds.   
mods, shift 1 caps 2 ctrl 4 alt 8 mod2 16 mod3 32 log0 64 mod5 128    
Not sure what the different leds values mean.   
keyboard-key and pointer-button callbacks have argument of type modifiers.   
Currently modifiers is pointer, you can use fuction (ref-wlc-modifiers modifiers) => (mods leds) ; where mods and leds are ints.   
##### Focus lisp-boolean   


### Usage   

```
(use-package :cl-wlc)
(run-wm '("my-wm-name" "--log" "/home/log"))
;;; starts the wm
;;; Cotrol + Esc - quit   
;;; C-f - start weston-terminal   
;;; there is also more simplified function for testing purposes
(bare-wm)
;;;start the wm

;prototype
(run-wm (argv &key threaded view-created view-destroyed view-focus
                      view-move-to-output
                      output-created output-destroyed output-focus
                      output-resolution keyboard-key pointer-button
                      pointer-scroll pointer-motion touch compositor-ready))
```


If key parameters functions are provided they will set callback variables, otherwise they use the default placeholder function.   
Callback variables are named cl-wlc:callback-function-name    
For example cl-wlc:callback-view-created   
To redefine callback function you need setf the value of callback variable to the new function.   
```
; when running on differend thread standard output might not be the output you want
(defvar out *standard-output*)
(use-package :cl-wlc)
(defun my-view-created (view)
  (format out "view created~%")
  t)
(run-wm '("dummy") :threaded t :view-created #'my-view-created)

; redefine our function
(defun my-view-created (view)
  (format out "updated fn~%")
  t))
; let the wm use our updated function
(setf callback-view-created #'my-view-created)
```   


argv is list of strings that will be given to wlc.  
By default threaded is nil, when true the wm will be run on it's own thread.   
You should pass a function to key arguments.   
Prototypes for the callback functions, see callback.lisp   
modifiers, size, origin, amount = pointers   
get lispy value from pointers with (ref-wlc-type pointer)   
state is key-value :pressed or :released      
output-created (lambda (output))  => lisp-boolean (t nil)   
output-destroyed (lambda (output)) => void   
output-focus (lambda (output focus)) => void   
output-resolution (lambda (output size-from size-to)) => void   
view-created (lambda (view)) => lisp-boolean   
view-destroyed (lambda (view)) => void   
view-focus (lambda (view focus)) => void   
view-move-to-output (lambda (view output-from output-to)) => void   
keyboard-key (lambda (view time modifiers key sym state)) => lisp-boolean   
pointer-button (lambda (view time modifiers button state)) => lisp-boolean   
pointer-scroll (lambda (view time modifiers axis amount)) => lisp-boolean   
pointer-motion (lambda (view time origin)) => lisp-boolean   
touch-touch (lambda (view time modifiers type slot origin)) => lisp-boolean    
compositor-ready (lambda ()) => void   


### Modifications to original wlc

I had to modify wlc a bit to get it work.   
void wlc_exec(const char *bin, char *const args[]);   
Coudln't get it work so I defined new function   
void cl_exec(char *bin) { wlc_exec(bin, (char *const[]) { bin, NULL }); }   
That's easier to translate with cffi.     
When I tried allocating wlc-interface in lisp I couldn't get it to run.   
So I made new function bare_s_interface which returns pointer to wlc_interface.   



### Issues   


Crashes sometimes on sbcl and ccl.   
Error while running wm will crash the lisp instead of going to debugger.

