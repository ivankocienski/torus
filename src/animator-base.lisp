
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
