
(ql:quickload :cl-glfw3)
(ql:quickload :cl-opengl)
(ql:quickload :cl-glu)

(defpackage :taurus-demo
  (:use :cl :glfw :opengl :glu))

(in-package :taurus-demo)

(load "common.lisp")
(load "mixer-base.lisp")
(load "mixer-fadout.lisp")
(load "mixer-ring.lisp")
(load "mixer-hring.lisp")
(load "mixer-flame.lisp")
(load "mixer-twist.lisp")
(load "mixer-tron.lisp")

(defun reset-mixer ()
  (setf *mixer-hold* 0)
  (setf *mixer* nil))

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

    (dotimes (y +TOR-Y-RES+) ;; j
      (dotimes (x +TOR-X-RES+) ;; i
	(gl:with-primitive :quads

	  (let ((c (aref *color-grid* x y)))
	    (gl:color (vec3-x c) (vec3-y c) (vec3-z c)))

	  (let* ((x2 (mod (+ x 1) +TOR-X-RES+))
		 (y2 (mod (+ y 1) +TOR-Y-RES+))
		 (p1 (aref *point-grid* x  y ))
		 (p2 (aref *point-grid* x2 y ))
		 (p3 (aref *point-grid* x2 y2))
		 (p4 (aref *point-grid* x  y2)))

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

  (dotimes (y +TOR-Y-RES+) ;j
    (let* ((outer-angle (* (/ y (float +TOR-Y-RES+)) (* pi 2)))
	   (xo (* 2 (cos outer-angle)))
	   (yo (* 2 (sin outer-angle))))
    
      (dotimes (x +TOR-X-RES+) ;i
	(let* ((inner-angle (* (/ x (float +TOR-X-RES+)) (* pi 2)))
	       (px (* (+ 5 xo) (cos inner-angle)))
	       (py (* (+ 5 xo) (sin inner-angle))))
    

	  (setf (aref *point-grid* x y) (make-vec3 :x px :y yo :z py))

	  (setf (aref *color-grid* x y) (make-vec3 :x 0 :y 0 :z 0))

	  )

	)))

  (let ((mixer (make-instance 'fadout-mixer)))
    (mixer-init mixer)
    (add-mixer :fadeout mixer))

  (let ((mixer (make-instance 'ring-mixer)))
    (mixer-init mixer)
    (add-mixer :ring mixer))

  (add-mixer :hring (make-instance 'hring-mixer))

  (add-mixer :flame (make-instance 'flame-mixer))

  (add-mixer :twist (make-instance 'twist-mixer))

  (add-mixer :tron (make-instance 'tron-mixer))
  )

(defun main ()
  (with-init-window (:title "GL Window" :width +XRES+ :height +YRES+)
    
    (init)
    
    (loop until (window-should-close-p)
       do (render)
       do (swap-buffers)
       do (poll-events))))


(defun debug-mixer (mxr)
  (with-init-window (:title "GL Window" :width +XRES+ :height +YRES+)

    (add-mixer :tron (make-instance 'tron-mixer))
    
    (let ((mixer (cdr (assoc mxr *mixer-db*))))

      (gl:clear-color 0 0 0 1)
      (gl:viewport 0 0 +XRES+ +YRES+)
      
      (gl:matrix-mode :projection)
      (gl:load-identity)
      (gl:ortho 0 +XRES+ +YRES+ 0 -1 1)
      
      (gl:matrix-mode :modelview)
      (gl:load-identity)
      
      (dotimes (y +TOR-Y-RES+)
	(dotimes (x +TOR-X-RES+)
	  (setf (aref *color-grid* x y) (make-vec3 :x 0 :y 0 :z 0))
	  ))

  


      (let ((reactivate 0))
	
	(loop until (window-should-close-p)
	   do (progn
		
		(if (> reactivate 0)
		    (decf reactivate)
		    (progn
		      (mixer-activate mixer)
		      (setf reactivate 2000)))

		(mixer-step mixer)
	      
		(gl:with-primitive :quads
		  (dotimes (y +TOR-Y-RES+)
		    (dotimes (x +TOR-X-RES+)

		      (let* ((rx (* x 10))
			     (ry (* y 10))
			     (rx2 (+ rx 9))
			     (ry2 (+ ry 9)))

			(let ((c (aref *color-grid* x y)))
			  (gl:color
			   (vec3-x c)
			   (vec3-y c)
			   (vec3-z c)))
			
			(gl:vertex rx  ry)
			(gl:vertex rx2 ry)
			(gl:vertex rx2 ry2)
			(gl:vertex rx  ry2)))))
		
		
		
		
		(swap-buffers)
		(poll-events)))))))
  
