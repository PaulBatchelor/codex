(load (string-append (mnotop) "/core.scm"))
(load (mnopath "gfx.scm"))
(load (mnopath "kuf.scm"))
(load (mnopath "btprnt.scm"))
(load (mnopath "gst.scm"))
(load "../spektrum.scm")
(load "../skript.scm")
(load "sound.scm")

(define (mkspaces words)
  (map (lambda (x) (string-append x " ")) words))

(define (clrsqr pos clr ypos)
  (gfxrectf (* pos 8) ypos 8 8 clr))

(define (clrrow pos ypos max)
  (if (> pos max) '()
      (begin
        (dup)
        (clrsqr pos (+ (modulo pos 5) 7) ypos)
        (clrrow (+ pos 1) ypos max))))

(define inc (/ 1 60))
(define pos 0)

(define (shimmer pos)
  (lvl (list "shimmer" (num2str pos))))

(define (borders) (lvl "borders"))

(define (varget name)
  (grab name)
  (lvl "param [vargrb zz]")
  (pop))

(define (draw)
  (dup)
  (gfxfill 1)
  (dup)
  (shimmer (varget "cnd"))
  (clrrow 0 0 (/ 192 8))
  (clrrow 0 (- 256 8) (/ 192 8))
  (dup)
  (gfxrectf 16 96 (* 8 7) (* 8 7) 12)

  (lvl (list "crosshairs" "[bpget [grab bp] 1]" (num2str pos)))

  (dup)
  (lvl "bptr [grab bp] 0 0 192 256 0 0 0")
  (dup)
  (lvl "bptr [grab bp] 16 16 8 64 16 16 7")
  (dup)
  (btprnt:tr
   (lgrab "bp")
   0 (- 256 (* 8 8))
   256 8
   0 (- 256 (* 8 8)) 10)

  (dup)
  (btprnt:tr
   (lgrab "bp")
   (- 192 (* 8 6)) 0
   8 256
   (- 192 (* 8 6)) 0 11)

  (set! pos (+ pos 1)))

(define (doit n)
  (if (> n 0)
      (begin
        (if (= (modulo n 60) 0)
            (begin (display n) (newline)))
        (compute-audio)
        (draw)
        (dup)
        (gfxframe)
        (doit (- n 1)))))


(define koan #("PEER" "GEK" "HISHYTOB" "WARAEN" "ZAEWYKOF"
               "HIP" "SAIJ" "DAER"))

(define (koanword k) (vector-ref koan k))
(define (koanwordp k) (string-append (koanword k) "."))
(define (proclaim x y k)
  (skript:text (llvl "bpget [grab bp] 0") x y (koanwordp k)))

(define rng 12345)

(define (genblk)
  (let ((tmp (kuf:genblk rng)))
    (set! rng (cadr tmp))
    (car tmp)))

(define (stripes x y)
  (kuf:setsqr 8 (lgrab "kuf") x y kuf:hpar0)
  (kuf:setsqr 8 (lgrab "kuf") (+ x 1) y kuf:hpar0)
  (kuf:setsqr 8 (lgrab "kuf") x (+ y 1) kuf:hpar0)
  (kuf:setsqr 8 (lgrab "kuf") (+ x 1) (+ y 1) kuf:hpar0))

(define (slabit)
  (gfxnew "gfx" 192 256)
  (lvl "bpnew bp 192 256")
  (skript:load "../skript.txt")
  (lvl "bpset [grab bp] 0 0 0 192 256")
  (btprnt:set "bp" 1 16 96 (* 8 7) (* 8 7))
  (lvl "blkset 49")
  (mksound "rai.wav")
  (proclaim 8 (* 8 2) 0)
  (proclaim 8 (* 8 3) 1)
  (proclaim 8 (* 8 4) 2)
  (proclaim 8 (* 8 5) 3)
  (proclaim 8 (* 8 6) 4)
  (proclaim 8 (* 8 7) 5)
  (proclaim 8 (* 8 8) 6)
  (proclaim 8 (* 8 9) 7)

  (skript:box (llvl "bpget [grab bp] 0") 8 88 (koanword 0) 9 9)

  (kuf:new "kuf" (* 8 8))

  (kuf:setblk 8 (lgrab "kuf") 0 0 (genblk))
  (stripes 2 0)
  (kuf:setblk 8 (lgrab "kuf") 4 0 (genblk))
  (stripes 6 0)

  (stripes 0 2)
  (kuf:setblk 8 (lgrab "kuf") 2 2 (genblk))
  (stripes 4 2)
  (kuf:setblk 8 (lgrab "kuf") 6 2 (genblk))

  (kuf:setblk 8 (lgrab "kuf") 0 4 (genblk))
  (stripes 2 4)
  (kuf:setblk 8 (lgrab "kuf") 4 4 (genblk))
  (stripes 6 4)

  (stripes 0 6)
  (kuf:setblk 8 (lgrab "kuf") 2 6 (genblk))
  (stripes 4 6)
  (kuf:setblk 8 (lgrab "kuf") 6 6 (genblk))

  (kuf:cor 8 8 (lgrab "kuf"))

  (kuf:bp
   (llvl "bpget [grab bp] 0")
   (lgrab "kuf")
   (- 192 8 (* 8 4 2)) (+ 88 (* 9 8) 8)
   8 8 2)

  (btprnt:rectf
   (btprnt:lget "bp" 0)
   (- 192 (* 3 8) 1) (* 8 8)
   10 (* 22 8) 0)

  (skript:vline
   (llvl "bpget [grab bp] 0")
   (- 192 (* 3 8)) (* 8 8)
   (koanword 2) 22)

  (btprnt:rectf
   (btprnt:lget "bp" 0)
   (* 1 8) (- 256 (* 6 8) 1)
   (* 18 8) 10 0)

  (skript:hline
   (llvl "bpget [grab bp] 0")
   (* 1 8) (- 256 (* 6 8))
   (koanword 3) 18)


  (lvl "grab gfx")
  (rainbow1-load)
  (dup)
  (gfxclrhex 12 (vector-ref rainbow-pastel 0))
  (dup)
  (gfxopen "rai.h264")
  (draw)
  (dup)
  (gfxppm "rai.ppm")
  (doit (* 60 30))
  (gfxclose)
  (gfxmp4 "rai.h264" "rai_tmp.mp4"))

(slabit)
