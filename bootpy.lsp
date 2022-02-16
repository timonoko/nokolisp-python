
'((16 / 2 - 2022) (13 : 52 : 54 83))
(defq *package* BOOTPY)

(defq backquote (macro (x) (blockq2 x)))

(defun save
 (y x)
 (hex)
 (if
  (or (atom x) (not (identp y)))
  (progn
   (prints
    '*package*
    'name
    'assumed
    'to
    'be
    *package*)
   (cr)
   (setq x (eval *package*))
   (setq y
    (compress (nconc (explode *package*) (cons 46 (explode 'LSP)))))
   (prints 'filename 'assumed 'to 'be y)))
 (let
  ((back
    (compress
     (reverse
      (append (explode 'KAB) (member 46 (reverse (explode y))))))))
  (cr)
  (prints 'old y '=> back)
  (unlink back)
  (rename-file y back))
 (setq y (create y))
 (out y)
 (cr)
 (print (list 'quote (list (date) (time))))
 (cr)
 (print (list 'defq '*package* *package*))
 (cr)
 (mapc x
  (quote
   (lambda
    (x)
    (out 0)
    (cr)
    (print x)
    (out y)
    (cr)
    (if
     (eq *package* 'BOOT)
     (pprint (list 'defq x (definition-of x)))
     (ppr-def x (definition-of x)))
    (cr))))
 (out 0)
 (close y))

(defmacro lett
 (vars . rest)
 (backquote
  (quote
   (lambda , (if (caar vars) (mab car vars) vars) @ rest))
  @
  (if (caar vars) (mab cadr vars))))

(defun mab
 (m%f m%x)
 (if m%x
  (cons (m%f (car m%x)) (mab m%f (cdr m%x)))))

(defun blockq2
 (x)
 (cond
  ((atom x) x)
  ((eq (car x) ',)
   (list 'cons (cadr x) (blockq2 (cddr x))))
  ((eq (car x) '@)
   (list 'append (cadr x) (blockq2 (cddr x))))
  ((atom (car x))
   (list
    'cons
    (list 'quote (car x))
    (blockq2 (cdr x))))
  ((equal (car x) '',)
   (list
    'cons
    (list 'list 'quote (cadr x))
    (blockq2 (cddr x))))
  (t
   (list 'cons (blockq2 (car x)) (blockq2 (cdr x))))))

(defq BOOTPY (backquote save lett mab blockq2 BOOTPY))
