
(in-package :torus-demo)

(defclass twist-mixer (animator-base)
  (
   ;; 0.0 -> 1.0 
   (phase :initform 0)

   ;; scale
   (multiplier :initform 0)

   ;; -1 or +1
   (direction :initform 0)

   ;; number of repeats
   (phase-multiplier :initform 0)

   ;; slide wave along 'Y' axis
   (offset :initform 0)

   ;; speed of wave sliding
   (offset-inc :initform 0)

   ;; some color cycling
   (color-phase :initform 0)))

(defmethod animator-activate ((this twist-mixer))
  (with-slots (phase multiplier direction offset offset-inc color-phase phase-multiplier) this
    (setf phase 0)
    (setf multiplier 10.0)
    (setf direction 1.0)
    (setf phase-multiplier (* 2 pi (+ 1 (random 4))))
    (setf offset-inc (- 0.5 (random 1.0)))
    
    )
  )

(defmethod animator-step ((this twist-mixer))
  (with-slots (phase multiplier direction color-phase phase-multiplier offset offset-inc) this
    
    (incf phase 0.01)
    (if (>= phase 1.0)
	(progn
	  ;; ... reset stuff
	  (setf direction 
		(if (= (random 2) 1) 1 -1))
	  (setf phase-multiplier (* 2 pi (+ 1 (random 4))))

	  (setf multiplier (+ 2 (random 13)))
	  (decf phase 1.0)))

    (incf color-phase 0.001)
    (if (>= color-phase 1.0) (decf color-phase 1.0))

    (setf offset (mod (+ offset offset-inc) +TOR-Y-RES+))
	  
    (let ((scaler (* multiplier direction (sin (* phase pi)))))
		        
      (dotimes (x +TOR-X-RES+)

	(let ((ry (round (+ offset (* scaler (sin (* (/ x +TOR-X-RES+) phase-multiplier)))))))

	  (if (<  ry 0) (incf ry +TOR-Y-RES+))
	  (if (> ry (- +TOR-Y-RES+ 1)) (decf ry +TOR-Y-RES+))

	  (dotimes (y +TOR-Y-RES+)

	    (setf
	     (aref *color-grid* x ry)
	     (if (> y (/ +TOR-Y-RES+ 2))
		 (rainbow-vector color-phase)
		 (rainbow-vector (- 1 color-phase))))

	    (setf ry (mod (+ ry 1) +TOR-Y-RES+))

	    )
	  ))))
  )
