(define (load-shape shape filename)
  (monolith:ftbl-create shape 44)
  (monft shape)
  (monolith:ftbl-pop-n-load filename))

(define (sqlar:crateloadraw db name id)
  (lvl
   (list "crtrawk"
         (string-append "[grab " db "]")
         name
         id)))

(define (load-the-shapes)
  (sqlar:crateloadraw "sqlite" "uh" "goauhdua")
  (sqlar:crateloadraw "sqlite" "jul-ah" "gfsohfil")
  (sqlar:crateloadraw "sqlite" "jul-oo" "guulkjoi")
  (sqlar:crateloadraw "sqlite" "jul-oh" "gisjhlqp")
  (sqlar:crateloadraw "sqlite" "jul-ee" "garuwlij"))

(define (open-db-in-monolith)
  (lvl (list "opendb" "sqlite" "/home/paul/proj/smp/a.db")))

(define (tract:target g shape)
  (lvl (list "tract_target" shape)))

(define (vow-uh g tk)
  (tract:target g "uh")
  tk)

(define (jul-ah g tk)
  (tract:target g "jul-ah")
  tk)

(define (jul-oo g tk)
  (tract:target g "jul-oo")
  tk)

(define (jul-oh g tk)
  (tract:target g "jul-oh")
  tk)

(define (jul-uh g tk)
  (tract:target g "jul-uh")
  tk)

(define (jul-ee g tk)
  (tract:target g "jul-ee")
  tk)

(define (jul-ahmute g tk)
  (tract:target g "jul-ahmute")
  tk)

(define (jul-la g tk)
  (tract:target g "jul-eh")
  tk)

(define (jul-ls1 g tk)
  (tract:target g "lowshape1")
  tk)

(define (jul-ls2 g tk)
  (tract:target g "lowshape2")
  tk)

(define (jul-ls3 g tk)
  (tract:target g "lowshape3")
  tk)

(define pitch-words
  '(("vow-a" vow-a)
    ("vow-e" vow-e)
    ("vow-o" vow-o)
    ("vow-rr" vow-rr)
    ("vow-uh" vow-uh)
    ("vow-ih" vow-ih)
    ("vow-eh" vow-eh)
    ("vow-oh" vow-oh)
    ("jul-ah" jul-ah)
    ("jul-oo" jul-oo)
    ("jul-oh" jul-oh)
    ("jul-uh" jul-uh)
    ("jul-ee" jul-ee)
    ("jul-la" jul-la)
    ("jul-eh" jul-eh)
    ("jul-ahmute" jul-ahmute)
    ("ls1" jul-ls1)
    ("ls2" jul-ls2)
    ("ls3" jul-ls3)
))

(define (configure-tract tr g smoothtime)
  (tract:gest-setup tr g)
  (tract:gest-smoothtime g smoothtime)
  (tract:use-diameters tr 0))

(define (singer g str)
   (gst:eval-addwords g pitch-words str))

(define (singer-words g words str)
   (gst:eval-addwords g (append pitch-words words) str))

(define (cabset in cab)
  (param in)
  (lvl (list "regset" "zz" (number->string cab))))

(define (cabget r)
  (lvl (list "regget" (number->string r))))

(define (cabgetf r)
  (lambda () (cabget r)))

(define (bhold sig)
  (param sig)
  (lvl "hold zz"))

(define (bunhold sig)
  (param sig)
  (lvl "unhold zz"))

(define (phasor freq iphs)
  (param freq)
  (lvl (list "phasor" "zz" (number->string iphs))))

(define (glottis freq)
  (param freq)
  (lvl "glottis zz"))

(define (mtof nn)
  (param nn)
  (lvl "mtof zz"))

(define (glottis freq tense)
  (param freq)
  (param tense)
  (lvl "glottis zz zz"))

(define (add x1 x2)
  (param x1)
  (param x2)
  (lvl "add zz zz"))

(define (mul x1 x2)
  (param x1)
  (param x2)
  (lvl "mul zz zz"))

