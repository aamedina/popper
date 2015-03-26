;; asm/abi.lisp

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

(define-foreign-library c++abi
  (:darwin "libc++abi.dylib")
  (t (:default "libc++abi")))

(use-foreign-library c++abi)

;; // 2.4.2 Allocating the Exception Object
;; extern void * __cxa_allocate_exception(size_t thrown_size) throw();
;; extern void __cxa_free_exception(void * thrown_exception) throw();

(defcfun ("__cxa_allocate_exception" allocate-exception) :pointer
  (size :uint))

(defcfun ("__cxa_free_exception" free-exception) :void
  (exception :pointer))

;; // 2.4.3 Throwing the Exception Object
;; extern LIBCXXABI_NORETURN void __cxa_throw(void * thrown_exception,
;;         std::type_info * tinfo, void (*dest)(void *));

(defctype type-info :pointer)

(defcfun ("__cxa_throw" throw-exception) :void
  (exception :pointer)
  (info type-info)
  (dest :pointer))

;; // 2.5.3 Exception Handlers
;; extern void * __cxa_get_exception_ptr(void * exceptionObject) throw();
;; extern void * __cxa_begin_catch(void * exceptionObject) throw();
;; extern void __cxa_end_catch();
;; extern std::type_info * __cxa_current_exception_type();

(defcfun ("__cxa_get_exception_ptr" get-exception-ptr) :pointer
  (exception :pointer))

(defcfun ("__cxa_begin_catch" begin-catch) :pointer
  (exception :pointer))

(defcfun ("__cxa_end_catch" end-catch) :pointer)

(defcfun ("__cxa_current_exception_type" current-exception-type) type-info)

;; // 2.5.4 Rethrowing Exceptions
;; extern LIBCXXABI_NORETURN void __cxa_rethrow();

(defcfun ("__cxa_rethrow" rethrow) :void)

;; // 2.6 Auxiliary Runtime APIs
;; extern LIBCXXABI_NORETURN void __cxa_bad_cast(void);
;; extern LIBCXXABI_NORETURN void __cxa_bad_typeid(void);

(defcfun ("__cxa_bad_cast" bad-cast) :void)
(defcfun ("__cxa_bad_typeid" bad-typeid) :void)

;; // 3.2.6 Pure Virtual Function API
;; extern LIBCXXABI_NORETURN void __cxa_pure_virtual(void);

(defcfun ("__cxa_pure_virtual" pure-virtual) :void)

;; // 3.2.7 Deleted Virtual Function API
;; extern LIBCXXABI_NORETURN void __cxa_deleted_virtual(void);

(defcfun ("__cxa_deleted_virtual" deleted-virtual) :void)

;; // 3.3.2 One-time Construction API
;; extern int  __cxa_guard_acquire(uint64_t*);
;; extern void __cxa_guard_release(uint64_t*);
;; extern void __cxa_guard_abort(uint64_t*);

(defcfun ("__cxa_guard_acquire" guard-acquire) :int
  (guard :pointer))

(defcfun ("__cxa_guard_release" guard-release) :void
  (guard :pointer))

(defcfun ("__cxa_guard_abort" guard-abort) :void
  (guard :pointer))

;; // 3.3.3 Array Construction and Destruction API
;; extern void* __cxa_vec_new(size_t element_count,
;;                            size_t element_size,
;;                            size_t padding_size,
;;                            void (*constructor)(void*),
;;                            void (*destructor)(void*));

(defcfun ("__cxa_vec_new" make-vec) :pointer
  (element-count :uint)
  (element-size :uint)
  (padding-size :uint)
  (constructor :pointer)
  (destructor :pointer))

;; extern void* __cxa_vec_new2(size_t element_count,
;;                             size_t element_size,
;;                             size_t padding_size,
;;                             void  (*constructor)(void*),
;;                             void  (*destructor)(void*),
;;                             void* (*alloc)(size_t),
;;                             void  (*dealloc)(void*));

(defcfun ("__cxa_vec_new2" make-vec2) :pointer
  (element-count :uint)
  (element-size :uint)
  (padding-size :uint)
  (constructor :pointer)
  (destructor :pointer)
  (alloc :pointer)
  (dealloc :pointer))

