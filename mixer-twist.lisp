
(in-package :taurus-demo)

(defclass twist-mixer (mixer-base)
  (
   ;; 0.0 -> 1.0 
   (phase :initform 0)

   ;; scale
   (multiplier :initform 0)

   ;; -1 or +1
   (direction :initform 0)

   ;; number of repeats
   (phase-multiplier :initform 0)
   
   (offset :initform 0)
   (color-phase :initform 0)))

(defmethod mixer-activate ((this twist-mixer))
  (with-slots (phase multiplier direction offset color-phase phase-multiplier) this
    (setf phase 0)
    (setf multiplier 10.0)
    (setf direction 1.0)
    (setf phase-multiplier (* 2 pi (+ 1 (random 4))))
    
    )
  )

(defmethod mixer-step ((this twist-mixer))
  (with-slots (phase multiplier direction color-phase phase-multiplier) this
    
    (incf phase 0.01)
    (if (>= phase 1.0)
	(progn
	  ;; ... reset stuff
	  (setf direction 
		(if (= (random 2) 1) 1 -1))
	  (setf phase-multiplier (* 2 pi (+ 1 (random 4))))

	  (decf phase 1.0)))

    (let ((scaler (* multiplier direction (sin (* phase pi)))))
		     
      
      (dotimes (x +TOR-X-RES+)

	(let ((ry (round (* scaler (sin (* (/ x +TOR-X-RES+) phase-multiplier))))))

	  (if (< ry 0) (incf ry +TOR-Y-RES+))

	  (dotimes (y +TOR-Y-RES+)

	    (setf
	     (aref *color-grid* x ry)
	     (if (> y (/ +TOR-Y-RES+ 2))
		 (rainbow-vector color-phase)
		 (make-vec3 :x 0 :y 1 :z 0)))

	    (setf ry (mod (+ ry 1) +TOR-Y-RES+))

	    )
	  ))))
  )
