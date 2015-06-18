
(in-package :torus-demo)

(defclass odysey-background (animator-base)
  ((lines :initform 0)
   (orientation :initform 0))
  )

(defstruct odysey-line side px py dx dy)

(defun odysey-randomize-line (line)

  (setf
   (odysey-line-px line) (* 10 (- 1.0 (random 2.0)))
   (odysey-line-py line) 20
   (odysey-line-dx line) 0
   (odysey-line-dy line) 0
   (odysey-line-side line) (if (= (random 2) 1) 1 -1))

  (let ((d (random 4)) (m (+ 1 (* 0.5 (random 10)))))
    (cond
      ((= d 0) (setf (odysey-line-dx line) (- m)))
      ((= d 1) (setf (odysey-line-dx line)    m ))
      ((= d 2) (setf (odysey-line-dy line) (- m)))
      ((= d 3) (setf (odysey-line-dy line)    m ))))	

  line)
    
(defmethod initialize-instance :after ((this odysey-background) &key)
  (with-slots (lines orientation) this    
    (setf

     orientation
     (random 2)
     
     lines
     (loop repeat 200
	collect
	  (let ((line (odysey-randomize-line (make-odysey-line))))
	    (setf (odysey-line-py line) (* 20 (- 1 (random 2.0))))
	    line)))
    ))

(defmethod animator-activate ((this odysey-background))
  (with-slots (orientation) this
    (setf orientation (random 2)))
  )

(defmethod animator-step ((this odysey-background))
  (with-slots (orientation lines) this

    (let ((draw-func
	   (cond
	     ;; sides on left and right
	     ((= orientation 0) (lambda (line)
				  (let ((side (* 5 (odysey-line-side line))))

				    (gl:vertex
				     side
				     (odysey-line-px line)
				     (odysey-line-py line))

				    (gl:vertex
				     side
				     (+ (odysey-line-px line) (odysey-line-dx line))
				     (+ (odysey-line-py line) (odysey-line-dy line)))
				  )))

	     ;; sides on top and bottom
	     ((= orientation 1) (lambda (line)
				  
				  (let ((side (* 5 (odysey-line-side line))))

				    (gl:vertex
				     (odysey-line-px line)
				     side
				     (odysey-line-py line))

				    (gl:vertex
				     (+ (odysey-line-px line) (odysey-line-dx line))
				     side
				     (+ (odysey-line-py line) (odysey-line-dy line)))

				  
				  ))))))

      (gl:color 0.5 0.5 0.5)

      (gl:with-primitive :lines
	(dolist (line lines)

	  (decf (odysey-line-py line) 0.2)
	  (if (< (odysey-line-py line) -10)
	      (odysey-randomize-line line))
      
	  (funcall draw-func line)))))
  )
