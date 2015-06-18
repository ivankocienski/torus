
(in-package :torus-demo)

(defclass fadeout-mixer (animator-base)
  ((start-color :initform 0))
  )

(defmethod mixer-activate ((this fadeout-mixer))
  (with-slots (start-color) this
    (setf start-color
	  (rainbow-vector (random 1.0))))
  )

(defmethod mixer-step ((this fadeout-mixer))
  (with-slots (start-color) this
    
    (fadeout-color-grid)
  
    (setf
     (aref *color-grid*
	   (random +TOR-X-RES+)
	   (random +TOR-Y-RES+))
     (copy-vec3 start-color))))
