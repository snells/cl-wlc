# cl-wlc
Common lisp bindings to [wlc](https://github.com/Cloudef/wlc) for making wayland window managers.


cl-wlc provides bare but lispy api to wlc.   
All the functions from wlc.h have been translated and most of them work.  
I didn't have success with cffi's translate methods so some callback functions take pointer as parameter but there are functions to get lispy value from them.   
Currently cl-wlc is unstable and might crash when executed.   


### Dependencies


Build tools for wlc, see https://github.com/Cloudef/wlc   
[quicklisp](https://www.quicklisp.org/beta/)   
cffi and libcffi   

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


##### Outputs   
views list of views   
mask int   
resolution list of ints (width height)   
##### Views   
mask int   
type int, \*bit-override\* \*bit-unmanaged\* \*bit-splash\* \*bit-modal\* \*bit-popup\*  
state int, \*state-maximized\* \*state-fullscreen\* \*state-resizing\* \*state-moving\* \*state-activated\*  
currently callbacks that take parameter state receive keyword :pressed or :released.   
parent view   
output   output  
title string   
id   string   
geometry list of origin and size   
##### Origin   
list of ints (x y)   
##### Size   
list of ints (w h) 
calbacks that take size as parameter receive pointer, you can use function (ref-wlc-size size) => (w h)   
##### Modifiers   
c-struct that has byte mods and byte leds.   
mods, shift 1 caps 2 ctrl 4 alt 8 mod2 16 mod3 32 log0 64 mod5 128    
Not sure what the different leds values mean.   
keyboard-key and pointer-button callbacks have argument of type modifiers.   
Currently modifiers is pointer, you can use fuction (ref-wlc-modifiers modifiers) => (mods leds) ; where mods and leds are ints.   
##### Focus   
lisp boolean   


### Usage   
Currently running cl-wlc from slime might be more unstable.   

```
(use-package :cl-wlc)
(run-wm '("my-wm-name" "--log" "/home/log"))
;;; starts the wm
;;; there is also more simplified function for testing purposes
(bare-wm)
;;;start the wm

;prototype
(run-wm (argv &key view-created view-destroyed view-focus
                      view-move-to-output
                      output-created output-destroyed output-focus
                      output-resolution keyboard-key pointer-button
                      pointer-scroll pointer-motion touch compositor-ready))
```

argv is list of strings that will be given to wlc.   
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
In the original the interface struct are not typedef'ed  and I had to typedef them to get something working.   
Can't remember if grovel couldn't be used without c struct being typedefined or was it for something else.      
void wlc_exec(const char *bin, char *const args[]);   
Coudln't get it work so I defined new function   
void cl_exec(char \*bin) { wlc_exec(bin, (char *const[]) { bin, NULL }); }   
That's easier to translate with cffi.     
When I tried allocating wlc-interface in lisp I couldn't get it to run.   
So I made new function bare_s_interface which returns pointer to wlc_interface.   
There might be no need for bare_s_interface after I started using grovel but I think it's more stable when using bare_s_interface instead of allocating wlc-interface in lisp.   


### Issues   

(view-title view) will crash.   
Crashes sometimes on start, no idea why.   
When wlc is running and there is error the lisp won't go to debugger, instead it will just crash.   
So any typo, type error, whatever that passes compiler will most likely cause crash somewhere.

