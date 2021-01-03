(define wt5ft #("95c5afd8%"
                "0a8ae9e9%"
                "03cd822c%"
                "42e62539%"))
(define (wt5-exp1)
  (regset (sqlite-open (monolith:mkhome "s/a.db")) 0)
  (regset (ftlist-new) 1)


  (ftlist-append
   (cratewavf (reggetf 0) (vector-ref wt5ft 3))
   (reggetf 1))

  (ftlist-append
   (cratewavf (reggetf 0) (vector-ref wt5ft 0))
   (reggetf 1))

  (ftlist-append
   (cratewavf (reggetf 0) (vector-ref wt5ft 1))
   (reggetf 1))

  (ftlist-append
   (cratewavf (reggetf 0) (vector-ref wt5ft 2))
   (reggetf 1))

  (tabmorf
   (phasor (knobkit-param '(1 (0 0)) 0.01 1) 0)
   (knobkit-param '(0 (0 0)) 0 1)
   (reggetf 1))

  (mul zz 0.5))
(define (wt5-exp1load)
  (monolith:state-open (monolith:mkpath "play.db"))
  (knobkit-load "wt5-exp1")
  (monolith:state-close))
