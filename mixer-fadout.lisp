
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

  (fadeout-color-grid)
  
  (setf
   (aref *color-grid*
	 (random +TOR-X-RES+)
	 (random +TOR-Y-RES+))
   (copy-structure (slot-value this 'start-color)))

  )
