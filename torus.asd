
(asdf:defsystem #:torus-demo
  :description "A demo"
  :author "Me"
  :license ""
  :serial t
  :depends-on (cl-glfw3 cl-opengl cl-glu)
  :components ((:file "src/package")
               (:file "src/common")
	       (:file "src/animator-base")
	       (:file "src/mixer/fadeout")
	       (:file "src/mixer/flame")
	       (:file "src/mixer/hring")
	       (:file "src/mixer/ring")
	       (:file "src/mixer/tron")
	       (:file "src/mixer/twist")
	       (:file "src/main")))

