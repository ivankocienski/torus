
(in-package :taurus-demo)

(defconstant +XRES+ 800)
(defconstant +YRES+ 600)
(defconstant +TOR-X-RES+ 50)
(defconstant +TOR-Y-RES+ 30)
(defconstant +BOX-SIZE+ 20)

;; TODO: fewer magic numbers

(defparameter *rotation* 0.0)
(defparameter *point-grid* (make-array (list +TOR-X-RES+ +TOR-Y-RES+)))
(defparameter *color-grid* (make-array (list +TOR-X-RES+ +TOR-Y-RES+)))
;;(defparameter *color-hold* 0)
(defparameter *mixer* nil)
(defparameter *mixer-hold* 0)

(defstruct vec3 x y z)

(defun fadeout-color-grid ()
  (dotimes (y +TOR-Y-RES+)
    (dotimes (x +TOR-X-RES+)

      (let ((c (aref *color-grid* x y)))

	(decf (vec3-x c) 0.01) (if (< (vec3-x c) 0) (setf (vec3-x c) 0))
	(decf (vec3-y c) 0.01) (if (< (vec3-y c) 0) (setf (vec3-y c) 0))
	(decf (vec3-z c) 0.01) (if (< (vec3-z c) 0) (setf (vec3-z c) 0))))))

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
