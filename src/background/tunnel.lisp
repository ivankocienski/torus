
(in-package :torus-demo)

(defclass tunnel-background (animator-base)
  ((target :initform 0)
   (target-hold :initform 0)
   (target-jitter :initform 0)
   (target-jitter-hold :initform 0)
   (current-target :initform 0)
   (tail :initform 0)
   )
  )

(defmethod initialize-instance :after ((this tunnel-background) &key)
  (with-slots (current-target target target-jitter) this
    (setf
     target (make-vec3 :x 0 :y 0 :z 0)
     target-jitter (make-vec3 :x 0 :y 0 :z 0)
     current-target (make-vec3 :x 0 :y 0 :z 0)))
)

(defmethod animator-activate ((this tunnel-background))
  )

(defmethod animator-step ((this tunnel-background))
  (with-slots (target target-hold current-target target-jitter-hold target-jitter) this

    (if (> target-jitter-hold 0)
	(decf target-jitter-hold)
	(setf
	 (vec3-x target-jitter) (- 2.0 (random 4.0))
	 (vec3-y target-jitter) (- 2.0 (random 4.0))
	 target-jitter-hold 40))
    
    (if (> target-hold 0)
	(decf target-hold)
	
	(setf target
	      (make-vec3
	       :x (* 10 (- 1.0 (random 2.0)))
	       :y (* 10 (- 1.0 (random 2.0))))
	      
	      target-hold 80))

    (let ((tx (+ (vec3-x target) (vec3-x target-jitter)))
	  (ty (+ (vec3-y target) (vec3-y target-jitter))))
	  
	  (incf (vec3-x current-target) (* (- tx (vec3-x current-target)) 0.02))
	  (incf (vec3-y current-target) (* (- ty (vec3-y current-target)) 0.02)))

    (gl:with-primitive :quads
      (gl:color 0.1 0.1 0.1)

      (gl:vertex (- (vec3-x target) 0.5) (- (vec3-y target) 0.5) 10)
      (gl:vertex (+ (vec3-x target) 0.5) (- (vec3-y target) 0.5) 10)
      (gl:vertex (+ (vec3-x target) 0.5) (+ (vec3-y target) 0.5) 10)
      (gl:vertex (- (vec3-x target) 0.5) (+ (vec3-y target) 0.5) 10)
    
      (gl:color 0 0 1)

      (gl:vertex (- (vec3-x current-target) 0.5) (- (vec3-y current-target) 0.5) 10)
      (gl:vertex (+ (vec3-x current-target) 0.5) (- (vec3-y current-target) 0.5) 10)
      (gl:vertex (+ (vec3-x current-target) 0.5) (+ (vec3-y current-target) 0.5) 10)
      (gl:vertex (- (vec3-x current-target) 0.5) (+ (vec3-y current-target) 0.5) 10))
		
	  
    ))
  
