;; Generated from modal.org
(define dahina-tabla #(1 2.89 4.95 6.99 8.01 9.02))
(define bayan-tabla #(1 2.0 3.01 4.01 4.69 5.63))
(define red-cedar-wood-plate #(1 1.47 2.09 2.56))
(define douglas-fir-wood-plate #(1 1.42 2.11 2.47))
(define uniform-wooden-bar #(1 2.572 4.644 6.984 9.723 12))
(define uniform-aluminum-bar #(1 2.756 5.423 8.988 13.448 18.680))
(define xylophone #(1 3.932 9.538 16.688 24.566 31.147))
(define vibraphone-1 #(1 3.984 10.668 17.979 23.679 33.642))
(define vibraphone-2 #(1 3.997 9.469 15.566 20.863 29.440))
(define chalandi-plates-freqs #(62 107 360 460 863))
(define chalandi-plates #(1 1.72581 5.80645 7.41935 13.91935))
(define tibetan-bowl-180mm-freqs
  #(221 614 1145 1804 2577 3456 4419))
(define tibetan-bowl-180mm
  #(1 2.77828 5.18099 8.16289 11.66063 15.63801 19.99))
(define tibetan-bowl-152mm-freqs
  #(314 836 1519 2360 3341 4462 5696))
(define tibetan-bowl-152mm
  #(1 2.66242 4.83757 7.51592 10.64012 14.21019 18.14027))
(define tibetan-bowl-140mm-freqs
  #(528 1460 2704 4122 5694))
(define tibetan-bowl-140mm
  #(1 2.76515 5.12121 7.80681 10.78409))
(define wine-glass
  #(1 2.32 4.25 6.63 9.38))
(define small-handbell-freqs
  #(1312.0 1314.5 2353.3 2362.9 3306.5 3309.4 3923.8 3928.2
    4966.6 4993.7 5994.4 6003.0 6598.9 6619.7 7971.7
    7753.2 8413.1 8453.3 9292.4 9305.2 9602.3 9912.4))
(define small-handbell
  #(1 1.0019054878049 1.7936737804878 1.8009908536585
      2.5201981707317 2.5224085365854 2.9907012195122
      2.9940548780488 3.7855182926829 3.8061737804878
      4.5689024390244 4.5754573170732 5.0296493902439
      5.0455030487805 6.0759908536585 5.9094512195122
      6.4124237804878 6.4430640243902 7.0826219512195
      7.0923780487805 7.3188262195122 7.5551829268293))
(define spinel-sphere-freqs
  #(977.25 1003.16 1390.13 1414.93 1432.84 1465.34 1748.48
           1834.20 1919.90 1933.64 1987.20 2096.48 2107.10
           2202.08 2238.40 2280.10 2400.88 2435.85 2507.80
           2546.30 2608.55 2652.35 2691.70 2708.00))
(define spinel-sphere
  #(1 1.026513174725 1.4224916858532 1.4478690202098
      1.4661959580455 1.499452545408 1.7891839345101
      1.8768994627782 1.9645945254541 1.9786543873113
      2.0334612432847 2.1452852391916 2.1561524686621
      2.2533435661294 2.2905090816065 2.3331798413917
      2.4567715528268 2.4925556408289 2.5661806088514
      2.6055768738808 2.6692760296751 2.7140956766436
      2.7543617293425 2.7710411870043))
(define pot-lid #(1 3.2 6.23 6.27 9.92 14.15))
(define (modal-impact trig
         freq11 freq12 Q11 Q12
         freq21 freq22 Q21 Q22)
  (trig)
  (mul zz 0.3)
  (bdup)
  (mode zz (freq11) (Q11))
  (bswap)
  (mode zz (freq12) (Q12))

  (add zz zz)
  (mul zz 0.5)

  (limit zz 0 3)

  (bdup)
  (bdup)
  (mode zz (freq21) (Q21))
  (bswap)
  (mode zz (freq22) (Q22))

  (add zz zz)
  (mul zz 0.5)
  (add zz zz)
  (dcblock zz))
(define (modal-wood-glass trig)
  (modal-impact
   trig
   (paramf 1000)
   (paramf 3000)
   (paramf 12)
   (paramf 8)
   (paramf 440)
   (paramf 888)
   (paramf 500)
   (paramf 420)))
(define (modal-felt-glass trig)
  (modal-impact
   trig
   (paramf 80)
   (paramf 188)
   (paramf 8)
   (paramf 3)
   (paramf 440)
   (paramf 888)
   (paramf 500)
   (paramf 420)))
(define (modal-wood-wood trig)
  (modal-impact
   trig
   (paramf 1000)
   (paramf 3000)
   (paramf 12)
   (paramf 8)
   (paramf 440)
   (paramf 630)
   (paramf 60)
   (paramf 53)))
(define (modal-felt-wood trig)
  (modal-impact
   trig
   (paramf 80)
   (paramf 180)
   (paramf 8)
   (paramf 3)
   (paramf 440)
   (paramf 630)
   (paramf 60)
   (paramf 53)))
(define (modal-wood-metal trig)
  (modal-impact
   trig
   (paramf 1000)
   (paramf 3000)
   (paramf 12)
   (paramf 8)
   (paramf 440)
   (paramf 888)
   (paramf 2000)
   (paramf 1630)))
(define (modal-felt-metal trig)
  (modal-impact
   trig
   (paramf 80)
   (paramf 180)
   (paramf 8)
   (paramf 3)
   (paramf 440)
   (paramf 888)
   (paramf 2000)
   (paramf 1630)))
(define (modal-metal-1 trig)
  (modal-impact
   trig
   (paramf 1000)
   (paramf 1800)
   (paramf 1000)
   (paramf 720)
   (paramf 440)
   (paramf 882)
   (paramf 500)
   (paramf 500)))
(define (modal-metal-2 trig)
  (modal-impact
   trig
   (paramf 1000)
   (paramf 1800)
   (paramf 1000)
   (paramf 850)
   (paramf 440)
   (paramf 630)
   (paramf 60)
   (paramf 53)))
(define (modal-metal-3 trig)
  (modal-impact
   trig
   (paramf 1000)
   (paramf 1800)
   (paramf 2000)
   (paramf 1720)
   (paramf 440)
   (paramf 442)
   (paramf 500)
   (paramf 500)))
(define (modal-strike-felt trig)
  (trig)
  (mul zz 0.3)
  (bdup)
  (mode zz 80 8)
  (bswap)
  (mode zz 180 3)
  (add zz zz)
  (mul zz 0.5)

  (limit zz 0 1))
(define (mkcab sig cab)
  (let ((r (monolith:nextfree cab)))
    (cabset (bhold (cabtmp (sig))) (param r))
    (eval r)))
(define (modal-tibet-bowl ex freq dec)
  (let* ((tab
         tibetan-bowl-152mm)
        (ex-r (mkcab ex 0))
        (freq-r (mkcab freq ex-r))
        (dec-r (mkcab dec freq-r)))
    (begin
      (mode
        (cabget ex-r)
        (cabget freq-r)
        (mul (cabget dec-r) (param 400)))
      (mode
        (cabget ex-r)
        (mul
         (cabget freq-r)
         (vector-ref tab 1))
        (mul (cabget dec-r) 800))
      (add zz zz)

      (mode
        (cabget ex-r)
        (mul
         (cabget freq-r)
         (vector-ref tab 2))
        (mul (cabget dec-r) 2000))
      (add zz zz)

      (mode
        (cabget ex-r)
        (mul
         (cabget freq-r)
         (vector-ref tab 3))
        (mul (cabget dec-r) 4000))
      (add zz zz)

      (mode
        (cabget ex-r)
        (mul
         (cabget freq-r)
         (vector-ref tab 4))
        (mul (cabget dec-r) 4000))
      (add zz zz)

      (add zz (cabget ex-r))

      (mul zz 0.3)
      (cabclr freq-r)
      (cabclr ex-r)
      (cabclr dec-r))))
(define (bell-drift nn)
  (modal-tibet-bowl
   (lambda ()
     (modal-strike-felt
      (lambda ()
        (begin
          (dmetro (randi 0.25 3 0.5))
          (bdup)
          (randh zz 0.5 1)
          (mul zz zz)))))
   (lambda () (mtof nn))
   (lambda () 2)))

(define (demo-tibet-bell)
  (display "compiling demo-tibet-bell")
  (newline)

  (bell-drift 75)
  (bell-drift 72)
  (add zz zz)
  (mul zz (ampdb -6))

  (bdup)

  (bdup)
  (revsc zz zz 0.97 10000)
  (bdrop)
  (dcblock zz)
  (mul zz 0.1)
  (add zz zz)

  (out zz))
