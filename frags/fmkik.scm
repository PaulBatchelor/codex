(define (fmkik trig freq c m i dst len tail body ft)
  (let* ((t (monolith:mkcab trig 0))
         (trigf (lambda () (cabget t))))
    (begin
      (cabget t)
      (tenvx
       zz
       (param 0.0001)
       (len)
       (tail))
      (fmkik-fm
       trigf
       freq
       c
       m
       (lambda () (expon (trigf) (i) (body) 0.001))
       ft)
      (mul zz zz)
      (mul zz (dst))
      (limit zz -1 1)

      (cabclr t))))
(define (fmkik-sine rt freq ft)
    (tphasor (rt) (freq) 0)
    (trd zz ft))
(define (fmkik-fm rt freq car mod indx ft)
  (let* ((o (lambda (f) (fmkik-sine rt f ft)))
        (freq-reg (monolith:mkcab freq 0))
        (fr (lambda () (cabget freq-reg)))
        (car-reg (monolith:mkcab car freq-reg))
        (c (lambda () (cabget car-reg)))
        (car-osc
         (lambda ()
           (mul
            (mul (indx) (mul (fr) (c)))
            (o (lambda () (mul (fr) (c))))))))
    (begin
      (o (lambda () (add (mul (fr) (mod)) (car-osc))))
      (cabclr freq-reg)
      (cabclr car-reg))))
(define (fmkik-default t ft)
  (fmkik
   t
   (paramf 60)
   (paramf 1)
   (paramf 1)
   (paramf 3)
   (paramf 2)
   (paramf 0.01)
   (paramf 0.1)
   (paramf 0.09)
   ft))
(define (fmkik-deep t ft)
  (fmkik
   t
   (paramf 20)
   (paramf 1)
   (paramf 2)
   (paramf 8)
   (paramf 3)
   (paramf 0.01)
   (paramf 0.15)
   (paramf 0.3)
   ft))
