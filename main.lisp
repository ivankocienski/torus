
(ql:quickload :cl-glfw3)
(ql:quickload :cl-opengl)
(ql:quickload :cl-glu)

(defpackage :taurus-demo
  (:use :cl :glfw :opengl :glu))

(in-package :taurus-demo)

(defconstant +XRES+ 800)
(defconstant +YRES+ 600)

;; TODO: fewer magic numbers
;;(defconstant +TORUS-CIRCUMFRANCE+STEPS+ 30)
;;(defconstant +TORUS-BODY-WIDTH-STEPS+ 10)

(defparameter *rotation* 0.0)
(defparameter *point-grid* (make-array '(10 30)))

(defstruct vec3 x y z)

(defun render ()
  (gl:clear :color-buffer)
  (gl:load-identity)

  (glu:look-at
   0 0.5 -10  ;; eye
   0 0.5 0  ;; center
   0 1.5 0) ;; up

  (incf *rotation* 0.1)

  (gl:translate 0 0 10)
  (gl:rotate *rotation* 0 0.2 0.1)
  
  (gl:color 1 1 1)

  (dotimes (i 10)
    (dotimes (j 30)
      (gl:with-primitive :line-loop

	(let* ((i2 (mod (+ i 1) 10))
	       (j2 (mod (+ j 1) 30))
	       (p1 (aref *point-grid* i  j ))
	       (p2 (aref *point-grid* i2 j ))
	       (p3 (aref *point-grid* i2 j2))
	       (p4 (aref *point-grid* i  j2)))

	  (gl:vertex (vec3-x p1) (vec3-y p1) (vec3-z p1))
	  (gl:vertex (vec3-x p2) (vec3-y p2) (vec3-z p2))
	  (gl:vertex (vec3-x p3) (vec3-y p3) (vec3-z p3))
	  (gl:vertex (vec3-x p4) (vec3-y p4) (vec3-z p4))))))
	

  )
  
  
(defun init ()
  '( (documentation . "intialize things") (line . 42) (filepath . "..."))
  (gl:clear-color 0 0 0 1)
  (gl:viewport 0 0 +XRES+ +YRES+)
  
  (gl:matrix-mode :projection)
  (gl:load-identity)
  (glu:perspective 45  (/ +XRES+ +YRES+) 0.5 30)
  
  (gl:matrix-mode :modelview)
  (gl:load-identity)
  
  (dotimes (i 10)
    (let* ((outer-angle (* (/ i 10.0) (* pi 2)))
	   (xo (* 2 (cos outer-angle)))
	   (yo (* 2 (sin outer-angle))))
    
      (dotimes (j 30)
	(let* ((inner-angle (* (/ j 30.0) (* pi 2)))
	       (px (* (+ 5 xo) (cos inner-angle)))
	       (py (* (+ 5 xo) (sin inner-angle))))

	  (setf (aref *point-grid* i j) (make-vec3 :x px :y yo :z py))))))

  
  )

(defun main ()
  (with-init-window (:title "GL Window" :width +XRES+ :height +YRES+)
    
    (init)
    
    (loop until (window-should-close-p)
       do (render)
       do (swap-buffers)
       do (poll-events))))
