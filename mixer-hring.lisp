
(in-package :taurus-demo)

(defclass hring-mixer (mixer-base) 
  ((band-color :initform 0)
   (position :initform 0)
   (hold :initform 0)
   (hold-max :initform 0)
   (step-dir :initform 0)
  ))

(defmethod mixer-init ((this hring-mixer))
  )

(defmethod mixer-activate ((this hring-mixer))
  (with-slots (band-color step-dir hold-max) this
    
    (setf band-color
	  (rainbow-vector (random 1.0)))
    (setf step-dir
	  (if (= (random 2) 1) 1 -1))
    (setf hold-max
	  (+ 1 (random 5)))
    
    ))

(defmethod mixer-step ((this hring-mixer))
  (with-slots (band-color position hold step-dir hold-max) this

    (dotimes (i +TOR-X-RES+)
      (dotimes (j +TOR-Y-RES+)

	(let ((c (aref *color-grid* i j)))
	  (decf (vec3-x c) 0.01) (if (< (vec3-x c) 0) (setf (vec3-x c) 0))
	  (decf (vec3-y c) 0.01) (if (< (vec3-y c) 0) (setf (vec3-y c) 0))
	  (decf (vec3-z c) 0.01) (if (< (vec3-z c) 0) (setf (vec3-z c) 0)))))

    (if (> hold 0)
	(decf hold)
	(progn
	  (setf hold hold-max)
	  
	  (incf position step-dir)
	  (if (> position (- +TOR-X-RES+ 1))
	      (decf position +TOR-X-RES+))
	  (if (< position 0)
	      (incf position +TOR-X-RES+))

	  (dotimes (i +TOR-Y-RES+)
	    (setf
	     (aref *color-grid* position i)
	     (make-vec3
	      :x (vec3-x band-color)
	      :y (vec3-y band-color)
	      :z (vec3-z band-color))))))
  ))
