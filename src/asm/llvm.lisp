;; asm/llvm.lisp

;; Copyright 2015 Adrian Medina.

;; Popper is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

(in-package :popper.asm)

(define-foreign-library llvm
  (:darwin "libLLVM.dylib")
  (t (:default "libLLVM")))

(use-foreign-library llvm)

(defmacro define-target (target)
  `(progn
     (defcfun (,(format nil "LLVMInitialize~ATargetInfo" target)
                ,(format-symbol *package* "~:@(initialize-~A-target-info~)"
                                target))
         :void)
     (defcfun (,(format nil "LLVMInitialize~ATarget" target)
                ,(format-symbol *package* "~:@(initialize-~A-target~)"
                                target))
         :void)
     (defcfun (,(format nil "LLVMInitialize~ATargetMC" target)
                ,(format-symbol *package* "~:@(initialize-~A-target-mc~)"
                                target))
         :void)
     (defcfun (,(format nil "LLVMInitialize~AAsmPrinter" target)
                ,(format-symbol *package* "~:@(initialize-~A-asm-printer~)"
                                target))
         :void)
     (defcfun (,(format nil "LLVMInitialize~AAsmParser" target)
                ,(format-symbol *package* "~:@(initialize-~A-asm-parser~)"
                                target))
         :void)
     (defcfun (,(format nil "LLVMInitialize~ADisassembler" target)
                ,(format-symbol *package* "~:@(initialize-~A-disassembler~)"
                                target))
         :void)))

(defmacro define-targets (&rest targets)
  `(progn
     ,@(mapcar (lambda (target) `(define-target ,target)) targets)))

(define-targets "X86")

(defun initialize-target-info ()
  #+(or x86 x86-64) (initialize-x86-target-info))

(defun initialize-target ()
  #+(or x86 x86-64) (initialize-x86-target))

(defun initialize-target-mc ()
  #+(or x86 x86-64) (initialize-x86-target-mc))

(defun initialize-asm-printer ()
  #+(or x86 x86-64) (initialize-x86-asm-printer))

(defun initialize-asm-parser ()
  #+(or x86 x86-64) (initialize-x86-asm-parser))

(defun initialize-disassembler ()
  #+(or x86 x86-64) (initialize-x86-disassembler))

(defun initialize-native-target ()
  (initialize-target-info)
  (initialize-target)
  (initialize-target-mc)
  (initialize-asm-printer)
  (initialize-asm-parser)
  (initialize-disassembler))
