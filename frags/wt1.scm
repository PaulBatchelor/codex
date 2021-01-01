(define vgsaw-0001 "5e9eafa5-5de6-4fbd-b8ac-00e69f236405")
(define vgsaw-0002 "d1e3643c-de81-40b2-b4e1-a249e2820faf")
(define vgsaw-0003 "2513a45d-8e7b-4148-a40d-3ff47e72322c")
(define vgtri-0013 "cf7c2f50-e428-4c6e-a96f-b6023bd850cb")
(define vgtri-0007 "7c33a809-9a23-420c-b854-c8820af0358f")
(define smpdb "s/a.db")

(define (load-the-wavetable)
(rvl (string-append (mkstring smpdb) " sqlite_open"))
(rvl (string-append (mkstring vgsaw-0001) " cratewav")))

(define (wt1-test)
    (oscf 330 0 load-the-wavetable)
    (mul zz 0.3)
)
(define (wt1-seq seq) (lambda () (gen_vals (ftnew 1) seq)))
(define (wt1-arps db)
  (let ((r (monolith:nextfree 0)))
    (regset (ftlist-new) r)
    (wt1-chords (lambda () (regget r)))

    (wt1-crazyclock
     (lambda ()
       (randh
        (param 0)
        (param 1)
        (randi 0.2 4 1))))

    ;;(bdup)
    ;;(tdiv zz (* 16 4) 0)
    ;;(bdup)
    ;;(tseq zz 0 (wt1-seq "0 1 0 2 0 1 0 3"))
    ;;(tchoose zz zz (lambda () (regget 0)))
    ;;(tlseq zz (lambda () (regget 0)))

    (wt1-progression
     zz
     "0 1 0 2 0 1 0 3"
     (lambda () (regget r)))

    (param 61)

    ;; some weird octave leaps
    ;; (maygate (metro 10) 0.3 0)
    ;; (mul zz -12)
    ;; (add zz zz)

    (add zz zz)
    (mtof zz)
    (oscf zz 0 (cratewavf db vgsaw-0001))
    (mul zz 0.3)
    (regclr r))

  ;; to 'break' it more
  ;;(metro 10)
  ;;(maygate zz 0.3 0)
  ;;(bswap)
  ;;(rpt zz zz (randh 120 200 30) (randh 4 64 1) (randh 8 64 11) (param 1.0))
)
(define (wt1-chords lst)
  (ftlist-append (wt1-seq "0 3 7 10") lst)
  (ftlist-append (wt1-seq "0 3 8 10") lst)
  (ftlist-append (wt1-seq "0 3 5 10") lst)
  (ftlist-append (wt1-seq "0 2 5 10") lst)
  (ftlist-choose 0 lst))
(define (wt1-crazyclock crazy)
  (param 25)
  (randi (param 1) (param 60) (randh 1 20 1))
  (crossfade zz zz (crazy))
  (metro zz))
(define (wt1-progression trig prog lst)
  (param trig)
  (bdup)
  (tdiv zz (* 16 4) 0)
  (bdup)
  (tseq zz 0 (wt1-seq prog))
  (tchoose zz zz lst)
  (tlseq zz lst))
