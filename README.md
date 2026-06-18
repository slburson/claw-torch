# claw-torch

Common Lisp bindings to [libtorch](https://github.com/pytorch/pytorch).

Currently has bindings for LibTorch 2.12.0 on `x86_64-unknown-linux-gnu`.  To use a
different version or target (`clang --version` will tell you what target it's compiled
for):

- download the LibTorch binary distribution from the PyTorch site and unpack it in the
root directory of your cloned repo; it will create a directory `libtorch`
- `cd` into that `libtorch` directory
- `% patch -p1 <../libtorch-patch-00-auto-return-types`
- [patch 1 is no longer needed]
- `% patch -p2 <../libtorch-patch-02-unlinkable-functions`
- `% patch -p1 <../libtorch-patch-03-static-assert`
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
- `> (claw.wrapper:generate-wrapper :claw-torch)` (takes almost an hour; ignore errors
  from `prepared_implicit.h`)
- `% cd .../src/lib` (within claw-torch)
- Currently, `CMakeLists.txt` assumes LLVM is in `/usr/local/llvm`.  If yours isn't,
either symlink it from there or edit `CMakeLists.txt`.
- `% mkdir build`
- `% cd build`
- `% cmake ..`
- `% cmake --build .`

If that succeeds, it will produce `src/lib/build/libtorch.clawed.so`.  The other output
file is `bindings/_target_.lisp`.

(These directions are from memory and are untested; don't be too surprised if there's
something missing, but if so, please file an issue.)
