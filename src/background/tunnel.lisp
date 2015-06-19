
(in-package :torus-demo)

(defclass tunnel-background (animator-base)
  ((head :initform 0)
   (tail :initform nil)
   
   (move-hold        :initform 0)
   (move-jitter      :initform 0)
   (move-jitter-hold :initform 0)
   (move-target      :initform 0)
   
   ;;(turn      :initform 0)
   (turn-inc  :initform 0)
   (turn-hold :initform 0)

   ;;(scale              :initform 0)
   (scale-target       :initform 0)
   (scale-wobble       :initform 0)
   (scale-wobble-scale :initform 0)
   (scale-wobble-speed :initform 0)
   (scale-hold         :initform 0)

   (num-parts :initform 0)

   ))

(defstruct tunseg ;; tunnel segment
  x
  y
  scale
  turn)

(defmethod initialize-instance :after ((this tunnel-background) &key)
  (with-slots (head move-target move-jitter) this
    (setf
     head        (make-tunseg :x 0 :y 0 :scale 1 :turn 0)
     move-jitter (make-tunseg :x 0 :y 0 :scale 1 :turn 0)
     move-target (make-tunseg :x 0 :y 0 :scale 1 :turn 0)))
)

(defmethod animator-activate ((this tunnel-background))
  (with-slots (num-parts turn-inc) this
    (setf
     num-parts (+ 3 (random 5))))
  )

(defmethod animator-step ((this tunnel-background))
  (with-slots (head
	       move-hold
	       move-target
	       move-jitter-hold
	       move-jitter
	       tail
	       num-parts
	       
	       turn-inc
	       turn-hold
	       
	       scale-target
	       scale-wobble
	       scale-wobble-scale
	       scale-wobble-speed
	       scale-hold) this

    (if (> move-jitter-hold 0)
	(decf move-jitter-hold)
	(setf
	 (tunseg-x move-jitter) (- 2.0 (random 4.0))
	 (tunseg-y move-jitter) (- 2.0 (random 4.0))
	 move-jitter-hold 40))
    
    (if (> move-hold 0)
	(decf move-hold)
	(setf
	 (tunseg-x move-target) (* 10 (- 1.0 (random 2.0)))
	 (tunseg-y move-target) (* 10 (- 1.0 (random 2.0)))
	 move-hold 80))

    (if (> turn-hold 0)
	(decf turn-hold)
	(setf
	 turn-inc (* 0.05 (- 1 (random 2.0)))
	 turn-hold (+ 20 (* 5 (random 45)))))

    (if (> scale-hold 0)
	(decf scale-hold)
	(setf
	 scale-target (+ 4 (random 6.0))
	 scale-hold (+ 10 (* 5 (random 50)))))
	 
    (let ((tx (+ (tunseg-x move-target) (tunseg-x move-jitter)))
	  (ty (+ (tunseg-y move-target) (tunseg-y move-jitter))))
	  
	  (incf (tunseg-x head) (* (- tx (tunseg-x head)) 0.02))
	  (incf (tunseg-y head) (* (- ty (tunseg-y head)) 0.02)))

    (incf (tunseg-turn head) turn-inc)

    (incf (tunseg-scale head) (* 0.02 (- scale-target (tunseg-scale head))))
    
    (push (copy-structure head) tail)
    
    (setf tail (trim-list tail 50))

    (gl:color 0.5 0.5 0.5)

    (let ((pos 10))

      (dolist (seg tail)
	
	(gl:with-primitive :line-loop
	  (dotimes (step num-parts)
	    (let* ((a (+ (tunseg-turn seg) (* (/ step num-parts) 2 pi)))
		   (px (* (tunseg-scale seg) (cos a)))
		   (py (* (tunseg-scale seg) (sin a))))
	      
	      (gl:vertex
	       (+ (tunseg-x seg) px)
	       (+ (tunseg-y seg) py)
	       pos))))

	(decf pos 1)))	       	  
    ))
  
