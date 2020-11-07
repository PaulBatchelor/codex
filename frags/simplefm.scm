;; simplefm.scm, a generated file
(define (simplefm trig freq ft)
  (let
      ((t (monolith:nextfree 0)))
    (begin
      (trig)
      (tenvx zz 0.001 0.001 0.3)
      (bhold (cabtmp zz))
      (cabset zz t)
      (fosc
       (freq)
       (scale (cabget t) 0 0.3)
       (param 1)
       (param 1)
       (scale (cabget t) 0 3)
       ft)
      (cabclr t))))
