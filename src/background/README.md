
# Torus

A graphical demonstration written in Common Lisp. Not very sophisticated, but
that doesn't stop it from looking kinda cool.

## Screen shots

!(/screenshots/screen-00.jpg?raw=true)

!(/screenshots/screen-01.jpg?raw=true)

!(/screenshots/screen-02.jpg?raw=true)

## Requirements

- sbcl (probably)
- quicklisp (recommended)
- lispbuilder-sdl
- cl-opengl

## To run

> git clone into directory and cd

> sbcl --load "torus.asd"

> (ql:quickload :torus-demo)

> (torus-demo::main)


