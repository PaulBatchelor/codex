(load (string-append (mnotop) "/core.scm"))

(load (mnopath "gfx.scm"))
(load (mnopath "kuf.scm"))
(load (mnopath "btprnt.scm"))
(load (mnopath "gest.scm"))
(load (mnopath "sqlar.scm"))
(load (mnopath "ugens.scm"))

(load "../spektrum.scm")
(load "../skript.scm")
(load "translate.scm")

(define koan #("HISHUM" "CHEKAEJ" "NAEJAETU" "VAIDYV"
               "SHAEBA" "DIBAISAIZ" "TEEJ" "FUMEEG"))

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

(define (colorbar pos)
  (btprnt:tr
   (lgrab "bp")
   0 (+ 8 (* pos (- 256 16)))
   192 16
   0 (+ 8 (* pos (- 256 16))) 11))

(define (draw)
  (dup)
  (gfxfill 1)
  (dup)
  (shimmer (varget "cnd"))
  (clrrow 0 0 (/ 192 8))
  (clrrow 0 (- 256 8) (/ 192 8))

  (gfxrectf (+ 8 8) (+ 16 8) (* 8 (- 4 2)) (* 8 (- 4 2)) 12)

  (lvl "bpfill [bpget [grab bp] 2] 0")
  (lvl (list
        "blngex"
        "[bpget [grab bp] 2]"
        "[grab pat1]" (num2str (+ pos 30))))



  (dup)
  (gfxrectf
   (+ 8 8 (* 4 8))
   (+ 16 (* 4 8) 8)
   (* 8 (- 5 2)) (* 8 (- 5 2)) 12)
  (lvl "bpfill [bpget [grab bp] 3] 0")
  (lvl (list
        "blngex"
        "[bpget [grab bp] 3]"
        "[grab pat1]" (num2str pos)))

  (dup)
  (gfxrectf
   (+ 8 8 (* 4 8) (* 5 8))
   (+ 16 (* 4 8) (* 5 8) 8)
   (* 8 (- 9 2)) (* 8 (- 9 2)) 12)
  (lvl "bpfill [bpget [grab bp] 1] 0")
  (lvl (list
        "blngex"
        "[bpget [grab bp] 1]"
        "[grab pat1]" (num2str (+ pos 30))))

  (dup)
  (gfxrectf
   (+ 8 8 (* 3 8))
   (+ 16 (* 4 8) (* 5 8) (* 9 8) 8)
   (* 8 (- 6 2)) (* 8 (- 6 2)) 12)
  (lvl "bpfill [bpget [grab bp] 4] 0")
  (lvl (list
        "blngex"
        "[bpget [grab bp] 4]"
        "[grab pat1]" (num2str (+ pos 15))))

  (dup)
  (gfxrectf
   (+ 8 8 (* 3 8) (* 6 8))
   (+ 16 (* 4 8) (* 5 8) (* 9 8) (* 6 8) 8)
   (* 8 (- 4 2)) (* 8 (- 4 2)) 12)
  (lvl "bpfill [bpget [grab bp] 5] 0")
  (lvl (list
        "blngex"
        "[bpget [grab bp] 5]"
        "[grab pat1]" (num2str pos)))

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

  (dup)
  (colorbar (varget "cnd2"))
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

(define (args lst)
  (map (lambda (x) (if (number? x) (num2str x) x)) lst))

(define (slabit)
  (gfxnew "gfx" 192 256)
  (lvl "bpnew bp 192 256")
  (skript:load "../skript.txt")
  (lvl "bpset [grab bp] 0 0 0 192 256")
  (btprnt:set "bp" 1 16 96 (* 8 7) (* 8 7))
  (lvl "blkset 49")
  (lvl "blngnew pat1 128")
  (lvl
   (list
    "blngcmp"
    "[grab pat1]"
    "\"x t 32 % + y + abs x t + y - abs 1 + ^ 2 << 5 % !\""))

  (mksound "mitireez.wav" 30)

;; Window 1 (region 2)
  (skript:box (llvl "bpget [grab bp] 0") 8 16 (koanword 0) 4 4)

  (lvl
   (args
    (list
     "bpset" "[grab bp]"
     2
     (+ 8 8)
     (+ 8 16)
     (* 8 (- 4 2))
     (* 8 (- 4 2)))))

;; Window 2 (region 3)
  (skript:box
   (llvl "bpget [grab bp] 0")
   (+ 8 (* 4 8)) (+ 16 (* 4 8)) (koanword 1) 5 5)

  (lvl
   (args
    (list
     "bpset" "[grab bp]"
     3
     (+ 8 8 (* 4 8))
     (+ 8 16 (* 4 8))
     (* 8 (- 5 2))
     (* 8 (- 5 2)))))

;; Window 3 (big window) (region 1)
  (skript:box
   (llvl "bpget [grab bp] 0")
   (+ 8 (* 4 8) (* 5 8))
   (+ 16 (* 4 8) (* 5 8))
   (koanword 2) 9 9)

  (lvl
   (args
    (list
     "bpset" "[grab bp]"
     1
     (+ 8 8 (* 4 8) (* 5 8))
     (+ 8 16 (* 4 8) (* 5 8))
     (* 8 (- 9 2))
     (* 8 (- 9 2)))))

;; Window 4 (region 4)
  (skript:box
   (llvl "bpget [grab bp] 0")
   (+ 8 (* 3 8))
   (+ 16 (* 4 8) (* 5 8) (* 9 8))
   (koanword 3) 6 6)

  (lvl
   (args
    (list
     "bpset" "[grab bp]"
     4
     (+ 8 8 (* 3 8))
     (+ 8 16 (* 4 8) (* 5 8) (* 9 8))
     (* 8 (- 6 2))
     (* 8 (- 6 2)))))


;; Window 5 (terminus) (region 5)
  (skript:box
   (llvl "bpget [grab bp] 0")
   (+ 8 (* 3 8) (* 6 8))
   (+ 16 (* 4 8) (* 5 8) (* 9 8) (* 6 8))
   (koanword 4) 4 4)

  (lvl
   (args
    (list
     "bpset" "[grab bp]"
     5
     (+ 8 8 (* 3 8) (* 6 8))
     (+ 8 16 (* 4 8) (* 5 8) (* 9 8) (* 6 8))
     (* 8 (- 4 2))
     (* 8 (- 4 2)))))


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
  (doit (* 60 30))
  (gfxclose)
  (gfxmp4 "mitireez.h264" "mitireez_tmp.mp4")
  )

(slabit)
