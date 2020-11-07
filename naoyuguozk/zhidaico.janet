(import ../spektrum :as spektrum)
(import ../skript :as skript)

(var framepos 0)
(var shift 0)
(var speed 0.001)
(def fps 60)
(def sr 44100)

(def koan @["hyp"
"cichaetuj"
"dezetuw"
"taechucee"
"miwulezh"
"bujij"
"kogeban"])

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

(defn empty [bp s])

(var ripples (array/new 5))

(defn new-ripple [enabled index]
   @{:time 0
     :enabled enabled
     :index index
     :speed (+ 0.005 (* (math/random) 0.01))
     :xpos (math/floor (* (math/random) 111))
     :ypos (math/floor (* (math/random) 111))})

(defn init-ripples [ripples &opt maxripples]
  (default maxripples 10)
  (print (length ripples))
  (for i 0 maxripples
    (var r (new-ripple false i))
    (array/push ripples r)))

(defn ripple-nextfree [ripples]
  (find (fn [x] (= (x :enabled) false)) ripples))

(defn addripple []
  (var pos ((ripple-nextfree ripples) :index))
  (set (ripples pos) (new-ripple true pos)))

(defn draw-ripples [bp]
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])

  (each r ripples
    (if (r :enabled)
      (monolith/btprnt-circ
       bp main
       (r :xpos)
       (r :ypos)
       (math/floor (+ 4 (* (r :time) 50)))
       1)))

  (each r ripples
    (if (r :enabled)
      (do
        (set (r :time) (+ (r :time) (r :speed)))
        (if (> (r :time) 1) (set (r :enabled) false))))))

(defn draw (rainbow glimmer)
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (def bg (spektrum/rainbow-pastel 4))
  (def fg (spektrum/rainbow-dark 4))
  (def circ-bp (monolith/btprnt-new
                (* (* 7 8) 2) (* (* 7 8) 2)))

  (draw-ripples circ-bp)
  (window font
          (bottomleft 8 8 2 5)
          @[(rainbow 3) black (glimmer 4) black]
          fg bg
          (bless (koan 1))
          empty nil (bitdraw-stencil circ-bp 0 (* 7 8)))

  (window font
          (bottomleft 7 7 14 7)
          @[black black black black black (glimmer 0)]
          fg bg
          (bless (koan 2))
          empty nil (bitdraw-stencil circ-bp (* 7 8) (* 7 8)))

  (window font
          (bottomleft 6 6 1 23)
          black
          fg bg
          (bless (koan 3))
          empty nil (bitdraw-stencil circ-bp 0 0))

  (window font
          (bottomleft 9 9 13 16)
          black
          fg bg
          (bless (koan 4))
          empty nil (bitdraw-stencil circ-bp (* 7 8) 0))


  (skript/charhline
   bp (+ 8 (* 8 1)) (* 8 10) (+ (length (koan 0)) 1)
   @[(glimmer 0) black black black]
   rows nchars
   (array/push (bless (koan 0)) 27))

  (skript/charhline
   bp (+ 8 (* 8 1)) (* 8 11) (+ (length (koan 5)) 1)
   @[black (glimmer 1) black black ]
   rows nchars
   (array/push (bless (koan 5)) 27))

  (skript/charhline
   bp (+ 8 (* 8 1)) (* 8 12) (+ (length (koan 6)) 1)
   @[black black (glimmer 2) black ]
   rows nchars
   (array/push (bless (koan 6)) 27))

  (skript/charhline
   bp (+ 8 (* 8 1)) (* 8 13) (+ (length (koan 1)) 1)
   @[black black black (glimmer 3)]
   rows nchars
   (array/push (bless (koan 1)) 27))

  (skript/charhline
   bp (+ 8 (* 8 1)) (* 8 14) (+ (length (koan 2)) 1)
   @[(glimmer 4) black black black]
   rows nchars
   (array/push (bless (koan 2)) 27))

  (skript/charhline
   bp (+ 8 (* 8 12)) (* 8 25) 9
   @[black (rainbow 0) black black]
   rows nchars
   (array/push (bless (koan 0)) 27))

  (skript/charhline
   bp (+ 8 (* 8 12)) (* 8 26) 9
   @[black black (rainbow 1) black black]
   rows nchars
   (array/push (bless (koan 1)) 27))

  (skript/charhline
   bp (+ 8 (* 8 12)) (* 8 27) 9
   @[black black black (rainbow 2) black]
   rows nchars
   (array/push (bless (koan 2)) 27))

  (skript/charhline
   bp (+ 8 (* 8 12)) (* 8 28) 9
   @[black black black black (rainbow 3)]
   rows nchars
   (array/push (bless (koan 3)) 27))

  (skript/charhline
   bp (+ 8 (* 8 12)) (* 8 29) 9
   @[black black black black black (rainbow 4)]
   rows nchars
   (array/push (bless (koan 4)) 27))

  (skript/charhline
   bp (+ 8 (* 8 2)) (* 8 28) (+ (length (koan 5)) 1)
   @[black black black black black]
   rows nchars
   (array/push (bless (koan 5)) 29))

  (skript/charhline
   bp (+ 8 (* 8 13)) (* 8 3) (+ (length (koan 6)) 1)
   @[black (glimmer 4) (glimmer 1) (glimmer 2) (glimmer 3)]
   rows nchars
   (array/push (bless (koan 6)) 29))

  (monolith/btprnt-del circ-bp)
)

(defn setup-font ()
  (monolith/btprnt-drawbits
   bp buf @(0 0 bpwidth bpheight) 0 0 bpwidth bpheight 0 0))

(def slab-width 192)
(def slab-height 256)

(defn init (&opt imgname)
  (default imgname "zhidaico.png")
  (monolith/gfx-fb-init)
  (setup-font)
  (monolith/gfx-setsize slab-width slab-height)
  (draw main-rainbow main-rainbow)
  (monolith/gfx-write-png imgname)
  (init-ripples ripples 15))

(defn render ()
  (draw main-rainbow (spektrum/shift main-rainbow shift))
  (if (= (% framepos fps) 0) (print framepos))
  (monolith/compute (math/floor (/ sr fps)))
  (monolith/h264-append)
  (set framepos (+ framepos 1))
  (def overload (monolith/chan-get 0))
  (set shift (% (+ shift speed) 1)))

#(init "test.png")
