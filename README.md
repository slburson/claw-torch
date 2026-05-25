# claw-torch

Common Lisp bindings to [libtorch](https://github.com/pytorch/pytorch).

Currently has bindings for LibTorch 2.12.0 on `x86_64-unknown-linux-gnu`.  To use a
different version or target (`clang --version` will tell you what target it's compiled
for):

- download the LibTorch binary distribution from the PyTorch site and unpack it in the
root directory of your cloned repo; it will create a directory `libtorch`
- `cd` into that `libtorch` directory and do `patch -p1 <../for-claw.patch`
- clone [Claw](https://github.com/borodust/claw),
[cl-resect](https://github.com/borodust/cl-libresect), and
[libresect](https://github.com/borodust/libresect)
- build libresect according to its directions (no need to install)
- make sure ASDF can find Claw and cl-resect, either by putting them in
`~/quicklisp/local-projects/` or by setting `asdf:*central-registry*`
- start Lisp (currently tested on SBCL 2.6.0 only)
- `> (ql:quickload "claw")`
- `> (ql:quickload "claw-torch")`
- `> (sb-alien:load-shared-object "/path/to/libresect.so")`
- open `src/claw.lisp` (in this repo) in your editor; if needed, fix the `:targets`
option; compile the `claw:defwrapper` form
- `> (claw.wrapper:generate-wrapper :claw-torch)`

There are two output files, `bindings/_target_.lisp` and `src/lib/adapter._target_.cxx`.

(These directions are from memory and are untested; don't be too surprised if there's
something missing, but if so, please file an issue.)
