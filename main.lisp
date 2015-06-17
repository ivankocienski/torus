
(ql:quickload :cl-glfw3)
(ql:quickload :cl-opengl)
(ql:quickload :cl-glu)

(defconstant +XRES+ 800)
(defconstant +YRES+ 600)
(defconstant +TOR-X-RES+ 30)
(defconstant +TOR-Y-RES+ 50)
(defconstant +BOX-SIZE+ 20)

(load "mixer-base.lisp")
(load "mixer-fadout.lisp")
(load "mixer-ring.lisp")
(load "mixer-hring.lisp")

(defpackage :taurus-demo
  (:use :cl :glfw :opengl :glu))

(in-package :taurus-demo)


;; TODO: fewer magic numbers

(defparameter *rotation* 0.0)
(defparameter *point-grid* (make-array (list +TOR-X-RES+ +TOR-Y-RES+)))
(defparameter *color-grid* (make-array (list +TOR-X-RES+ +TOR-Y-RES+)))
;;(defparameter *color-hold* 0)
(defparameter *mixer* nil)
(defparameter *mixer-hold* 0)

(defstruct vec3 x y z)

(defun reset-mixer ()
  (setf *mixer-hold* 0)
  (setf *mixer* nil))

(defun rainbow-vector (a)

  (let ((f (* (mod a 1/6) 6)))
    
    (cond
      ((< a 1/6)
       (make-vec3 ;red to yellow
	:x 1
	:y f
	:z 0)) 

      ((< a 2/6) ; yellow to green
       (make-vec3
	:x (- 1 f)
	:y 1
	:z 0))

      ((< a 3/6) ; green to blue
       (make-vec3
	:x 0
	:y 1
	:z f))

      ((< a 4/6) ; blue to purple
       (make-vec3
	:x 0
	:y (- 1 f)
	:z 1))

      ((< a 5/6) ; purple to red
       (make-vec3
	:x f
	:y 0
	:z 1))

      (T
       (make-vec3
	:x 1
	:y 0
	:z (- 1 f))))
    

    ))