;; extern void* __cxa_vec_new3(size_t element_count,
;;                             size_t element_size,
;;                             size_t padding_size,
;;                             void  (*constructor)(void*),
;;                             void  (*destructor)(void*),
;;                             void* (*alloc)(size_t),
;;                             void  (*dealloc)(void*, size_t));

(defcfun ("__cxa_vec_new3" make-vec3) :pointer
  (element-count :uint)
  (element-size :uint)
  (padding-size :uint)
  (constructor :pointer)
  (destructor :pointer)
  (alloc :pointer)
  (dealloc :pointer))

;; extern void __cxa_vec_ctor(void*  array_address,
;;                            size_t element_count,
;;                            size_t element_size,
;;                            void (*constructor)(void*),
;;                            void (*destructor)(void*));

(defcfun ("__cxa_vec_ctor" vec-ctor) :void
  (array-address :pointer)
  (element-count :uint)
  (element-size :uint)
  (constructor :pointer)
  (destructor :pointer))

;; extern void __cxa_vec_dtor(void*  array_address,
;;                            size_t element_count,
;;                            size_t element_size,
;;                            void (*destructor)(void*));

(defcfun ("__cxa_vec_dtor" vec-dtor) :void
  (array-address :pointer)
  (element-count :uint)
  (element-size :uint)
  (destructor :pointer))

;; extern void __cxa_vec_cleanup(void* array_address,
;;                              size_t element_count,
;;                              size_t element_size,
;;                              void  (*destructor)(void*));

(defcfun ("__cxa_vec_cleanup" vec-cleanup) :void
  (array-address :pointer)
  (element-count :uint)
  (element-size :uint)
  (destructor :pointer))

;; extern void __cxa_vec_delete(void*  array_address,
;;                              size_t element_size,
;;                              size_t padding_size,
;;                              void  (*destructor)(void*));

(defcfun ("__cxa_vec_delete" vec-delete) :void
  (array-address :pointer)
  (element-count :uint)
  (element-size :uint)
  (destructor :pointer))

;; extern void __cxa_vec_delete2(void* array_address,
;;                              size_t element_size,
;;                              size_t padding_size,
;;                              void  (*destructor)(void*),
;;                              void  (*dealloc)(void*));

(defcfun ("__cxa_vec_delete2" vec-delete2) :void
  (array-address :pointer)
  (element-size :uint)
  (padding-size :uint)
  (destructor :pointer)
  (dealloc :pointer))

;; extern void __cxa_vec_delete3(void* __array_address,
;;                              size_t element_size,
;;                              size_t padding_size,
;;                              void  (*destructor)(void*),
;;                              void  (*dealloc)(void*, size_t));

(defcfun ("__cxa_vec_delete3" vec-delete3) :void
  (array-address :pointer)
  (element-size :uint)
  (padding-size :uint)
  (destructor :pointer)
  (dealloc :pointer))

;; extern void __cxa_vec_cctor(void*  dest_array,
;;                             void*  src_array,
;;                             size_t element_count,
;;                             size_t element_size,
;;                             void  (*constructor)(void*, void*),
;;                             void  (*destructor)(void*));

(defcfun ("__cxa_vec_cctor" vec-cctor) :void
  (dest :pointer)
  (src :pointer)
  (element-count :uint)
  (element-size :uint)
  (constructor :pointer)
  (destructor :pointer))

;; // 3.3.5.3 Runtime API
;; extern int __cxa_atexit(void (*f)(void*), void* p, void* d);
;; extern int __cxa_finalize(void*);

(defcfun ("__cxa_atexit" atexit) :int
  (f :pointer)
  (p :pointer)
  (d :pointer))

(defcfun ("__cxa_finalize" finalize) :int
  (ptr :pointer))

;; // 3.4 Demangler API
;; extern char* __cxa_demangle(const char* mangled_name,
;;                             char*       output_buffer,
;;                             size_t*     length,
;;                             int*        status);

(defcfun ("__cxa_demangle" demangle) :string
  (mangled-name :string)
  (output-buffer :pointer)
  (length :pointer)
  (status :pointer))

