(define (open-db-in-monolith)
  (sqlar:opendb "sqlite" (string-append (getenv "SMP_HOME") "/a.db")))

(define (loadsineft)
  (lvl "tabnew 2048 sineft")
  (lvl "gensine zz"))

(define (newsig sig)
  (let ((r (nxtfree)))
    (regset (hold (sig)) r)
    (regmrk r)
    r))

(define (clrsig r)
  (unhold (regget r))
  (regclr r))

(define (att amt)
  (mul zz (dblin amt)))

(define (crateload wtname uuid)
  (crate:wavk (lgrab "sqlite") wtname uuid))

(define loop15-base 58)
(define (loop15-init)
  (open-db-in-monolith)
  (loadsineft)
  (crateload "ilowfreq" "gerripsoe")
  (crateload "linb" "gjlkljfap")
  (glang:new "gl"))

(define (loop15-mel-redux cnd)
  (fmpair2
   (grab "sineft")
   (grab "ilowfreq")
   (begin
     (glang:gexprdb cnd (lgrab "gl") "score.db" "mel")
     (add zz loop15-base)
     (mtof zz))
   (param 1)
   (param 1.0)
   (glang:gexprdb cnd (lgrab "gl") "score.db" "modindex")
   (param 0.9)))

(define (loop15-bass-redux cnd)
  (grab "sineft")
  (grab "ilowfreq")
  (glang:gexprdb cnd (lgrab "gl") "score.db" "bass")
  (add zz (+ loop15-base -24))
  (mtof zz)
  (fmpair2 zz zz zz
           (param 1)
           (param 1)
           (param 8)
           (glang:gexprdb
            cnd (lgrab "gl") "score.db" "bassfdbk"))

  (softclip zz 8)
  (butlp zz 800))

(define (newscalar)
  (let ((r (nxtfree)))
    (gest:scalarnew)
    (regset zz r)
    (regmrk r)
    r))

(define (tsmpv2 ft in play)
  (param ft)
  (param in)
  (param play)
  (lvl "tsmp zz zz zz"))

(define (loop15-thoomp-redux cnd)
  (let ((rep (newscalar))
        (roll (newscalar)))
    (display "rep: ")
    (display rep)
    (newline)
    (display "roll: ")
    (display roll)
    (newline)

    (glang:scalar (lgrab "gl") (lregget rep) "r")
    (glang:scalar (lgrab "gl") (lregget roll) "unroll")

    (glang:gexprdb cnd (lgrab "gl") "score.db" "thoomp")
    (dup)

    (let ((tk
           (newsig (lambda ()
                     (phsclk zz
                             (gest:scalar
                              (lregget rep)))))))

      (crate:wav (lgrab "sqlite") "gdujfdp%")
      (regget tk)
      (trand (regget tk) 1.0 1.9)
      (tsmpv2 zz zz zz)
      (trand (regget tk) 0.9 1.0)
      (mul zz zz)
      (tgate (regget tk) 0.11)
      (lvl "smoother zz 0.001")
      (mul zz zz)
      (swap)
      (scale zz 0.1 1.0)
      (param 1)
      (crossfade zz zz (gest:scalar (lregget roll)))
      (mul zz zz)
      (clrsig tk))

    (regclr rep)
    (regclr roll)))

(define (loop15-snare-redux cnd)
  (let ((rep (newscalar))
        (roll (newscalar)))
    (glang:scalar (lgrab "gl") (lregget rep) "r")
    (glang:scalar (lgrab "gl") (lregget roll) "unroll")
    (glang:gexprdb cnd (lgrab "gl") "score.db" "snare")
    (dup)
    (let ((tk
           (newsig
            (lambda ()
              (phsclk zz (gest:scalar (lregget rep)))))))

      (crate:wav (lgrab "sqlite") "gfohawsjq%")
      (regget tk)
      (trand (regget tk) 1.0 3)
      (tsmpv2 zz zz zz)
      (trand (regget tk) 0.9 1.0)
      (mul zz zz)
      (tgate (regget tk) 0.11)
      (lvl "smoother zz 0.001")
      (mul zz zz)
      (swap)
      (scale zz 0.1 1.0)
      (param 1)
      (crossfade zz zz (gest:scalar (lregget roll)))
      (mul zz zz)
      (clrsig tk))

    (regclr rep)
    (regclr roll)))

(define (loop15-ping-redux cnd)
  (let ((rep (newscalar))
        (roll (newscalar)))
    (glang:scalar (lgrab "gl") (lregget rep) "r")
    (glang:scalar (lgrab "gl") (lregget roll) "unroll")
    (glang:gexprdb cnd (lgrab "gl") "score.db" "ping")
    (dup)
    (let ((tk (newsig (lambda () (phsclk zz (gest:scalar (lregget rep)))))))
      (display tk)
      (newline)
      (crate:wav (lgrab "sqlite") "ghkeewp%")
      (regget tk)
      (trand (regget tk) 1.0 3)
      (tsmpv2 zz zz zz)
      (trand (regget tk) 0.9 1.0)
      (mul zz zz)
      (tgate (regget tk) 0.11)
      (lvl "smoother zz 0.001")
      (mul zz zz)
      (swap)
      (scale zz 0.1 1.0)
      (param 1)
      (crossfade zz zz (gest:scalar (lregget roll)))
      (mul zz zz)
      (clrsig tk))

    (regclr rep)
    (regclr roll)))

(define (mix in cab amt)
  (param in)
  (cab)
  (param amt)
  (lvl "mix zz zz zz"))

(define (loop15-redux)
  (gest:cnd 73)
  (hold zz)
  (regset zz 0)
  (regmrk 0)

  (lvl "zero")
  (hold zz)
  (regset zz 1)
  (regmrk 1)


  (loop15-mel-redux (lregget 0))
  (att -18)
  (dup)
  (mix zz (lregget 1) 0.9)
  (att -3)

  (loop15-bass-redux (lregget 0))
  (att -15)
  (dup)
  (mix zz (lregget 1) 0.3)
  (att -3)
  (add zz zz)

  (loop15-thoomp-redux (lregget 0))
  (att -2)
  (dup)
  (mix zz (lregget 1) 0.9)
  (add zz zz)

  (loop15-snare-redux (lregget 0))
  (att -3)
  (dup)
  (mix zz (lregget 1) 0.8)
  (add zz zz)

  (loop15-ping-redux (lregget 0))
  (att -8)
  (dup)
  (mix zz (lregget 1) 1.9)
  (att -10)
  (add zz zz)

  (regget 1)
  (vardelay zz 0.0 0.2 0.3)
  (dup)
  (bigverb zz zz 0.93 8000)
  (drop)
  (dcblocker zz)
  (att -10)
  (add zz zz)

  (lvl "varnew cnd")
  (regget 0)
  (lvl "rephasor zz 0.25")
  (lvl "expmap zz 3")
  (lvl "rephasor zz 8")
  (lvl "varcpy zz cnd")

  (lvl "varnew cnd2")
  (regget 0)
  (lvl "rephasor zz 0.25")
  (lvl "varcpy zz cnd2")

  (unhold (regget 0))
  (regclr 0)
  (unhold (regget 1))
  (regclr 1)
)

(define (mksound wav dur)
  (loop15-init)
  (loop15-redux)


  (tenv (tick) 0.001 (- dur 5.001) 5)
  (mul zz zz)
  (wavout zz wav)
)

;;(loop15-init)
;;(loop15-redux)
;; (tenv (tick) 0.001 28 5)
;; (mul zz zz)
;; (dup)
;; (wavouts zz zz "translate.wav")
;; (lvl "computes 35")
