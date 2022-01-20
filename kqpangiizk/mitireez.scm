(load (string-append (mnotop) "/core.scm"))
(load (mnopath "gfx.scm"))
(load (mnopath "kuf.scm"))
(load (mnopath "btprnt.scm"))
(load (mnopath "gst.scm"))
(load "../spektrum.scm")
(load "../skript.scm")
(load "translate.scm")

(define koan #("HISHUM" "CHEKAEJ" "NAEJAETU" "VAIDYV"
               "SHAEBA" "DIBAISAIZ" "TEEJ" "FUMEEG"))

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
  ;(shimmer (varget "cnd"))
  (shimmer 0)
  (clrrow 0 0 (/ 192 8))
  (clrrow 0 (- 256 8) (/ 192 8))
  (gfxrectf (+ 8 8) (+ 16 8) (* 8 (- 4 2)) (* 8 (- 4 2)) 12)
  (dup)
  (gfxrectf
   (+ 8 8 (* 4 8))
   (+ 16 (* 4 8) 8)
   (* 8 (- 5 2)) (* 8 (- 5 2)) 12)

  (dup)
  (gfxrectf
   (+ 8 8 (* 4 8) (* 5 8))
   (+ 16 (* 4 8) (* 5 8) 8)
   (* 8 (- 9 2)) (* 8 (- 9 2)) 12)

  (dup)
  (gfxrectf
   (+ 8 8 (* 3 8))
   (+ 16 (* 4 8) (* 5 8) (* 9 8) 8)
   (* 8 (- 6 2)) (* 8 (- 6 2)) 12)

  (dup)
  (gfxrectf
   (+ 8 8 (* 3 8) (* 6 8))
   (+ 16 (* 4 8) (* 5 8) (* 9 8) (* 6 8) 8)
   (* 8 (- 4 2)) (* 8 (- 4 2)) 12)

  (dup)
  (lvl "bptr [grab bp] 0 0 192 256 0 0 0")
  (dup)
  ;(lvl "bptr [grab bp] 16 16 8 16 16 16 7")
  ;(dup)
  ;(btprnt:tr
  ; (lgrab "bp")
  ; 0 (- 256 (* 8 8))
  ; 256 8
  ; 0 (- 256 (* 8 8)) 10)

  ;(dup)
  ;(btprnt:tr
  ; (lgrab "bp")
  ; (- 192 (* 8 6)) 0
  ; 8 256
  ; (- 192 (* 8 6)) 0 11)

  (set! pos (+ pos 1))
)

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

(define (koanword k) (vector-ref koan k))
(define (koanwordp k) (string-append (koanword k) "."))

(define (proclaim x y k)
  (skript:text (llvl "bpget [grab bp] 0") x y (koanwordp k)))

(define (slabit)
  (gfxnew "gfx" 192 256)
  (lvl "bpnew bp 192 256")
  (skript:load "../skript.txt")
  (lvl "bpset [grab bp] 0 0 0 192 256")
  (btprnt:set "bp" 1 16 96 (* 8 7) (* 8 7))
  (lvl "blkset 49")

  (mksound "mitireez.wav" 30)

  (skript:box (llvl "bpget [grab bp] 0") 8 16 (koanword 0) 4 4)

  (skript:box
   (llvl "bpget [grab bp] 0")
   (+ 8 (* 4 8)) (+ 16 (* 4 8)) (koanword 1) 5 5)

  (skript:box
   (llvl "bpget [grab bp] 0")
   (+ 8 (* 4 8) (* 5 8))
   (+ 16 (* 4 8) (* 5 8))
   (koanword 2) 9 9)

  (skript:box
   (llvl "bpget [grab bp] 0")
   (+ 8 (* 3 8))
   (+ 16 (* 4 8) (* 5 8) (* 9 8))
   (koanword 3) 6 6)

  (skript:box
   (llvl "bpget [grab bp] 0")
   (+ 8 (* 3 8) (* 6 8))
   (+ 16 (* 4 8) (* 5 8) (* 9 8) (* 6 8))
   (koanword 4) 4 4)

  (proclaim (+ 8 (* 4 8) 8) (* 8 2) 5)
  (proclaim (+ 8 (* 4 8) (* 5 8) 8) (+ 16 (* 4 8)) 6)

  (lvl "grab gfx")

  (rainbow1-load)
  (dup)
  (gfxclrhex 12 (vector-ref rainbow-pastel 0))
  (dup)
  (gfxopen "mitireez.h264")
  (dup)
  (draw)

  (dup)
  (gfxppm "mitireez.ppm")
  (doit (* 60 10))
  (gfxclose)
  (gfxmp4 "mitireez.h264" "mitireez_tmp.mp4")
)

(slabit)
