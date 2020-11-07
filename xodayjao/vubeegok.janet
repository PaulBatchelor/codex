(import ../spektrum :as spektrum)
(import ../skript :as skript)

(var framepos 0)
(var shift 0)
(var speed 0.05)
(def fps 60)
(def sr 44100)
(def identity "vubeegok")

(def slab-width 192)
(def slab-height 256)

(def koan @[
"woficha"
"zhup"
"shaeguv"
"fazhicat"
"baipojak"
"nyzheewul"
"weeb"
"huz"
"dozab"
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


(def shade50 @[0xaa 0x55 0xaa 0x55
               0xaa 0x55 0xaa 0x55])

(def hstripes @[0xff 0x00 0xff 0x00
                0xff 0x00 0xff 0x00])

(def vstripes @[0xaa 0xaa 0xaa 0xaa
                0xaa 0xaa 0xaa 0xaa])

(def checkers @[0xf0 0xf0 0xf0 0xf0
                0x0f 0x0f 0x0f 0x0f])

(def hatches @[0x88 0x44 0x22 0x11
               0x88 0x44 0x22 0x11])

(defn draw-brik [bp main x y pat]
  (for i 0 8
    (monolith/btprnt-bitrow bp main x (+ i y) 8 (pat i))))

(defn draw-brik2 [bp main x y pat]
  (draw-brik bp main x y pat)
  (draw-brik bp main (+ x 8) y pat))

(defn draw-brikrow [bp main x pat off]
  (for i 0 6 (draw-brik2 bp main x (+ (* i 16) off -8) pat)))

(var states
     [@{:off 0 :speed 1 :pat shade50}
     @{:off 4 :speed 2 :pat hstripes}
     @{:off 0 :speed -3 :pat vstripes}
     @{:off 6 :speed 4 :pat checkers}
     @{:off 0 :speed -0.6 :pat hatches}])

(def speedscale 0.8)

(defn animate-brikrow [bp main s xoff]
  (draw-brikrow bp main xoff (s :pat) (math/floor (s :off)))
  (set (s :off)
       (% (+ (s :off) (* (s :speed) speedscale)) 16))
)

(defn briks [bp s]
  (def main @[0 0
              (monolith/btprnt-width bp)
              (monolith/btprnt-height bp)])

  (for i 0 5 (animate-brikrow bp main (states i) (* i 16))))

(defn draw (rainbow glimmer)
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (def bg (spektrum/rainbow-pastel 3))
  (def fg (spektrum/rainbow-dark 3))

  (window font
          (topleft 12 12 6 (/ (- 32 12) 2))
          @[black
            (glimmer 0)
            black
            (glimmer 1)
            black
            (glimmer 2)
            black
            (glimmer 3)
            black
            (glimmer 4)]
          fg bg
          (bless (koan 8))
          briks)

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 0)) 1) 8)) 2)
   (* 8 2) (+ (length (koan 0)) 1)
   @[(rainbow 0) black black black black]
   rows nchars
   (array/push (bless (koan 0)) 27))

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 1)) 1) 8)) 2)
   (* 8 4)
   (+ (length (koan 1)) 1)
   @[(rainbow 1) black black black black]
   rows nchars
   (array/push (bless (koan 1)) 27))

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 2)) 1) 8)) 2)
   (* 8 6)
   (+ (length (koan 2)) 1)
   @[(rainbow 2) black black black black]
   rows nchars
   (array/push (bless (koan 2)) 27))

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 3)) 1) 8)) 2)
   (* 8 8)
   (+ (length (koan 3)) 1)
   @[(rainbow 3) black black black black]
   rows nchars
   (array/push (bless (koan 3)) 27))

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 4)) 1) 8)) 2)
   (* 8 23)
   (+ (length (koan 4)) 1)
   @[(rainbow 4) black black black black]
   rows nchars
   (array/push (bless (koan 4)) 27))

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 5)) 1) 8)) 2)
   (* 8 25)
   (+ (length (koan 5)) 1)
   @[(rainbow 0) black black black black]
   rows nchars
   (array/push (bless (koan 5)) 27))

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 6)) 1) 8)) 2)
   (* 8 27)
   (+ (length (koan 6)) 1)
   @[(rainbow 1) black black black black]
   rows nchars
   (array/push (bless (koan 6)) 27))

  (skript/charhline
   bp
   (/ (- slab-width (* (+ (length (koan 7)) 1) 8)) 2)
   (* 8 29)
   (+ (length (koan 7)) 1)
   @[(rainbow 2) black black black black]
   rows nchars
   (array/push (bless (koan 7)) 27))
)

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

#(init "test.png")
