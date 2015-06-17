
(in-package :taurus-demo)

(defclass flame-mixer (mixer-base) 
  ((color :initform 0)
   (grid :initform (make-array (list +TOR-X-RES+ +TOR-Y-RES+) :initial-element 0))
   (hold :initform 0)
  ))

;;(defmethod initialize-instance :after ((this flame-mixer) &key)  
;;  )

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
	  (setf hold 10)
	  
	  (dotimes (y +TOR-Y-RES+) ;; j

	    (let ((y-1 (- y 1))
		  (y+1 (+ y 1)))

	      (if (< y-1 0) (setf y-1 (- +TOR-Y-RES+ 1)))
	      (if (> y+1 (- +TOR-Y-RES+ 1)) (setf y+1 0))
	      
	      (dotimes (x +TOR-X-RES+) ;; i
		
		(let ((x-1 (- x 1))
		      (x+1 (+ x 1))
		      (sum 0))

		  (if (< x-1 0) (setf x-1 (- +TOR-X-RES+ 1)))
		  (if (> x+1 (- +TOR-X-RES+ 1)) (setf x+1 0))
		  
		  (incf sum (* (aref grid x   y)   0.5))
		  ;;(incf sum (* (aref grid x y+1) 0.9))
		  
		  ;;(incf sum (* (aref grid x-1 y)   0.6))
		  ;;(incf sum (* (aref grid x+1 y)   0.6))
		  ;;(incf sum (* (aref grid x   y-1) 0.5))
		  ;;(incf sum (* (aref grid x   y+1) 0.8))
		  
		  (incf sum (* (aref grid x-1 y+1) 0.03))
		  (incf sum (* (aref grid x   y+1) 0.5))
		  (incf sum (* (aref grid x+1 y+1) 0.03))
		  ;;(incf sum (* (aref grid x+1 y+1) 0.5))

		  (setf (aref grid x y) (/ sum 1.06))))))
		  ;;(setf (aref grid x y) sum)))))

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
	     (random 1.0)))))
	  
	  


    
  ))

#|
(defmethod mixer-step ((this flame-mixer))
  (with-slots (color grid hold) this

    (if (> hold 0)
	(decf hold)
	(progn
	  (setf hold 10)
	  
	  (dotimes (y +TOR-Y-RES+) ;; j

	    (let ((y-1 (- y 1))
		  (y+1 (+ y 1)))

	      (if (< y-1 0) (setf y-1 (- +TOR-Y-RES+ 1)))
	      (if (> y+1 (- +TOR-Y-RES+ 1)) (setf y+1 0))
	      
	      (dotimes (x +TOR-X-RES+) ;; i
		
		(let ((x-1 (- x 1))
		      (x+1 (+ x 1))
		      (sum 0))

		  (if (< x-1 0) (setf x-1 (- +TOR-X-RES+ 1)))
		  (if (> x+1 (- +TOR-X-RES+ 1)) (setf x+1 0))
		  
		  (incf sum (* (aref grid x   y)   0.9))
		  
		  ;;(incf sum (* (aref grid x-1 y)   0.6))
		  ;;(incf sum (* (aref grid x+1 y)   0.6))
		  ;;(incf sum (* (aref grid x   y-1) 0.5))
		  ;;(incf sum (* (aref grid x   y+1) 0.8))
		  
		  (incf sum (* (aref grid x-1 y-1) 0.2))
		  (incf sum (* (aref grid x-1 y+1) 0.5))
		  (incf sum (* (aref grid x+1 y-1) 0.2))
		  ;;(incf sum (* (aref grid x+1 y+1) 0.5))

		  (setf (aref grid x y) (/ sum 5.6))))))

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
	     (+ 0.5 (random 0.5))))))
	  
	  


    
  ))
|#