(defun render ()
  (gl:clear :color-buffer :depth-buffer)
  (gl:load-identity)

  (glu:look-at
   0 0.5 -10  ;; eye
   0 0.5 0  ;; center
   0 1.5 0) ;; up

  (incf *rotation* 0.1)

  (gl:translate 0 0 10)

  (with-pushed-matrix
    (gl:rotate *rotation* 0 0.2 0.1)

    (if (> *mixer-hold* 0)
	(decf *mixer-hold*)
	(progn
	  (setf *mixer* (choose-random-mixer))
	  (mixer-activate *mixer*)
	  (setf *mixer-hold* (+ 100 (* 50 (random 5))))))

    (mixer-step *mixer*)

    (dotimes (i +TOR-X-RES+)
      (dotimes (j +TOR-Y-RES+)
	(gl:with-primitive :quads

	  (let ((c (aref *color-grid* i j)))
	    (gl:color (vec3-x c) (vec3-y c) (vec3-z c)))

	  (let* ((i2 (mod (+ i 1) +TOR-X-RES+))
		 (j2 (mod (+ j 1) +TOR-Y-RES+))
		 (p1 (aref *point-grid* i  j ))
		 (p2 (aref *point-grid* i2 j ))
		 (p3 (aref *point-grid* i2 j2))
		 (p4 (aref *point-grid* i  j2)))

	    (gl:vertex (vec3-x p1) (vec3-y p1) (vec3-z p1))
	    (gl:vertex (vec3-x p2) (vec3-y p2) (vec3-z p2))
	    (gl:vertex (vec3-x p3) (vec3-y p3) (vec3-z p3))
	    (gl:vertex (vec3-x p4) (vec3-y p4) (vec3-z p4)))))))

  (gl:color 0.4 0.4 0.4)
  
  (with-pushed-matrix
    (gl:rotate *rotation* 0.1 0.01 0.3)


    (loop for i from (- +BOX-SIZE+) to +BOX-SIZE+ by 5
       do 
	 (gl:with-primitive :lines

	  ;; top left->right
	  (gl:vertex (- +BOX-SIZE+) +BOX-SIZE+ i)	  (gl:vertex  +BOX-SIZE+ +BOX-SIZE+ i)

	  ;; bottom left->right
	  (gl:vertex (- +BOX-SIZE+) (- +BOX-SIZE+) i)	  (gl:vertex  +BOX-SIZE+ (- +BOX-SIZE+) i)

	  ;; front left->right
	  (gl:vertex (- +BOX-SIZE+) i (- +BOX-SIZE+))	  (gl:vertex  +BOX-SIZE+ i (- +BOX-SIZE+))

	  ;; back left->right
	  (gl:vertex (- +BOX-SIZE+) i +BOX-SIZE+)	  (gl:vertex  +BOX-SIZE+ i +BOX-SIZE+)

	  ;; left top->bottom
	  (gl:vertex (- +BOX-SIZE+)  +BOX-SIZE+ i)	  (gl:vertex (- +BOX-SIZE+) (- +BOX-SIZE+) i)

	  ;; right top->bottom
	  (gl:vertex +BOX-SIZE+  +BOX-SIZE+ i)	  (gl:vertex +BOX-SIZE+ (- +BOX-SIZE+) i)

	  ;; front top->bottom
	  (gl:vertex i (- +BOX-SIZE+) (- +BOX-SIZE+))	  (gl:vertex i  +BOX-SIZE+ (- +BOX-SIZE+))

	  ;; back top->bottom
	  (gl:vertex i (- +BOX-SIZE+) +BOX-SIZE+)	  (gl:vertex i  +BOX-SIZE+ +BOX-SIZE+)

	  ;; top front->back
	  (gl:vertex i +BOX-SIZE+  +BOX-SIZE+)	  (gl:vertex i +BOX-SIZE+ (- +BOX-SIZE+))

	  ;; bottom front->back
	  (gl:vertex i (- +BOX-SIZE+)  +BOX-SIZE+)	  (gl:vertex i (- +BOX-SIZE+) (- +BOX-SIZE+))

	  ;; left front->back
	  (gl:vertex (- +BOX-SIZE+) i  +BOX-SIZE+)	  (gl:vertex (- +BOX-SIZE+) i (- +BOX-SIZE+))
	  
	  ;; right front->back
	  (gl:vertex +BOX-SIZE+ i  +BOX-SIZE+)	  (gl:vertex +BOX-SIZE+ i (- +BOX-SIZE+)))))
	  
    )
	

  
  
(defun init ()
  '( (documentation . "intialize things") (line . 42) (filepath . "..."))
  (gl:clear-color 0 0 0 1)
  (gl:viewport 0 0 +XRES+ +YRES+)
  
  (gl:matrix-mode :projection)
  (gl:load-identity)
  (glu:perspective 45  (/ +XRES+ +YRES+) 0.5 100)
  
  (gl:matrix-mode :modelview)
  (gl:load-identity)

  (gl:enable :depth-test)
  
  (dotimes (i +TOR-X-RES+)
    (let* ((outer-angle (* (/ i (float +TOR-X-RES+)) (* pi 2)))
	   (xo (* 2 (cos outer-angle)))
	   (yo (* 2 (sin outer-angle))))
    
      (dotimes (j +TOR-Y-RES+)
	(let* ((inner-angle (* (/ j (float +TOR-Y-RES+)) (* pi 2)))
	       (px (* (+ 5 xo) (cos inner-angle)))
	       (py (* (+ 5 xo) (sin inner-angle))))

	  (setf (aref *point-grid* i j) (make-vec3 :x px :y yo :z py))

	  (setf (aref *color-grid* i j) (make-vec3 :x (/ i 10.0) :y 0 :z 0))

	  )

	)))

  (let ((mixer (make-instance 'fadout-mixer)))
    (mixer-init mixer)
    (add-mixer :fadeout mixer))

  (let ((mixer (make-instance 'ring-mixer)))
    (mixer-init mixer)
    (add-mixer :ring mixer))

  (add-mixer :hring (make-instance 'hring-mixer))
  )

(defun main ()
  (with-init-window (:title "GL Window" :width +XRES+ :height +YRES+)
    
    (init)
    
    (loop until (window-should-close-p)
       do (render)
       do (swap-buffers)
       do (poll-events))))
