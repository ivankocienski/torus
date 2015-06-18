
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
		      :z (* 20 (- 1.0 (random 2.0)))))
	  fixed-stars
	  (loop repeat 500
	     collect (make-vec3
		      :x (* 10 (- 1.0 (random 2.0)))
		      :y (* 10 (- 1.0 (random 2.0)))
		      :z (* 20 (- 1.0 (random 2.0)))))))
  )

(defmethod animator-activate ((this star-field-background))
  )

(defmethod animator-step ((this star-field-background))

  (with-slots (stars fixed-stars) this

    (with-primitive :points

      (gl:color 0.2 0.2 0.2)
      
      (dolist (star fixed-stars)

	(gl:vertex
	 (vec3-x star)
	 (vec3-y star)
	 (vec3-z star)))
  
      (gl:color 0.4 0.4 0.4)
      
      (dolist (star stars)

	(decf (vec3-z star) 0.25)
	(if (< (vec3-z star) -10)
	    (progn
	      (setf
	       (vec3-x star) (* 10 (- 1.0 (random 2.0)))
	       (vec3-y star) (* 10 (- 1.0 (random 2.0)))
	       (vec3-z star) 20)))

	(gl:vertex
	 (vec3-x star)
	 (vec3-y star)
	 (vec3-z star)))))
  )

