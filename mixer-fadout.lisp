
(in-package :taurus-demo)

(defclass fadout-mixer (mixer-base)
  ((start-color :initform 0))
  )

(defmethod mixer-init ((this fadout-mixer))
  )

(defmethod mixer-activate ((this fadout-mixer))
  (with-slots (start-color) this
    (setf start-color
	  (rainbow-vector (random 1.0))))
  )

(defmethod mixer-step ((this fadout-mixer))

  (dotimes (y +TOR-Y-RES+)
    (dotimes (x +TOR-X-RES+)

	(let ((c (aref *color-grid* x y)))

	  (decf (vec3-x c) 0.01) (if (< (vec3-x c) 0) (setf (vec3-x c) 0))
	  (decf (vec3-y c) 0.01) (if (< (vec3-y c) 0) (setf (vec3-y c) 0))
	  (decf (vec3-z c) 0.01) (if (< (vec3-z c) 0) (setf (vec3-z c) 0)))))
  
  (setf
   (aref *color-grid*
	 (random +TOR-X-RES+)
	 (random +TOR-Y-RES+))
   (copy-structure (slot-value this 'start-color)))

  )
