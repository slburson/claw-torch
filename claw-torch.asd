(asdf:defsystem :claw-torch
  :description "Bindings to libtorch"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:claw-torch-bindings))


(asdf:defsystem :claw-torch/wrapper
  :description "Wrapper generator for libtorch"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:alexandria :claw)
  :serial t
  :components ((:file "src/claw")
               (:module :src-includes
                :pathname "src/")
               (:module :torch-root-includes
                :pathname "libtorch/include/")
               (:module :torch-includes
                :pathname "libtorch/include/torch/csrc/api/include/")))


(asdf:defsystem :claw-torch/example
  :description "Example for CLAW-TORCH"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:claw-torch)
  :pathname "example/"
  :components ((:file "example")))


#+unix
(setf (uiop:getenv "LD_LIBRARY_PATH")
      (directory-namestring (merge-pathnames "libtorch/lib/" *load-pathname*)))
