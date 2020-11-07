(import ../spektrum :as spektrum)
(import ../skript :as skript)

(var framepos 0)
(var shift 0)
(var speed 0.025)
(def fps 60)
(def sr 44100)
(def identity "heesh")

(def slab-width 192)
(def slab-height 256)

(def koan @[
"fechuwyk"
"gaeraeba"
"nypeehod"
"shaefe"
"veesirav"
"nulizeep"
"kef"
])



(def rows 8)
(def chars 8)
(def cols chars)

(def bpwidth (* chars 8))
(def bpheight (* rows 8))

(def nchars 31)

(def buf (skript/loadbuf
          "../a.txt"
          rows chars
          bpwidth bpheight))

(var bp (monolith/btprnt-new bpwidth bpheight))

(def font
  @{:bp bp :nchars nchars :rows rows})

(def black @[0 0 0])
(def main-rainbow spektrum/rainbow1)

(math/seedrandom (os/time))

(def boxsize (* 4 8))
(def boxspace 4)
(def boxcols 3)
(def boxrows 4)
(def boxoff (+ boxsize boxspace))
(def center-x (/ (- 192 (* boxcols boxoff)) 2))
(def center-y (/ (- 256 (* boxrows boxoff)) 2))

(defn jewel-test [rainbow]
  (for i 0 (* boxrows boxcols)
    (skript/jewel
     bp
     (+ center-x (* (% i boxcols) boxoff))
     (+ center-y (* (math/floor (/ i boxcols)) boxoff))
     (rainbow (% i (length rainbow)))
     rows
     nchars
     @[1 2 3 4 5 6 7]
     @[4 5 6 7])))

(defn bitdraw [x y w h fg bg cb &opt state]
  (var bp (monolith/btprnt-new w h))
  (cb bp state)
  (monolith/gfx-rect-fill
   x y
   w h
   (bg 0)
   (bg 1)
   (bg 2))

  (monolith/gfx-btprnt-stencil
   bp
   x y
   w h
   0 0
   (fg 0)
   (fg 1)
   (fg 2))
  (monolith/btprnt-del bp))

(defn bitdraw-stencil [bp offx offy]
  (fn [x y w h fg bg cb &opt state]
    (monolith/gfx-rect-fill
     x y
     w h
     (bg 0)
     (bg 1)
     (bg 2))

    (monolith/gfx-btprnt-stencil
     bp
     x y
     w h
     offx offy
     (fg 0)
     (fg 1)
     (fg 2))))

(defn bless (str)
  (map (fn (x) (- x 97)) (string/bytes str)))

(defn window [font
              reg
              clr
              fg bg
              blessing
              render &opt state draw]
  (def x (reg 0))
  (def y (reg 1))
  (def w (reg 2))
  (def h (reg 3))
  (default draw bitdraw)
  (skript/charboxborder
   (font :bp) x y
   w h
   clr
   8 (font :nchars)
   blessing)
  (draw
   (+ x 8) (+ y 8)
   (* (- w 2) 8) (* (- h 2) 8)
   fg bg
   render state))

(defn mkreg [x y rows cols]
  (array (* x 8) (* (+ y 1) 8) rows cols))

(defn bottomleft [rows cols &opt xoff yoff]
  (default xoff 0)
  (default yoff 0)
  (array (* xoff 8) (* (- (- 31 yoff) rows) 8) rows cols))

(defn topleft [rows cols &opt xoff yoff]
  (default xoff 0)
  (default yoff 0)
  (array (* xoff 8) (* yoff 8) rows cols))

(defn empty [bp s])

(defn breathe [framepos pos max &opt overload]
  (default overload 1)
  (math/floor
   (* (* 0.5 (+ 1 (math/cos
                   (* (+ (* (/ framepos 60) 4)
                         (* pos 0.3)) overload)))
         max))))

