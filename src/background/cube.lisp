
(in-package :torus-demo)

(defconstant +BOX-SIZE+ 20)

(defclass cube-background (animator-base)
  ((start-color :initform 0))
  )

;(defmethod initialize-instance :after ((this cube-background) &keys)
;  )

(defmethod animator-activate ((this cube-background))
  )

(defmethod animator-step ((this cube-background))

  (gl:color 0.4 0.4 0.4)
  (with-pushed-matrix
    (gl:rotate *rotation* 0.1 0.01 0.3)


    (loop for i from (- +BOX-SIZE+) to +BOX-SIZE+ by 5
       do 
	 (gl:with-primitive :lines

	  ;; top left->right
	  (gl:vertex (- +BOX-SIZE+) +BOX-SIZE+ i)	  (gl:vertex  +BOX-SIZE+ +BOX-SIZE+ i)

	  ;; bottom left->right
	  (gl:vertex (- +BOX-SIZE+) (- +BOX-SIZE+) i)	  (gl:vertex  +BOX-SIZE+ (- +BOX-SIZE+) i)

	  ;; front left->right
	  (gl:vertex (- +BOX-SIZE+) i (- +BOX-SIZE+))	  (gl:vertex  +BOX-SIZE+ i (- +BOX-SIZE+))

	  ;; back left->right
	  (gl:vertex (- +BOX-SIZE+) i +BOX-SIZE+)	  (gl:vertex  +BOX-SIZE+ i +BOX-SIZE+)

	  ;; left top->bottom
	  (gl:vertex (- +BOX-SIZE+)  +BOX-SIZE+ i)	  (gl:vertex (- +BOX-SIZE+) (- +BOX-SIZE+) i)

	  ;; right top->bottom
	  (gl:vertex +BOX-SIZE+  +BOX-SIZE+ i)	  (gl:vertex +BOX-SIZE+ (- +BOX-SIZE+) i)

	  ;; front top->bottom
	  (gl:vertex i (- +BOX-SIZE+) (- +BOX-SIZE+))	  (gl:vertex i  +BOX-SIZE+ (- +BOX-SIZE+))

	  ;; back top->bottom
	  (gl:vertex i (- +BOX-SIZE+) +BOX-SIZE+)	  (gl:vertex i  +BOX-SIZE+ +BOX-SIZE+)

	  ;; top front->back
	  (gl:vertex i +BOX-SIZE+  +BOX-SIZE+)	  (gl:vertex i +BOX-SIZE+ (- +BOX-SIZE+))

	  ;; bottom front->back
	  (gl:vertex i (- +BOX-SIZE+)  +BOX-SIZE+)	  (gl:vertex i (- +BOX-SIZE+) (- +BOX-SIZE+))

	  ;; left front->back
	  (gl:vertex (- +BOX-SIZE+) i  +BOX-SIZE+)	  (gl:vertex (- +BOX-SIZE+) i (- +BOX-SIZE+))
	  
	  ;; right front->back
	  (gl:vertex +BOX-SIZE+ i  +BOX-SIZE+)	  (gl:vertex +BOX-SIZE+ i (- +BOX-SIZE+)))))
  
  )
