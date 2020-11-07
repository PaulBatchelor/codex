(import ../spektrum :as spektrum)
(import ../skript :as skript)

(var framepos 0)
(var shift 0)
(var speed 0.01)
(def fps 60)
(def sr 44100)

(def koan @["tyv"
            "zunofob"
            "ceenaebae"
            "kuturoj"
            "waireh"
            "hizhachok"
            "gyweevee"
            "shakyd"])

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

(defn bless (str)
  (map (fn (x) (- x 97)) (string/bytes str)))

(defn window [bp
              reg
              clr
              fg bg
              nchars
              blessing
              render]
  (def x (reg 0))
  (def y (reg 1))
  (def w (reg 2))
  (def h (reg 3))
  (skript/charboxborder
   bp x y
   w h
   clr
   8 nchars
   blessing)
  (bitdraw
   (+ x 8) (+ y 8)
   (* (- w 2) 8) (* (- h 2) 8)
   fg bg
   render))

(defn mkreg [x y rows cols]
  (array (* x 8) (* (+ y 1) 8) rows cols))

(defn bottomleft [rows cols &opt xoff yoff]
  (default xoff 0)
  (default yoff 0)
  (array (* xoff 8) (* (- (- 31 yoff) rows) 8) rows cols))

(var sqrpos @[0 10 0 30 5 40 20])
(var sqrspeed @[2 3 5 7 4 3 1])

(defn falling-squares [bp s]
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])
  (def boost (monolith/chan-get 0))
  (for i 0 7
    (do
      (monolith/btprnt-rect-filled
       bp
       main
       (* i 8) (math/floor (sqrpos i))
       8 8 1)
      (set (sqrpos i)
           (%
            (+ (sqrpos i)
               (* (sqrspeed i)
                  (+ 0.25 (* boost 0.5)))) (main 3))))))

(def lines1-pos @[0 5 10])
(def lines1-speed @[3 2 1])

(def lines2-pos @[0 10 12])
(def lines2-speed @[3 2 1])
(defn falling-lines [pos speed]
  (fn [bp s]
    (def halt (monolith/chan-get 0))
    (def main
      @[0 0
        (monolith/btprnt-width bp)
        (monolith/btprnt-height bp)])
    (for i 0 (length pos)
      (do
        (monolith/btprnt-line
         bp main
         (math/floor (pos i)) 0
         (math/floor (pos i))
         (main 3) 1)
        (set
         (pos i)
         (% (+ (pos i)
               (* (speed i) (- 1 (* halt 0.8))))
            (main 2)))))))

(defn draw (rainbow glimmer)
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (def bg (spektrum/rainbow-pastel 1))
  (def fg (spektrum/rainbow-dark 1))

  (window bp
          #(mkreg 2 12 9 9)
          (bottomleft 9 9 2 2)
          @[black (rainbow 4) black black black (glimmer 0)]
          fg bg
          nchars
          (bless (koan 1))
          falling-squares)

  (window bp
          #(mkreg 2 12 9 9)
          (bottomleft 4 4 13 20)
          @[black (glimmer 3) black black black black]
          fg bg
          nchars
          (bless (koan 2))
          (falling-lines lines1-pos lines1-speed))


  (window bp
          #(mkreg 2 12 9 9)
          (bottomleft 5 5 15 3)
          @[black black black black black black]
          fg bg
          nchars
          (bless (koan 2))
          (falling-lines lines2-pos lines2-speed))

  (skript/charvline
   bp (+ 8 (* 8 1)) (* 8 2) (length (koan 0))
   @[(rainbow 0) (glimmer 4) black black black (rainbow 0)]
   rows nchars
   (bless (koan 0)))

  (skript/charvline
   bp (+ 8 (* 8 3)) (* 8 2) (length (koan 1))
   @[black black black (rainbow 1) black black black]
   rows nchars
   (bless (koan 1)))

  (skript/charvline
   bp (+ 8 (* 8 5)) (* 8 2) (length (koan 2))
   @[black (rainbow 2) black (glimmer 2) black (glimmer 3) black]
   rows nchars
   (bless (koan 2)))

  (skript/charvline
   bp (+ 8 (* 8 7)) (* 8 2) (length (koan 3))
   @[black black black black (glimmer 4)]
   rows nchars
   (bless (koan 3)))

  # secondary couplet

  (skript/charvline
   bp (+ 8 (* 8 9)) (* 8 12) (length (koan 4))
   @[black (rainbow 0) black (rainbow 4) black]
   rows nchars
   (bless (koan 4)))

  (skript/charvline
   bp (+ 8 (* 8 11)) (* 8 12) (length (koan 5))
   @[black (glimmer 0) black (glimmer 4) black]
   rows nchars
   (bless (koan 5)))

  (skript/charvline
   bp (+ 8 (* 8 13)) (* 8 12) (length (koan 6))
   @[(glimmer 1) black black]
   rows nchars
   (bless (koan 6)))

  (skript/charvline
   bp (+ 8 (* 8 15)) (* 8 12) (length (koan 7))
   black
   rows nchars
   (bless (koan 7)))


  # PS I love you
  (skript/charhline
   bp (+ 8 (* 8 18)) (* 8 2) 4
   (reverse rainbow)
   rows nchars
   @[27 28 29 30])
)

(defn setup-font ()
  (monolith/btprnt-drawbits
   bp buf @(0 0 bpwidth bpheight) 0 0 bpwidth bpheight 0 0))

(def slab-width 192)
(def slab-height 256)

(defn init (&opt imgname)
  (default imgname "vohzul.png")
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
  (set shift (% (+ shift speed (* 0.1 overload)) 1)))

#(init "test.png")
