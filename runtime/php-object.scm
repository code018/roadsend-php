;; ***** BEGIN LICENSE BLOCK *****
;; Roadsend PHP Compiler Runtime Libraries
;; Copyright (C) 2007 Roadsend, Inc.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public License
;; as published by the Free Software Foundation; either version 2.1
;; of the License, or (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Lesser General Public License for more details.
;; 
;; You should have received a copy of the GNU Lesser General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
;; ***** END LICENSE BLOCK *****

(module php-object
   (include "php-runtime.sch")
   (import (php-runtime "php-runtime.scm")
	   (elong-lib "elongs.scm")
	   (grass "grasstable.scm")
	   (php-hash "php-hash.scm")
	   (utils "utils.scm")
	   (php-errors "php-errors.scm"))
   (export
    +constructor-failed+
    (make-php-object properties)
    (php-object-custom-properties obj)
    (php-object-custom-properties-set! obj props)
    (pretty-print-php-object obj)
    (convert-to-object doohickey)
    (php-object-props obj)
    (php-class-props class-name)
    (php-object-is-subclass obj class-name)
;    (php-class-is-subclass subclass superclass)
    (php-object-is-a obj class-name)
    (php-class-exists? class-name)
    (php-class-methods class-name)
    (php-class-method-exists? class-name method-name)
    (call-php-method obj method-name . call-args)
    (call-php-method-0 obj method-name)
    (call-php-method-1 obj method-name arg)
    (call-php-method-2 obj method-name arg1 arg2)
    (call-php-method-3 obj method-name arg1 arg2 arg3)
    (call-php-parent-method parent-class-name obj method-name . call-args)
    (call-static-php-method class-name obj method-name . call-args)
    (php-object? obj)
    (php-object-for-each-with-ref-status obj::struct thunk::procedure)
    (php-object-property/index obj::struct property::int property-name)
    (php-object-property/string obj property::bstring)
    (php-object-property-ref/string obj property::bstring)
    (php-object-property-set!/string obj property::bstring value)
    (php-object-property-h-j-f-r/string obj property::bstring)
    (php-object-property obj property)
    (php-object-property-ref obj property)
    (php-object-property-set! obj property value)
;    (php-class-property klass property)
    (php-object-property-honestly-just-for-reading obj property)
    (php-object-compare obj1 obj2 identical?)
    (internal-object-compare o1 o2 identical? seen)
    (php-object-class obj)
    (php-object-parent-class obj)
    (copy-php-object obj::struct old-new)
    (init-php-object-lib)
    (define-php-class name parent-name)
    (define-extended-php-class name parent-name getter setter copier)
    (construct-php-object class-name . args)
    (construct-php-object-sans-constructor class-name)
    (get-declared-php-classes)
    (define-php-property class-name property-name value)
    (define-php-method class-name method-name method)    
    (define-class-constant class-name constant-name value)
    (lookup-class-constant class-name constant-name)))


;;;;objects, woohoo!
(define-struct %php-object
   ;;class is a pointer to the class of this object
   class
   ;;properties is a vector of properties
   properties
   ;;extended properties is either #f or a php-hash of additional properties
   extended-properties
   ;;this is where custom properties can be stored, for example
   custom-properties)

(define-struct %php-class
   ;;print-name is the name as the user wrote it
   print-name
   ;;the canonical name of this class
   name
   ;;a pointer to the parent class of this class
   parent-class
   ;; the constructor method
   constructor
   ;;a hashtable mapping names of declared properties to an index in a property vector
   declared-property-offsets
   ;;properties is a vector of properties
   properties
   ;;extended properties is either #f or a php-hash of non-declared properties
   extended-properties
   ;;methods is a php-hash of methods
   methods
   ;;this overrides the normal property lookup
   custom-prop-lookup
   ;;this overrides the normal property set
   custom-prop-set
   ;;the copier for the custom properties
   custom-prop-copy
   ;; PHP5 "class constants"
   class-constants)

(define (php-object-custom-properties obj)
   "returns whatever the custom context was set to when defining the extended class"
   (%php-object-custom-properties obj))

(define (php-object-custom-properties-set! obj props)
   "returns whatever the custom context was set to when defining the extended class"
   (%php-object-custom-properties-set! obj props))

(define (copy-properties-vector old-properties)
   (let* ((properties-len (vector-length old-properties))
	  (new-properties (make-vector properties-len '())))
      (let loop ((i 0))
	 (when (< i properties-len)
	    (let ((old-prop (vector-ref old-properties i)))
	       (if (container-reference? old-prop)
		   (vector-set! new-properties i old-prop)
		   (vector-set! new-properties i
				(copy-php-data old-prop))))
	    (loop (+ i 1))))
      new-properties))

(define (copy-php-object obj::struct old-new)
   (let* ((new-obj (%php-object (%php-object-class obj) #f #f #f)))
      ;;copy the old declared properties
      (%php-object-properties-set!
       new-obj (copy-properties-vector (%php-object-properties obj)))
      ;;copy the old extended properties, if any
      (when (%php-object-extended-properties obj)
	 (%php-object-extended-properties-set!
	  new-obj
	  (copy-php-hash (%php-object-extended-properties obj) old-new)))
      (when (%php-object-custom-properties obj)
	 (%php-object-custom-properties-set!
	  new-obj
	  (let ((c (%php-class-custom-prop-copy (%php-object-class obj))))
	     (if c
		 (c (%php-object-custom-properties obj))
		 (error 'copy-php-object "no custom copier defined for object with custom properties" obj)))))
      new-obj))


(define (make-php-object properties)
   "Make an instance of an anonymous class with properties but no
methods.  Feed me a php-hash where the keys are the properties and the
values the values."
   (let ((new-object (construct-php-object 'stdclass)))
      (unless (php-hash? properties)
	 (error 'make-php-object "properties must be a php-hash" properties))
      (%php-object-extended-properties-set! new-object properties)
      new-object))

;for type coercion 
(define (convert-to-object doohickey)
   (when (container? doohickey)
      (set! doohickey (container-value doohickey)))
   (cond
      ((php-object? doohickey) doohickey)
      ((php-null? doohickey) (make-php-object (make-php-hash)))
      ((php-hash? doohickey) (make-php-object doohickey))
      (else
       (make-php-object (let ((props (make-php-hash)))
 			   (php-hash-insert! props "scalar" doohickey)
 			   props)))))
	  

(define (php-object-props obj)
   "return a php-hash of the keys and properties in an object"
   (if (not (php-object? obj))
       #f
       (let ((property-hash (make-php-hash))
	     (offsets-table (%php-class-declared-property-offsets
					(%php-object-class obj)))
	     (declared-props (%php-object-properties obj)))
	  ;;first copy in the declared properties. we loop over the vector instead
	  ;;of for-each'ing over the hashtable to preserve the ordering.
	  (let loop ((i 0))
	     (when (< i (vector-length declared-props))
		(let ((prop-value (vector-ref declared-props i)))
		   (php-hash-insert! property-hash
				     ;note the reverse lookup to get the name
				     (hashtable-get offsets-table i)
				     (if (container-reference? prop-value)
					 prop-value
					 (container-value prop-value)))
		   (loop (+fx i 1)))))
	  ;;now copy in the extended properties
	  (php-hash-for-each (%php-object-extended-properties obj)
	     (lambda (k v)
		(php-hash-insert! property-hash k v)))
	  property-hash)))

(define (php-object-for-each-with-ref-status obj::struct thunk::procedure)
   "Thunk will be called once on each key/value set. ref status is available to thunk"
   (let ((property-hash (make-php-hash))
	 (offsets-table (%php-class-declared-property-offsets
			 (%php-object-class obj)))
	 (declared-props (%php-object-properties obj)))
      (let loop ((i 0))
	 (when (< i (vector-length declared-props))
	    (let ((prop-value (vector-ref declared-props i)))
;  	       (fprint (current-error-port) "key is " (mkstr (hashtable-get offsets-table i)))
;  	       (fprint (current-error-port) "value is " (mkstr prop-value))
;  	       (fprint (current-error-port) "ref-status is " (mkstr (container-reference? prop-value)))
	       (thunk ;note the reverse lookup to get the name
		(mkstr (hashtable-get offsets-table i))
;		(if (container-reference? prop-value)
		(maybe-unbox prop-value)
		;		    (container-value prop-value))
		(container-reference? prop-value))
	       (loop (+fx i 1)))))
      ;;now copy in the extended properties
      (php-hash-for-each-with-ref-status
       (%php-object-extended-properties obj) thunk)))

(define (php-class-props class-name)
   "return a php-hash of the keys and properties in a class"
   (let ((the-class (%lookup-class class-name)))
      (if (not (%php-class? the-class))
	  #f
	  (let ((property-hash (make-php-hash))
		(offsets-table (%php-class-declared-property-offsets the-class))
		(declared-props (%php-class-properties the-class)))
	     ;;first copy in the declared properties. we loop over the vector instead
	     ;;of for-each'ing over the hashtable to preserve the ordering.
	     (let loop ((i 0))
		(when (< i (vector-length declared-props))
		   (let ((prop-value (vector-ref declared-props i)))
		      (php-hash-insert! property-hash
					;note the reverse lookup to get the name
					(hashtable-get offsets-table i)
					(if (container-reference? prop-value)
					    prop-value
					    (container-value prop-value)))
		      (loop (+fx i 1)))))
	     ;;now copy in the extended properties
	     (php-hash-for-each (%php-class-extended-properties the-class)
		(lambda (k v)
		   (php-hash-insert! property-hash k v)))
	     property-hash))))

(define (php-object-is-subclass obj class-name)
   (if (not (php-object? obj))
       #f
       (let ((the-class (%lookup-class class-name)))
	  (if (not (%php-class? the-class))
	      #f
	      (%subclass? (%php-object-class obj) the-class)))))

; (define (php-class-is-subclass subclass superclass)
;    (let ((the-subclass (%lookup-class subclass))
; 	 (the-superclass (%lookup-class superclass)))
;       (unless (%php-class? the-subclass)
; 	 (debug-trace 1 "warning, class " subclass " not defined"))
;       (unless (%php-class? the-superclass)
; 	 (debug-trace 1 "warning, class " superclass " not defined"))
;       (and (%php-class? the-subclass)
; 	   (%php-class? the-superclass)
; 	   (%subclass? the-subclass the-superclass))))

(define (php-object-is-a obj class-name)
   (if (not (php-object? obj))
       (begin
	  (debug-trace 4 "php-object-is-a: not an object")
	  #f)
       (let ((the-class (%lookup-class class-name)))
	  (if (not (%php-class? the-class))
	      (begin
		 (debug-trace 4 "php-object-is-a: not a class")
		 #f)
	      (or (eqv? (%php-object-class obj) the-class)
		  (begin
		     (debug-trace 4 "php-object-is-a: not eqv?")
		     #f)
		  (%subclass? (%php-object-class obj) the-class)
		  (begin
		     (debug-trace 4 "php-object-is-a: not subclass")
		     #f))))))

(define (php-class-exists? class-name)
   (let ((c (%lookup-class class-name)))
      (if (%php-class? c)
	  #t
	  #f)))

(define (php-class-methods class-name)
   (let ((the-class (%lookup-class class-name)))
      (if (not the-class)
	  #f
	  (%php-class-method-reflection the-class))))

(define (php-class-method-exists? class-name method-name)
   (let ((mlist (php-class-methods class-name)))
      (if (not (eqv? mlist #f))
	  (php-hash-in-array? mlist (string-downcase (mkstr method-name)) #f)
	  #f)))

(define (method-minimum-arity method)
   ;;one less than the procedure arity, since the first argument is $this
   (-fx (let ((c (procedure-arity method)))
	   (if (<fx c 0)
	       (-fx (- c) 1)
	       c))
	1))

(define (method-correct-arity? method::procedure arity::int)
   (correct-arity? method (+ 1 arity)))

(define (call-php-method obj method-name . call-args)
   (if (not (php-object? obj))
       (php-error "Unable to call method on non-object " obj)
       (let ((the-method (%lookup-method (%php-object-class obj) method-name)))
	  (unless the-method
	     (php-error "Calling method "
			(%php-class-print-name (%php-object-class obj))
			"->" method-name ": undefined method."))
	  ;; We could just apply the method to (map maybe-box call-args), but
	  ;; that won't signal a nice error for methods compiled in extensions.
          (apply the-method obj (adjust-argument-list the-method call-args)))))
; 	  (let loop ((i 1)
; 		     (args '())
; 		     (call-args call-args))
; 	     (if (pair? call-args)
; 		 (loop (+fx i 1)
; 		       (cons (maybe-box (car call-args)) args)
; 		       (cdr call-args))
; 		 (if (method-correct-arity? the-method i)
; 		     (apply the-method obj;(maybe-box obj)
; 			    (reverse! args))
; 		     (php-warning "Wrong number of arguments for method "
;                                   (%php-class-print-name (%php-object-class obj)) "->" method-name ": "
;                                   (method-minimum-arity the-method) " expected, "
;                                   (-fx i 1) " provided.")))))))

(define (adjust-argument-list method args)
   ;; make sure the arguments are boxed and that the arity is okay.
   (if (method-correct-arity? method (length args))
       (map maybe-box args)
       (let ((minimum-arity (method-minimum-arity method)))
          (let loop ((i 0)
                     (new-args '())
                     (args args))
             (if (= i minimum-arity)
                 (reverse! new-args)
                 (if (pair? args)
                     (loop (+ i 1)
                           (cons (maybe-box (car args)) new-args)
                           (cdr args))
                     (loop (+ i 1)
                           (cons (make-container NULL) new-args)
                           '())))))))

(define (call-php-method-0 obj method-name)
   (if (not (php-object? obj))
       (php-error
	(format "Unable to call method on non-object ~A" (mkstr obj)))
       (let ((the-method (%lookup-method (%php-object-class obj) method-name)))
	  (unless the-method
	     (php-error "Calling method "
			(%php-class-print-name (%php-object-class obj))
			"->" method-name ": undefined method."))
	  (the-method obj))))

(define (call-php-method-1 obj method-name arg)
   (if (not (php-object? obj))
       (php-error
	(format "Unable to call method on non-object ~A" (mkstr obj)))
       (let ((the-method (%lookup-method (%php-object-class obj) method-name)))
	  (unless the-method
	     (php-error "Calling method "
			(%php-class-print-name (%php-object-class obj))
			"->" method-name ": undefined method."))
	  (the-method obj (maybe-box arg))) ))

(define (call-php-method-2 obj method-name arg1 arg2)
   (if (not (php-object? obj))
       (php-error
	(format "Unable to call method on non-object ~A" (mkstr obj)))
       (let ((the-method (%lookup-method (%php-object-class obj) method-name)))
	  (unless the-method
	     (php-error "Calling method "
			(%php-class-print-name (%php-object-class obj))
			"->" method-name ": undefined method."))
	  (the-method obj (maybe-box arg1) (maybe-box arg2))) ))

(define (call-php-method-3 obj method-name arg1 arg2 arg3)
   (if (not (php-object? obj))
       (php-error
	(format "Unable to call method on non-object ~A" (mkstr obj)))
       (let ((the-method (%lookup-method (%php-object-class obj) method-name)))
	  (unless the-method
	     (php-error "Calling method "
			(%php-class-print-name (%php-object-class obj))
			"->" method-name ": undefined method."))
	  (the-method obj (maybe-box arg1) (maybe-box arg2) (maybe-box arg3))) ))

(define (call-php-parent-method parent-class-name obj method-name . call-args)
   (let ((the-class (%lookup-class parent-class-name)))
      (unless the-class
	 (php-error
	  (format "Parent method call: Unable to call method parent::~A: can't find parent class ~A"
		  method-name parent-class-name)))
      (let ((the-method (%lookup-method the-class method-name)))
	 (unless the-method
	    (php-error "Parent method call: Unable to find method "
		     method-name " of class " parent-class-name))
	 (apply the-method obj (adjust-argument-list the-method call-args)))))


(define (call-static-php-method class-name obj method-name . call-args)
   (let ((the-class (%lookup-class class-name)))
      (unless the-class
	 (php-error "Calling static method " method-name
		    ": unable to find class definition " class-name))
      (let ((the-method (%lookup-method the-class method-name)))
	 (unless the-method
	    (php-error "Calling static method " class-name "::" method-name ": undefined method."))
         (apply the-method obj (adjust-argument-list the-method call-args)))))


(define (php-object? obj)
   (%php-object? obj))

(define (get-custom-lookup obj)
   (%php-class-custom-prop-lookup
    (%php-object-class obj)))

(define (get-custom-set obj)
   (%php-class-custom-prop-set
    (%php-object-class obj)))

(define (php-object-property/index obj::struct property::int property-name)
   "this is just for declared classes in user code.  it's an optimization."
   (assert (property property-name) (= (hashtable-get (%php-class-declared-property-offsets (%php-object-class obj))
						      (%property-name-canonicalize property-name))
				       property))
   (vector-ref (%php-object-properties obj) property)
   
   )


(define (php-object-property obj property)
   (if (php-object? obj)
       (if (procedure? (get-custom-lookup obj))
	   (do-custom-lookup obj property #f)
	   (%lookup-prop obj property))
       (begin
	  (php-warning "Referencing a property of a non-object")
	  NULL)))

(define (php-object-property-honestly-just-for-reading obj property)
   (if (php-object? obj)
       (let ((l (get-custom-lookup obj)))
	  (if (procedure? l)
	      (do-custom-lookup obj property #f)	      
	      (%lookup-prop-honestly-just-for-reading obj property)))
       (begin
	  (php-warning "Referencing a property of a non-object")
	  NULL)))

(define (php-object-property-ref obj property)
   (if (php-object? obj)
       (let ((l (get-custom-lookup obj)))
	  (if (procedure? l)
	      (do-custom-lookup obj property #t)
	      (%lookup-prop-ref obj property)))
       (begin
	  (php-warning "Referencing a property of a non-object")
	  (make-container NULL))))

(define (php-object-property-set! obj property value)
   (if (php-object? obj)
       (let ((l (get-custom-set obj)))
	  (if (procedure? l)
	      (do-custom-set! obj property value)
	      (%assign-prop obj property value)))
       (begin
	  (php-warning "Assigning to a property of a non-object")
	  NULL))
   value)


(define (do-custom-lookup obj property ref?)
   (debug-trace 4 "custom lookup of " (php-object-class obj) "->" property)
;   (if ref?
       ;; so spake the engine of zend
;       (php-error "Cannot create references to overloaded objects")
       (let loop ((cls (%php-object-class obj)))
	  (let ((lookup (%php-class-custom-prop-lookup cls)))
	     (if (procedure? lookup)
		 (let ((val (lookup obj property ref? (lambda ()
							 (loop (%php-class-parent-class cls))))))
		    (if ref? (maybe-box val) (maybe-unbox val)))
		 (if ref?
		     (%lookup-prop-ref obj property)
		     (%lookup-prop obj property))))))
;)

(define (do-custom-set! obj property value)
   (let loop ((cls (%php-object-class obj)))
      (let ((set (%php-class-custom-prop-set cls)))
	 (if (procedure? set)
	     (set obj property (container? value) value  (lambda ()
							   (loop (%php-class-parent-class cls))))
	     (%assign-prop obj property value)))))

(define (php-object-compare o1 o2 identical?)
   (internal-object-compare o1 o2 identical? (make-grasstable)))

(define (internal-object-compare o1 o2 identical? seen)
   (let ((compare-declared-properties
	  (lambda (o1 o2 seen)
	     (let loop ((i 0)
		       (continue? #t))
	       (if (>= i (vector-length (%php-object-properties o1)))
		   #t
		   (if continue?
		       (loop (+ i 1)
			     (let ((o1-value (vector-ref (%php-object-properties o1) i))
				   (o2-value (vector-ref (%php-object-properties o2) i)))
				(cond
				   ((and (php-object? o1-value)
					 (php-object? o2-value))
				    (if (and (grasstable-get o1-value seen)
					     (grasstable-get o2-value seen))
                                        #t
					(internal-object-compare o1-value o2-value identical? seen)))
				   ((and (php-hash? o1-value)
					 (php-hash? o2-value))
				    (if (and (grasstable-get o1-value seen)
					     (grasstable-get o2-value seen))
                                        #t
                                        (zero? (internal-hash-compare o1-value o2-value identical? seen))))
				   (else
				    ((if identical? identicalp equalp) o1-value o2-value)))))
		       #f)))))
	 ;;differently ordered properties in objects mean that they are not ===,
	 ;;but since the objects have to be of the same class to be compared,
	 ;;and the same class naturally declares its properties in the same
	 ;;order, that can only happen in the extended properties.
	 ;;internal-hash-compare will handle it properly, so we don't need to
	 ;;explicitly property order at all.
	 (compare-extended-properties
	  (lambda (o1 o2 seen)
	     (if (%php-object-extended-properties o1)
		(if (%php-object-extended-properties o2)
                    (let ((value (zero? (internal-hash-compare (%php-object-extended-properties o1)
                                                               (%php-object-extended-properties o2)
                                                               identical? seen))))
                       value)
		    #f)
		(if (%php-object-extended-properties o2)
		    #f
		    #t)))))
      ;;the return value is #f if the objects are of different classes
      ;;0 if they are identical, 1 if they are different (but of the same class)
      (if (not (string=? (php-object-class o1)
			 (php-object-class o2)))
	  #f
	  ;only compare objects of the same class
	  (begin
	     (grasstable-put! seen o1 #t)
	     (grasstable-put! seen o2 #t)
	     (if (and (compare-declared-properties o1 o2 seen)
		      (compare-extended-properties o1 o2 seen))
		 0
		 1)))))

   
(define (php-object-class obj)
   (if (not (php-object? obj))
       #f
       (%php-class-print-name (%php-object-class obj))))

(define (php-object-parent-class obj)
   (if (not (php-object? obj))
       #f
       (%php-class-print-name
	(%php-class-parent-class
	 (%php-object-class obj)))))
	
(define (%class-name-canonicalize name)
   "define class names as case-insensitive strings"
   ;   (string->symbol
   (string-downcase (mkstr name)))
    ;))

(define (%method-name-canonicalize name)
   "define method names as case-insensitive strings"
   ;   (string->symbol
   (string-downcase (mkstr name)))
;)

(define (%property-name-canonicalize name)
   "define property names as case-_sensitive_ strings"
   (if (string? name) name (mkstr name)))
;   (string->symbol (mkstr name)))

(define %php-class-registry 'unset)

(define (get-declared-php-classes)
   (let ((clist (make-php-hash)))
      (hashtable-for-each %php-class-registry
			  (lambda (k v)
			     (php-hash-insert! clist :next (%php-class-print-name v))))
      clist))

(define (init-php-object-lib)
   ;can't allow the class registry to live between requests
;   (unless (hashtable? %php-class-registry)
   (set! %php-class-registry (make-hashtable))
   ;define the root of the class hierarchy
   (let ((stdclass (%php-class "stdClass" "stdclass" #f #f
			       (make-hashtable) (make-vector 0)
			       (make-php-hash) (make-php-hash)
			       #f #f #f (make-php-hash)))
	 (inc-class (%php-class "__PHP_Incomplete_Class" "__php_incomplete_class" #f #f
				(make-hashtable) (make-vector 0)
				(make-php-hash) (make-php-hash)
				#f #f #f (make-php-hash)) ))
      ;;default constructor
;      (php-hash-insert! (%php-class-methods stdclass) "stdclass" (lambda args #t))
      (hashtable-put! %php-class-registry "stdclass" stdclass)
      (hashtable-put! %php-class-registry "__php_incomplete_class" inc-class)))


(define (define-php-class name parent-name)
   (if (%lookup-class name)
       #t ;leave the errors to the evaluator/compiler for now
       (let ((parent-class (if (null? parent-name)
			       (%lookup-class "stdclass")
			       (%lookup-class parent-name))))
	  (unless parent-class
	     (php-error "Defining class " name ": unable to find parent class " parent-name))
	  (let* ((canonical-name (%class-name-canonicalize name))
		 (new-class (%php-class (string-downcase (mkstr name))
					canonical-name
					parent-class
                                        #f
					(copy-hashtable
					 (%php-class-declared-property-offsets parent-class))
					(copy-properties-vector (%php-class-properties parent-class))
					(copy-php-data (%php-class-extended-properties parent-class))
					(copy-php-data (%php-class-methods parent-class))
					(%php-class-custom-prop-lookup parent-class)
					(%php-class-custom-prop-set parent-class)
					(%php-class-custom-prop-copy parent-class)
                                        (copy-php-data (%php-class-class-constants parent-class)))))
	     ;copy default constructor
	     ;; (unless (convert-to-boolean (php-hash-lookup (%php-class-methods new-class)
;; 							  canonical-name))
;; ;		(fprint (current-error-port) "copying default constructor for class " canonical-name
;; ;			" found " (%lookup-constructor parent-class))
;; 		(php-hash-insert! (%php-class-methods new-class)
;; 				  canonical-name
;; 				  (%lookup-constructor parent-class)
;; ; 				  (php-hash-lookup
;; ; 				   (%php-class-methods parent-class)
;; ; 				   (%method-name-canonicalize parent-name))
;; 				  ))
	     (hashtable-put! %php-class-registry canonical-name new-class)))))

(define (define-extended-php-class name parent-name getter setter copier)
   "Create a PHP class with an overridden getter and setter.  The getter takes
four arguments: the object, the property, ref?, and the continuation.  The
continuation is a procedure of no arguments that can be invoked to get the
default property lookup behavior.  The setter takes an additional value
argument, before the continuation: (obj prop ref? value k)."
   ;xxx and a copier, and they can be false to inherit...
   (define-php-class name parent-name)
   (let ((klass (%lookup-class name)))
      (if (%php-class? klass)
	  (begin
	     (when getter (%php-class-custom-prop-lookup-set! klass getter))
	     (when setter (%php-class-custom-prop-set-set! klass setter))
	     (when copier (%php-class-custom-prop-copy-set! klass copier))
	     ;we set the print-name to be like php-gtk with its CamelCaps
	     (%php-class-print-name-set! klass name))
	  (error 'define-extended-php-class "could not define extended class" name))))


(define (copy-hashtable table)
   (let ((new-table (make-hashtable)))
      (hashtable-for-each table
	 (lambda (k v)
	    (hashtable-put! new-table k v)))
      new-table))

(define (cruddy-push-extend el vec)
   ;yay, quadratic
   (let ((new (make-vector (+ 1 (vector-length vec)) '())))
      (let loop ((i 0))
	 (if (< i (vector-length vec))
	     (begin
		(vector-set! new i (vector-ref vec i))
		(loop (+ i 1)))
	     (vector-set! new i el)))
      new))

(define (define-php-method class-name method-name method)
   (let ((the-class (%lookup-class class-name)))
      (unless the-class
	 (php-error "Defining method " method-name ": unknown class " class-name))
      (let ((method-name (%method-name-canonicalize method-name)))
         ;; check if the method is a constructor
         (if PHP5?
             (when (or (string=? method-name "__construct")
                       (and (not (%php-class-constructor the-class))
                            (string=? method-name (%php-class-name the-class))))
                (%php-class-constructor-set! the-class method))
             (when (string=? method-name (%php-class-name the-class))
                (%php-class-constructor-set! the-class method)))
         (php-hash-insert! (%php-class-methods the-class)
                           method-name
                           method))))

(define (define-php-property class-name property-name value)
   (let ((the-class (%lookup-class class-name)))
      (unless the-class
	 (php-error "Defining property " property-name ": unknown class " class-name))
      (let* ((properties (%php-class-properties the-class))
	     (offset (vector-length properties))
             (canonical-name (%property-name-canonicalize property-name)))
         (aif (hashtable-get (%php-class-declared-property-offsets the-class) canonical-name)
              ;; already defined, just set it
              (vector-set! properties it (make-container (maybe-unbox value)))
              ;; not defined yet, extend the properties vector and add
              ;; a new entry in the offset map
              (begin
                 (%php-class-properties-set!
                  the-class
                  (cruddy-push-extend (make-container (maybe-unbox value)) properties))
                 (hashtable-put! (%php-class-declared-property-offsets the-class)
                                 canonical-name
                                 offset)
                 ;store the reverse, too
                 (hashtable-put! (%php-class-declared-property-offsets the-class)
                                 offset
                                 canonical-name))))))

(define (%lookup-class name)
   (hashtable-get %php-class-registry (%class-name-canonicalize name)))

;;I think that all methods must be manifest when a class is defined
;;(i.e. before calling any of them), so we don't look at the parent
;;class.
(define (%lookup-method klass name)
   (let ((m (php-hash-lookup (%php-class-methods klass) name)))
      (if (null? m)
	  (begin
	     ;	     (fprint (current-error-port) "slow path: " name)
	     ;;the slow path -- funky method case, method in superclass, etc
	     (let ((cname (%method-name-canonicalize name)))
		;;first we try looking the method up again, using the canonical name
		(let loop ((super klass))
		   (if (%php-class? super)
		       (let ((m (php-hash-lookup (%php-class-methods super) cname)))
			  (if (null? m)
			      ;;still not found, try the superclass
			      (loop (%php-class-parent-class super))
			      ;;found it.  store it for the next time.
			      (begin
				 (php-hash-insert! (%php-class-methods klass) cname m)
				 m)))
		       ;; there is no parent class, method not found.
		       #f))))
	  m)))

(define (%lookup-constructor klass)
   (or
    (%php-class-constructor klass)
    (let ((c (and (%php-class-parent-class klass)
                  (%lookup-constructor (%php-class-parent-class klass)))))
       (if c
           (begin
              (%php-class-constructor-set! klass c)
              c)
           #f))))

(define (%prop-offset obj prop-canon-name)
   (hashtable-get
    (%php-class-declared-property-offsets
     (%php-object-class obj))
    prop-canon-name))

;;;;the actual property looker-uppers
(define (%lookup-prop-ref obj property)
   (let* ((canon-name (%property-name-canonicalize property))
	  (offset (%prop-offset obj canon-name)))
      (if offset	  
	  (vector-ref (%php-object-properties obj) offset)
	  (php-hash-lookup-ref (%php-object-extended-properties obj)
			       #t
			       canon-name))))

(define (%lookup-prop obj property)
   (container-value (%lookup-prop-ref obj property)))
;   (php-hash-lookup (%php-object-properties obj)
;		    (%property-name-canonicalize property)))

(define (%lookup-prop-honestly-just-for-reading obj property)
   (let* ((canon-name (%property-name-canonicalize property))
	  (offset (%prop-offset obj canon-name)))
      (if offset
	  (container-value (vector-ref (%php-object-properties obj) offset))
	  ;XXX this wasn't here.. copying bug?
	  (php-hash-lookup-honestly-just-for-reading
	   (%php-object-extended-properties obj)
	   canon-name) )))


(define (%assign-prop obj property value)
   (let* ((canon-name (%property-name-canonicalize property))
	  (offset (%prop-offset obj canon-name)))
      (if offset
	  ;declared property
	  (if (container? value)
	      ;reference insert, like for php-hash
              (vector-set! (%php-object-properties obj) offset (container->reference! value))
              (let ((current-value (vector-ref (%php-object-properties obj) offset)))
                 (if (container? current-value)
                     (container-value-set! current-value value)
                     (vector-set! (%php-object-properties obj) offset (make-container value)))))
   	  ;undeclared property
          (php-hash-insert! (%php-object-extended-properties obj)
                            canon-name value)))

   value)


(define (%php-class-method-reflection klass)
   (list->php-hash
    (let ((lst '()))
       (php-hash-for-each (%php-class-methods klass)
	  (lambda (name method)
	     (set! lst (cons (mkstr name) lst))))
       lst)))

(define +constructor-failed+ (cons '() '()))
(define (construct-php-object class-name . args)
   (let ((the-class (%lookup-class class-name)))
      (unless the-class
	 (php-error "Unable to instantiate " class-name ": undefined class."))
      (let ((new-object (%php-object the-class
				     (copy-properties-vector
				      (%php-class-properties the-class))
				     (copy-php-data
				      (%php-class-extended-properties the-class))
				     #f)))
	 (let ((constructor (%lookup-constructor the-class)))
	    (if (not constructor)
                ;; no constructor defined
                new-object
                (if (eq? +constructor-failed+
                         (apply constructor new-object (adjust-argument-list constructor args)))
                    (begin
                       (php-warning "Could not create a " class-name " object.")
                       NULL)
                    new-object))))))


(define (construct-php-object-sans-constructor class-name)
   (let ((the-class (%lookup-class class-name)))
      (unless the-class
	 (php-error "Unable to instantiate " class-name ": undefined class."))
      (let ((new-object (%php-object the-class
				     (copy-properties-vector
				      (%php-class-properties the-class))
				     (copy-php-data
				      (%php-class-extended-properties the-class))
				     #f)))
	 new-object)))



(define (%subclass? class-a class-b)
   "is class-a a subclass of class-b?"
   (let ((parent (%php-class-parent-class class-a) ))
      (and parent
	   (or (eqv? parent class-b)
	       (%subclass? parent class-b)))))


;;;string versions, for compiled code
(define (php-object-property/string obj property::bstring)
   (php-object-property obj property))
;    (if (php-object? obj)
;        (%lookup-prop/string obj property)
;        (begin
; 	  (php-warning "Referencing a property of a non-object (did you use $this in a static method?)")
; 	  #f)))

(define (php-object-property-h-j-f-r/string obj property::bstring)
   (php-object-property-honestly-just-for-reading obj property))
;    (if (php-object? obj)
;        (%lookup-prop-h-j-f-r/string obj property)
;        (begin
; 	  (php-warning "Referencing a property of a non-object (did you use $this in a static method?)")
; 	  #f)))

(define (php-object-property-set!/string obj property::bstring value)
   (php-object-property-set! obj property value))
;    (if (php-object? obj)
;        (%assign-prop/string obj property value)
;        (begin
; 	  (php-warning "Assigning to a property of a non-object (did you use $this in a static method?)")
; 	  #f))
;    value)

(define (php-object-property-ref/string obj property::bstring)
   (php-object-property-ref obj property))
;    (if (php-object? obj)
;        (%lookup-prop-ref/string obj property)
;        (begin
; 	  (php-warning "Referencing a property of a non-object (did you use $this in a static method?)")
; 	  (make-container #f))))

(define (%lookup-prop-ref/string obj property::bstring)
   (%lookup-prop-ref obj property))
;    (php-hash-lookup-ref (%php-object-properties obj)
; 			#t
; 			property))

(define (%lookup-prop/string obj property::bstring)
   (%lookup-prop obj property))
;    (php-hash-lookup (%php-object-properties obj) property))

(define (%lookup-prop-h-j-f-r/string obj property::bstring)
   (%lookup-prop-honestly-just-for-reading obj property))
;    (php-hash-lookup (%php-object-properties obj) property))


(define (%assign-prop/string obj property::bstring value)
   (%assign-prop obj property value))
;    (php-hash-insert! (%php-object-properties obj) property value)
;    value)
   
;;;end string versions


(define (pretty-print-php-object obj)
   (display "<php object, class: ")
   (display (%php-class-print-name
	     (%php-object-class obj)))
   (display ", properties: ")
   (php-object-for-each-with-ref-status
    obj
    (lambda (name value ref?)
       (display (mkstr name))
       (display "=>")
       (cond
	  ((php-hash? value)
	   (display "php-hash(")
	   (display (php-hash-size value))
	   (display ")"))
	  ((php-object? value)
	   (display "php-object(")
	   (display (%php-class-print-name
		     (%php-object-class obj)))
	   (display ")"))
	  (else (display (mkstr value))))
       (display " ")))
   (display ">"))


;;;; PHP5 "class constants".
(define (define-class-constant class-name constant-name value)
   (let ((the-class (%lookup-class class-name)))
      (unless the-class
         (php-error "Defining class constant " constant-name ": unknown class " class-name))
      (php-hash-insert! (%php-class-class-constants the-class) constant-name value)))

(define (lookup-class-constant class-name constant-name)
   (let ((fail (lambda ()
                  (php-error "Access to undeclared static property: "
                             class-name "::"  constant-name))))
      (let* ((the-class (%lookup-class class-name)))
         (unless the-class (fail))
         (unless (php-hash-contains? (%php-class-class-constants the-class)
                                     constant-name)
            (fail))
         (php-hash-lookup (%php-class-class-constants the-class)
                          constant-name))))

   
