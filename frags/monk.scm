(define (chant-original)
  (rvl "
36 -0.1 0.1 1 4 0.2 randi randi add mtof
0.1 1 sine 0 1 biscale
0.9
0.9
0.3 1 sine 0 1 biscale
voc dcblock

36 mtof 70 5 eqfil

bdup bdup 0.97 10000 revsc bdrop -14 ampdb mul dcblock add
"))
(define (chant-pitch nn)
  (randi
   (param -0.1)
   (param 0.1)
   (randi 1 4 0.2))
  (add zz (nn)))
(define (chant-basic nn)
  (voc
   (mtof (chant-pitch nn))
   (biscale (sine 0.1 1) 0 1)
   (param 0.9)
   (param 0.9)
   (biscale (sine 0.3 1) 0 1)))
(define (chant-full)
  (chant-basic (paramf 36))
  (dcblock zz)

  (eqfil zz (mtof 36) (param 70) (param 5))
  (bdup)
  (bdup)
  (revsc zz zz 0.97 10000)
  (bdrop)
  (mul zz (ampdb -14))
  (dcblock zz)
  (add zz zz))
