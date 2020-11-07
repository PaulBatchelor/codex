(import ../spektrum :as spektrum)
(import ../skript :as skript)

(var framepos 0)
(var shift 0)
(var speed 0.01)
(def fps 60)
(def sr 44100)
(def identity "memiv")

(def koan @[
"soh"
"cas"
"saiwykuv"
"chypaec"
"jeemus"
"deraide"
"cegyzh"
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

(var sqrpos @[0 10 0 30 5 40 20])
(var sqrspeed @[2 3 5 7 4 3 1])

(defn new-sqr [&opt pos speed]
  (default pos 0)
  (default speed 2)
  @{:pos pos :speed speed})

(var sqr
     @[(new-sqr 0 2)
       (new-sqr 10 3)
       (new-sqr 40 7)
       (new-sqr 20 8)])

(var pgate 0)
(var gate 0)

(defn falling-squares [bp s]
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])
  (def boost (monolith/chan-get 0))
  (monolith/btprnt-rect-filled
   bp
   main
   0 (math/floor (s :pos))
   8 8 1)
  (set (s :pos)
       (%
        (+ (s :pos)
           (* (s :speed) (+ 0.1 (* boost 0.5)))) (main 3)))
  (if-not (= pgate gate) (set (s :speed) (+ 1 (* 10 (math/random)))))
  (if (> gate 0)
    (monolith/btprnt-invert bp main 0 0 (main 2) (main 3))))

(defn empty [bp s])

(defn draw (rainbow glimmer)
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (def bg (spektrum/rainbow-pastel 2))
  (def fg (spektrum/rainbow-dark 2))

  (window font
          (topleft 3 12 1 3)
          @[black black (glimmer 0) black]
          fg bg
          (bless (koan 0))
          falling-squares (sqr 0))

  (window font
          (topleft 3 12 5 3)
          @[(rainbow 3) black black black (glimmer 2) black]
          fg bg
          (bless (koan 1))
          falling-squares (sqr 1))

  (window font
          (topleft 3 12 9 3)
          @[black black black black (glimmer 0) black]
          fg bg
          (bless (koan 2))
          falling-squares (sqr 2))

  (window font
          (topleft 3 26 17 3)
          @[black black black black (glimmer 4) black]
          fg bg
          (bless (koan 3))
          falling-squares (sqr 3))

  (skript/charvline
   bp (+ 8 (* 8 1)) (* 8 17) (+ (length (koan 0)) 1)
   @[(glimmer 0) black black black]
   rows nchars
   (array/push (bless (koan 0)) 27))

  (skript/charvline
   bp (+ 8 (* 8 3)) (* 8 17) (+ (length (koan 1)) 1)
   @[black (glimmer 2) black black black]
   rows nchars
   (array/push (bless (koan 1)) 27))

  (skript/charvline
   bp (+ 8 (* 8 5)) (* 8 17) (+ (length (koan 2)) 1)
   @[black black (glimmer 1) black black]
   rows nchars
   (array/push (bless (koan 2)) 27))

  (skript/charvline
   bp (+ 8 (* 8 7)) (* 8 17) (+ (length (koan 3)) 1)
   @[black black (glimmer 3) (glimmer 4) black black]
   rows nchars
   (array/push (bless (koan 3)) 27))

  (skript/charvline
   bp (+ 8 (* 8 9)) (* 8 17) (+ (length (koan 4)) 1)
   @[black black (glimmer 0) black black black]
   rows nchars
   (array/push (bless (koan 4)) 27))

  (skript/charvline
   bp (+ 8 (* 8 11)) (* 8 17) (+ (length (koan 5)) 1)
   @[black black black (glimmer 1) black black black]
   rows nchars
   (array/push (bless (koan 5)) 27))

  (skript/charvline
   bp (+ 8 (* 8 13)) (* 8 17) (+ (length (koan 6)) 1)
   @[black black (glimmer 3) black black black]
   rows nchars
   (array/push (bless (koan 6)) 27))
)

(defn setup-font ()
  (monolith/btprnt-drawbits
   bp buf @(0 0 bpwidth bpheight) 0 0 bpwidth bpheight 0 0))

(def slab-width 192)
(def slab-height 256)

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
  (set pgate gate)
  (set gate (monolith/chan-get 1))
  (set framepos (+ framepos 1))
  (def overload (monolith/chan-get 0))
  (set shift (% (+ shift speed (* overload 0.04)) 1)))

#(init "test.png")
