
(in-package :torus-demo)

;;
;; the animator class
;;

(defclass animator-base () ())

(defgeneric animator-step (a)
  (:documentation "One step of animation"))

(defgeneric animator-activate (a)
  (:documentation "Called every time a animator is chosen"))

;;
;; mixer pool stuff
;;

(defparameter *mixer-db* nil)
(defparameter *mixer-db-len* 0)
(defparameter *background-db* nil)
(defparameter *background-db-len* nil)

(defun add-background (name obj)
  (setf
   *background-db* (acons name obj *background-db*)
   *background-db-len* (length *background-db*)))

(defun choose-random-background ()
  (let ((p 0)) ;;(random *background-db-len*)))
    (labels ((sample (c list)
	       (if (> c 0)
		   (sample (- c 1) (cdr list))
		   (car list))))
      (cdr (sample p *background-db*)))))

  
(defun add-mixer (name obj)
  (setf *mixer-db* (acons name obj *mixer-db*))
  (setf *mixer-db-len* (length *mixer-db*)))

(defun choose-random-mixer ()
  (let ((p (random *mixer-db-len*)))
    (labels ((sample (c list)
	       (if (> c 0)
		   (sample (- c 1) (cdr list))
		   (car list))))
      (cdr (sample p *mixer-db*))))
  )
