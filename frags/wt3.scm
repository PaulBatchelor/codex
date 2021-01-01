(define wt3ft #("fbc95b71%"
                "2b94051d%"
                "babdb364%"))
(define (wt3-drone db freq rate pos)
  (wtcross
    (reggetf 0)
    (vector-ref wt3ft 2)
    (vector-ref wt3ft 1)
    (vector-ref wt3ft 0)
    (pdhalf
     (phasor (freq) 0)
     (randi (param -0.5) (param 0.7) (rate)))
    (pos)))
(define (wt3-notejumper note jump rate prob smooth)
  (tport
   (add (mul (maygate (dmetro 3) prob 0) jump) note) (tick) smooth))
(define (wt3-swarm db thekey)
  (let ((key thekey))
    (wt3-drone
     db
     (lambda ()
     (mtof (wt3-notejumper key 2 5 0.1 0.2)))
     (paramf 0.2)
     (lambda () (randi 0 1 1)))
    (wt3-drone
     db
     (lambda ()
       (mtof (wt3-notejumper (- key 5) 2 4 0.5 0.01)))
     (paramf 3)
     (lambda () (randi (param 0.5) (param 1) (randh 0.1 10 1))))
    (add zz zz)
    (wt3-drone
     db
     (lambda ()
       (mtof (wt3-notejumper (+ key 4) 3 3 0.5 0.01)))
       (paramf 0.5)
     (lambda () (randi 0 0.5 2)))
    (add zz zz)
    (wt3-drone
     db
     (lambda () (mtof (+ key 5))) (paramf 0.5)
     (lambda () (randi 0 0.5 3)))
    (add zz zz))
    (mul zz 0.3))
