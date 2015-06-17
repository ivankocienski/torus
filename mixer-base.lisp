
(in-package :taurus-demo)

;;
;; the mixer class
;;

(defclass mixer-base () ())

(defgeneric mixer-init (mixer)
  (:documentation "Initialize mixer"))

(defgeneric mixer-step (mixer)
  (:documentation "One step of animation"))

(defgeneric mixer-activate (mixer)
  (:documentation "Called every time a mixer is chosen"))

;;
;; mixer pool stuff
;;

(defparameter *mixer-db* nil)
(defparameter *mixer-db-len* 0)

(defun add-mixer (name obj)
  (setf *mixer-db* (acons name obj *mixer-db*))
  (setf *mixer-db-len* (length *mixer-db*)))

(defun choose-random-mixer ()
  (let ((p 0));;(random *mixer-db-len*)))
    (labels ((sample (c list)
	       (if (> c 0)
		   (sample (- c 1) (cdr list))
		   (car list))))
      (cdr (sample p *mixer-db*))))
  )