(define (sine freq amp)
  (param freq)
  (param amp)
  (lvl "sine zz zz"))

(define (randi min max rate)
  (param min)
  (param max)
  (param rate)
  (lvl "rline zz zz zz"))

(define (adsr gt atk dec sus rel)
  (param gt)
  (param atk)
  (param dec)
  (param sus)
  (param rel)
  (lvl "adsr zz zz zz zz zz"))

(define (randi min max rate)
  (param min)
  (param max)
  (param rate)
  (lvl "rline zz zz zz"))

(define (nextfree pos)
  (lvl (string-append
        "param [regnxt "
        (number->string pos)
        "]"))
  (inexact->exact (pop)))

(define (bdup) (lvl "dup"))

(define (bdrop) (lvl "drop"))

(define (bigverb inL inR size cutoff)
  (param inL)
  (param inR)
  (param size)
  (param cutoff)
  (lvl "bigverb zz zz zz zz"))

(define (tenv trig atk hold rel)
  (param trig)
  (param atk)
  (param hold)
  (param rel)
  (lvl "tenv zz zz zz zz"))

(define (tick)
  (lvl "tick"))

(define (gest:new name)
  (let ((r (nextfree 0)))
    (lvl "gest_new")
    (lvl (list "regset" "zz" (string->number r)))))

(define (regset in r)
  (param in)
  (lvl (list "regset" "zz" (number->string r))))

(define (regget r)
  (lvl (list "regget" (number->string r))))

(define (regmrk r)
  (lvl (list "regmrk" (number->string r))))

(define (regclr r)
  (lvl (list "regclr " (number->string r))))

(define (newscalar)
  (let ((r (nextfree 0)))
    (lvl "gest_scalarnew")
    (regset zz r)
    (regmrk r)
    (lambda ()
      (regget r)
      r
    )))

(define (delscalar scl)
  (regclr (scl))
  (lvl "drop"))

(define (tract:new name)
  (error "please build")
)

(define (gest:iculate seq)
  (seq)
  (lvl "gesticulate zz zz"))

(define (gest:setscalar g scl val)
  (scl)
  (lvl (list "gest_setscalar" "zz" (number->string val))))

(define (gest:scalar gt)
  (gt)
  (lvl "gescalar zz"))

(define (mkvox cnd sco)
  (let ((tr (tract:new))
        (seq (gest:new))
        (gt (gest:newscalar)))
    ;(configure-tract tr seq 0.01)
    (singer-words seq (list (gst:wordentry "gt" (gst:mksetter gt)))
       sco)
    (cnd)
    (gest:iculate seq)
    (add zz 61)
    (sine (randi 5 6.3 0.2) 0.1)
    (add zz zz)
    (mtof zz)
    (glottis zz 0.5)
    (adsr (gest:scalar gt) 0.1 0.1 1 0.1)
    (mul zz zz)
    (tract:node tr)))

