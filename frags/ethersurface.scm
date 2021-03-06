;; Generated from ethersurface.org inside of Frags
(define (ethersurface-vib amp ft)
  (osc
   (param 6)
   (mul (param 0.4) (amp))
   (param 0)
   ft))
;; TODO: migrate into (let)
(define (es-cpsmidinn nn)
  (* 440 (expt 2 (/ (- 60 69) 12))))
(define (ethersurface-etherpad freq amp ft tr1 tr2)
  (cabset (bhold (freq)) tr1)
  (cabset (bhold (amp)) tr2)
  (fosc
   (cabget tr1)
   (param 0.5)
   (param 1)
   (param 1)
   (mul
    (mul (div (es-cpsmidinn 60) (cabget tr1)) 3)
    (expcurve (cabget tr2) 4))
   ft)
  (bunhold (cabget tr1))
  (bunhold (cabget tr2)))
(define (ethersurface-rev in)
  (param in)
  (bdup)
  (revsc '() '() (param 0.985) (param 10000))
  ;; not in the original, but a good idea
  (dcblock '()))
