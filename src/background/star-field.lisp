
(in-package :torus-demo)

(defclass star-field-background (animator-base)
  ((stars :initform 0)
   (fixed-stars :initform 0))
  )

(defmethod initialize-instance :after ((this star-field-background) &key)
  (with-slots (stars fixed-stars) this
    (setf stars
	  (loop repeat 1000
	     collect (make-vec3
		      :x (* 10 (- 1.0 (random 2.0)))
		      :y (* 10 (- 1.0 (random 2.0)))
		      :z (- (* 30 (random 1.0)) 10))))
	  fixed-stars
	  (loop repeat 500
	     collect (make-vec3
		      :x (* 25 (- 1.0 (random 2.0)))
		      :y (* 15 (- 1.0 (random 2.0)))
		      :z 20))))
  )

(defmethod animator-activate ((this star-field-background))
  )

(defmethod animator-step ((this star-field-background))

  (with-slots (stars fixed-stars) this

    (with-primitive :quads
  
      (gl:color 0.8 0.8 0.8)
      
      (dolist (star stars)

	(decf (vec3-z star) 0.5)
	(if (< (vec3-z star) -10)
	    (progn
	      (setf
	       (vec3-x star) (* 10 (- 1.0 (random 2.0)))
	       (vec3-y star) (* 10 (- 1.0 (random 2.0)))
	       (vec3-z star) 20)))

	(let ((x (vec3-x star)) (y (vec3-y star)) (z (vec3-z star)))
	  
	  (gl:vertex x (- y 0.025) z)
	  (gl:vertex (+ x 0.025) y z)
	  (gl:vertex x (+ y 0.025) z)
	  (gl:vertex (- x 0.025) y z))
	  
	))))