(define (vox1 cnd)
  (mkvox cnd "
beg 6 6
mr 2 t 7 jul-ah mg gt 1

mn 4 2
  pr 4
  pr 3
    mr 2 t 5 jul-oh mg
    pr 2
      t 7 jul-ah mg
      t 5 jul-oh mg
  mr 2 t 4 jul-ah mg
  t 4 jul-ah mg gt 0

  pr 4
  t 10 jul-ah gl
  mr 2 t 7 jul-ah gl
  t 8 jul-ah lin gt 0
end

beg 6 6
mr 2
pr 2
t 7 jul-oh exp -5 gt 1
t 7 jul-ah mg
pr 3
  mr 2 t 0 jul-ah mg
  t -2 jul-oh mg
t 0 jul-ee gl
t 1 jul-ee lin
t 0 jul-ee gl
end
loop fin
    "))

(define (procession)
  (let ()
    (cabset (bhold (phasor (/ 72 60) 0)) 0)
    (vox1 (cabgetf 0))
    (bunhold (cabget 0))))

(define (voice num cnd score)
  (let (
        (gt (newscalar))
        (vid (string-append "vox" (number->string num)))
)
    (lvl "tract_new")
    (lvl "regset zz 2")
    (regmrk 2)
    (lvl "gest_new")
    (lvl "dup")
    (lvl "regget 2")
    (lvl "tract_gest zz zz")

    (singer-words
     '()
     (list (gst:wordentry "gt" (gst:mksetter gt)))
     score)
    (cnd)
    (lvl "gesticulate zz zz")
    (lvl "add zz 61")
    (sine (randi 5 6.3 0.2) 0.1)
    (add zz zz)
    (mtof zz)
    (lvl "glottis zz 0.6")
    (lvl "tract_node [regget 2] zz")
    (adsr (gest:scalar gt) 0.1 0.1 1 0.1)
    (mul zz zz)
    (mul zz 0.65)
    (delscalar gt)
    (regclr 2)
))

(define (sound)

  (phasor (/ 75 60) 0)
  (bhold zz)
  (cabset zz 1)

  (cabget 1)
  (lvl "varcpy zz cnd")

  (voice 0 (cabgetf 1) "
beg 6 6
mr 2 t 7 jul-ah mg gt 1

mn 4 2
  pr 4
  pr 3
    mr 2 t 5 jul-oh mg
    pr 2
      t 7 jul-ah mg
      t 5 jul-oh mg
  mr 2 t 4 jul-ah mg
  t 4 jul-ah mg gt 0

  pr 4
  t 10 jul-ah gl
  mr 2 t 7 jul-ah gl
  t 8 jul-ah lin gt 0
end

beg 6 6
mr 2
pr 2
t 7 jul-oh exp -5 gt 1
t 7 jul-ah mg
pr 3
  mr 2 t 0 jul-ah mg
  t -2 jul-oh mg
t 0 jul-ee gl
t 1 jul-ee lin
t 0 jul-ee gl
end
loop fin
    ")

  (voice 1 (cabgetf 1) "
beg 6 6
mr 2 t 0 jul-ah gl gt 1

mn 4 2
pr 4
  mt 2
    t 0 jul-oh gl
    t 1 jul-oh lin
  mr 2 t 0 jul-ah mg
  t 0 jul-ah mg gt 0
t -24 vow-uh lin
end
beg 6 6
mr 2 pr 2
  t 0 jul-oh exp -5 gt 1
  t 0 jul-ah mg
pr 3
  mr 2 t -5 jul-ah mg
  t -7 jul-oh mg
mr 3 t -5 jul-ee mb 2 gl exp 1
end
loop fin
")

  (add zz zz)
  (voice 2 (cabgetf 1) "
beg 6 6
mr 2 t -5 jul-ah mg gt 1
t -2 jul-oh mg
mr 2 t -5 jul-ah mg
t -5 jul-ah mg gt 0
end
beg 6 6
mr 2 pr 2
t -5 jul-oh exp -5 gt 1
t -5 jul-ah mg
pr 3
  mr 2 t -12 jul-oh mg
  t -11 jul-oh gl
mr 3 t -12 jul-ee mb 2 gl exp 1
end
loop fin
    ")
  (add zz zz)

  (bdup)
  (lvl "vardelay zz 0 0.1 0.1")
  (bdup)
  (bigverb zz zz 0.97 10000)
  (bdrop)
  (mul zz 0.2)
  (add zz zz)

  (lvl "blsaw [mtof [expr 61 - 24]]")
  (lvl "blsaw [mtof [expr 61 - 36]]")
  (add zz zz)
  (mul zz 0.05)
  (lvl "butlp zz [rline 200 500 7]")
  (add zz zz))

(define (mksound wav)
  (open-db-in-monolith)
  (load-the-shapes)
  (lvl "varnew cnd")
  (sound)
  (tenv (tick) 0.1 25 5)
  (mul zz zz)
  (lvl (list "wavout" "zz" wav)))
