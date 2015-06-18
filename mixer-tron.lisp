
(in-package :taurus-demo)

(defclass tron-mixer (mixer-base)
  ((pixels :initform nil)
  (hold :initform 0))
  )

(defstruct tron-pixel
  xpos
  ypos
  xinc
  yinc
  move-count
  color)

(defun randomize-pixel (pixel)
  (let ((speed (+ 0.45 (random 0.5))) (dir (random 4)))

    (if (= (random 2) 0) (setf speed (- speed)))
    
    (cond
      ((= dir 0) (progn ;; up
		   (setf (tron-pixel-xinc pixel) 0)
		   (setf (tron-pixel-yinc pixel) (- speed))))
      
      ((= dir 1) (progn ;; down
		   (setf (tron-pixel-xinc pixel) 0)
		   (setf (tron-pixel-yinc pixel) speed)))
      
      ((= dir 2) (progn ;; left
		   (setf (tron-pixel-xinc pixel) (- speed))
		   (setf (tron-pixel-yinc pixel) 0)))
      
      ((= dir 3) (progn ;; right
		   (setf (tron-pixel-xinc pixel) speed)
		   (setf (tron-pixel-yinc pixel) 0)))))

  (setf (tron-pixel-move-count pixel) (+ 10 (random 50)))
  (setf (tron-pixel-color pixel) (rainbow-vector (random 1.0)))
  pixel
  )

(defmethod mixer-activate ((this tron-mixer))
  (with-slots (pixels hold) this

    (unless pixels
      (setf pixels
	    (loop repeat 20 collect
		 (let ((pixel (make-tron-pixel)))

		   (randomize-pixel pixel)
		   (setf (tron-pixel-xpos pixel) (random +TOR-X-RES+))
		   (setf (tron-pixel-ypos pixel) (random +TOR-Y-RES+))
		   pixel))))
  ))

(defmethod mixer-step ((this tron-mixer))
  (with-slots (pixels hold) this

    ;; move
    (if (> hold 0)
	(decf hold)
	(progn 
	  (dolist (pixel pixels)
	    
	    (incf (tron-pixel-xpos pixel) (tron-pixel-xinc pixel))
	    (incf (tron-pixel-ypos pixel) (tron-pixel-yinc pixel))

	    (if (< (tron-pixel-xpos pixel) 0) (incf (tron-pixel-xpos pixel) (- +TOR-X-RES+ 1)))
	    (if (< (tron-pixel-ypos pixel) 0) (incf (tron-pixel-ypos pixel) (- +TOR-Y-RES+ 1)))
	    (if (> (tron-pixel-xpos pixel) (- +TOR-X-RES+ 1)) (decf (tron-pixel-xpos pixel) (- +TOR-X-RES+ 1)))
	    (if (> (tron-pixel-ypos pixel) (- +TOR-Y-RES+ 1)) (decf (tron-pixel-ypos pixel) (- +TOR-Y-RES+ 1)))
	    
	    (if (> (tron-pixel-move-count pixel) 0)
		(decf (tron-pixel-move-count pixel))
		(randomize-pixel pixel)))
	  
	  (setf hold 2)))
    
    ;; draw
    (fadeout-color-grid)

    (dolist (pixel pixels)

      (setf
       (aref *color-grid*
	     (round (tron-pixel-xpos pixel))
	     (round (tron-pixel-ypos pixel)))
       (copy-vec3 (tron-pixel-color pixel))))
    ))