(defn arachnoid [bp s]
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])
  (def cx (math/floor (/ (main 2) 2)))
  (def cy (math/floor (/ (main 3) 2)))

  (def offphs (* (/ framepos 60) 0.8))

  (monolith/btprnt-circ-filled
   bp main
   cx cy
   (breathe framepos 0 12 3) 1)

  (var theta (/ (* 2 math/pi) 8))

  (for i 0 8
    (monolith/btprnt-circ-filled
     bp main
     (math/floor (+ cx (* 20 (math/cos (+ (* theta i) offphs)))))
     (math/floor (+ cy (* 20 (math/sin (+ (* theta i) offphs)))))
     (breathe framepos i 7) 1))

  (var theta (/ (* 2 math/pi) 16))
  (for i 0 16
    (monolith/btprnt-circ-filled
     bp main
     (math/floor (+ cx (* 32 (math/cos (- (* theta i) offphs)))))
     (math/floor (+ cy (* 32 (math/sin (- (* theta i) offphs)))))
     (breathe framepos i 5 1.5) 1)))

(defn draw (rainbow glimmer)
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (def bg (spektrum/rainbow-pastel 5))
  (def fg (spektrum/rainbow-dark 5))

  (def abp (monolith/btprnt-new (* 12 8) (* 12 8)))

  (arachnoid abp nil)
  (window font
          (topleft 8 14 3 (/ (- 32 18) 2))
          @[black
            black
            black
            black
            black
            (glimmer 0)
            (glimmer 1)
            (glimmer 2)
            (glimmer 3)
            (glimmer 4)]
          fg bg
          (bless (koan 0))
          empty nil (bitdraw-stencil abp 0 0))

  (window font
          (topleft 8 14 13 (/ (- 32 10) 2))
          @[black
            (glimmer 0)
            (rainbow 1)
            black
            (rainbow 2)
            black
            black
            black
            (rainbow 3)
            black
            (rainbow 4)]
          fg bg
          (bless (koan 0))
          empty nil (bitdraw-stencil abp (* 6 8) 0))

  (monolith/btprnt-del abp)

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 0)) 1) 8)) 2)
   (* 8 2) (+ (length (koan 0)) 1)
   @[(glimmer 0) black black black black]
   rows nchars
   (array/push (bless (koan 0)) 27))

  (skript/charhline
   bp
   (* 8 1)
   (* 8 23)
   (+ (length (koan 1)) 1)
   @[(glimmer 1) black black black black]
   rows nchars
   (array/push (bless (koan 1)) 27))

  (skript/charhline
   bp
   (* 8 8)
   (* 8 4)
   (+ (length (koan 2)) 1)
   @[(rainbow 2) black black black black]
   rows nchars
   (array/push (bless (koan 2)) 27))

  (skript/charhline
   bp
   (* 8 9)
   (* 8 26)
   (+ (length (koan 3)) 1)
   @[(glimmer 3) black black black]
   rows nchars
   (array/push (bless (koan 3)) 27))

  (skript/charhline
   bp
   (* 8 13)
   (* 8 28)
   (+ (length (koan 4)) 1)
   @[(rainbow 4) black black black]
   rows nchars
   (array/push (bless (koan 4)) 27))

  (skript/charhline
   bp
   (* 8 13)
   (* 8 9)
   (+ (length (koan 5)) 1)
   @[(rainbow 0) black black black]
   rows nchars
   (array/push (bless (koan 5)) 27))

  (skript/charhline
   bp
   (* 8 2)
   (* 8 28)
   (+ (length (koan 6)) 1)
   @[(glimmer 1) black black black black]
   rows nchars
   (array/push (bless (koan 6)) 27)))

(defn setup-font ()
  (monolith/btprnt-drawbits
   bp buf @(0 0 bpwidth bpheight) 0 0 bpwidth bpheight 0 0))

(defn init (&opt imgname)
  (default imgname (string identity ".png"))
  (monolith/gfx-fb-init)
  (setup-font)
  (monolith/gfx-setsize slab-width slab-height)
  (draw main-rainbow main-rainbow)
  (monolith/gfx-write-png imgname))

(defn render ()
  (draw main-rainbow (spektrum/shift main-rainbow shift))
  (if (= (% framepos fps) 0) (print framepos))
  (monolith/compute (math/floor (/ sr fps)))
  (monolith/h264-append)
  (set framepos (+ framepos 1))
  (def overload (monolith/chan-get 0))
  (set shift (% (+ shift speed (* overload 0.04)) 1)))

# (init "test.png")
