
(in-package :taurus-demo)

(defclass flame-mixer (mixer-base) 
  ((color :initform 0)
   (grid :initform (make-array (list +TOR-X-RES+ +TOR-Y-RES+) :initial-element 0))
   (hold :initform 0)
  ))

(defmethod mixer-activate ((this flame-mixer))
  (with-slots (color) this
    (setf color
	  (rainbow-vector (random 1.0)))
    ))

(defmethod mixer-step ((this flame-mixer))
  (with-slots (color grid hold) this

    (if (> hold 0)
	(decf hold)
	(progn
	  (setf hold 6)
	  
	  (dotimes (y +TOR-Y-RES+) 

	    (let ((ny (mod (+ y 1) +TOR-Y-RES+)))
	      
	      (dotimes (x +TOR-X-RES+) 
		
		(let ((x-1 (- x 1))
		      (x+1 (+ x 1))
		      (sum 0))

		  (if (< x-1 0) (setf x-1 (- +TOR-X-RES+ 1)))
		  (if (> x+1 (- +TOR-X-RES+ 1)) (setf x+1 0))
		  
		  (incf sum (* (aref grid x   y)   0.5))
		  
		  (incf sum (* (aref grid x-1 ny) 0.03))
		  (incf sum (* (aref grid x   ny) 0.5))
		  (incf sum (* (aref grid x+1 ny) 0.03))

		  (setf (aref grid x y) (/ sum 1.07))))))

	  (dotimes (y +TOR-Y-RES+)
	    (dotimes (x +TOR-X-RES+)

	      (let ((br (aref grid x y)))
		(setf
		 (aref *color-grid* x y)
		 (make-vec3
		  :x (* (vec3-x color) br)
		  :y (* (vec3-y color) br)
		  :z (* (vec3-z color) br))))))
	  
	  

	  (dotimes (x +TOR-X-RES+)
	    (setf
	     (aref grid x 0)
	     (random 1.0))
	    (setf
	     (aref grid
		   x
		   (random +TOR-Y-RES+))
	     (random 1.0)))

	  ))))

