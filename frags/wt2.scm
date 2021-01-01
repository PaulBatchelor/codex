(define wt2-akwf-raw-3 "dcc56983%")
(define wt2-akwf-squ-15 "d0cbe594%")
(define wt2-akwf-9-899 "4406a8e8%")
(define (wt2-osc db id freq)
    (oscf (freq) (param 0) (lambda () (cratewav db id))))
(define (wt2-oscext db id phs)
    (oscfext (phs) (lambda () (cratewav db id))))
(define (wt2-mod1 db min max cutoff rate)
  (wt2-osc
   (reggetf 0)
   wt2-akwf-raw-3
   (lambda ()(biscale
              (wt2-osc (reggetf 0) wt2-akwf-9-899 rate)
              (min)
              (max))))
  (butlp zz (cutoff)))
(define (wt2-mod2 db min max lforate pd)
  (wt2-oscext db wt2-akwf-9-899
              (lambda ()
                (pdhalf
                 (phasor
                  (biscale
                   (wt2-osc
                    db wt2-akwf-squ-15
                    lforate)
                   (min) (max))
                  (param 0))
                 (pd)))))
(define (wt2-mod2-cool db)
  (wt2-mod2
   db
   (paramf 55)
   (paramf 200)
   (lambda () (randh 1 80 1.2))
   (lambda () (randi 0.1 0.9 1))))
(define (wt2-mod3 db freq pd rate min max)
  (wt2-oscext
   db
   wt2-akwf-9-899
   (lambda ()
     (pdhalf
      (phasor (freq) (param 0))
      (pd))))

  (biscale
   (wt2-osc
    db
    wt2-akwf-squ-15
    (lambda ()
      (biscale
       (wt2-osc db wt2-akwf-raw-3
                rate)
       (min)
       (max)))) 0 1)
  (mul zz zz))
(define (wt2-mod3-bubblysizzly db)
  (wt2-mod3 db
            (lambda () (randi
                        (param 70)
                        (param 85)
                        (param 0.2)))

            (lambda ()
              (randi
               (param -1)
               (param 1)
               (param 20)))
            (lambda () (randi 0.1 0.3 1))
            (paramf 1)
            (paramf 100)))
