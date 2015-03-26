(asdf:defsystem :popper
  :description ""
  :author "Adrian Medina <adrian.medina@mail.yu.edu>"
  :license "GNU General Public License"
  :depends-on (:cffi :alexandria)
  :serial t
  :pathname "src"
  :components ((:file "asm")
               (:file "asm/abi")
               (:file "asm/llvm")
               (:file "asm/clang")
               (:file "popper")))

