(define wt4ft #("905ca891%"
                 "19263c9c%"
                 "bd869e7a%"))
(define (wt4-osc3 db clk note)
  (let ((k (monolith:mkcab note 0)))
    (wtosc db (vector-ref wt4ft 0) (mtof (sub (cabget k) 24)))
    (wtosc db (vector-ref wt4ft 1) (mtof (sub (cabget k) 0.1)))
    (add zz zz)
    (wtosc db (vector-ref wt4ft 2) (mtof (add (cabget k) 0.11)))
    (add zz zz)
    (cabclr k))

  (let ((t (monolith:mkcab clk 0)))
    (wpkorg35 zz
              (scale (port (tgate (cabget t) 5) 8)
                     100 4000)
                     (scale (port (line (cabget t) 0 5 1) 0.1) 0.0 1.8) 0)
    (cabclr t))
  (mul zz 0.3))
(define (wt4-clumsy-the-clown db)
  (wtosc db
         (vector-ref wt4ft 0)
         (randh (param 0.01)
                (randh 1 25 0.3)
                (randi 0.5 2 0.5)))
  (maygate (dmetro 2) 0.7 0)
  (port zz 0.001)
  (mul zz zz)

  (biscale zz (randi 100 200 0.3) 800)
  (mul zz (scale (maygate (metro 4) 0.2 0) 0.5 1))
  (phasor zz 0)
  (bezier zz (randh 0 1 0.3) (randi 0 1 2))
  (mul zz (randi 1 4 0.2))
  (wtoscext db (vector-ref wt4ft 2) zz)
  (mul zz 0.1)
  (butlp zz
    (scale
     (tenv (maygate (dmetro 1) 0.5 1)
           0.9 0.1 0.1) 1000 8000)))
