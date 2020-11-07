(import ../spektrum :as spektrum)
(import ../skript :as skript)

(def rows 8)
(def chars 8)
(def cols chars)

(def width (* chars 8))
(def height (* rows 8))

(def nchars 25)

(def buf (skript/loadbuf
          "../a.txt"
          rows chars
          width height))

(var bp (monolith/btprnt-new width height))

(def rainbow (spektrum/shift spektrum/rainbow1 1))
(def black @[0 0 0])

(math/seedrandom (os/time))

(def boxsize (* 4 8))
(def boxspace 4)
(def boxcols 3)
(def boxrows 4)
(def boxoff (+ boxsize boxspace))
(def center-x (/ (- 192 (* boxcols boxoff)) 2))
(def center-y (/ (- 256 (* boxrows boxoff)) 2))

(def blessings
  @[@[0 1 2 3]
    @[4 5 6 7 8]
    @[9 10 11 12]
    @[10 1 1 11 12]
    @[8 3 1 3 16 15 11]
    @[13 14 15 16]])

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

(def bg (spektrum/rainbow-pastel 0))
(def fg (spektrum/rainbow-dark 0))

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

(defn draw-dot [bp s]
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])
  (def center (monolith/btprnt-centerbox bp main 8 8))
  (monolith/btprnt-rect-filled bp (mkreal center) 0 0 8 8 1))

(defn draw-dot-flick [chan]
  (fn [bp s]
    (def main
      @[0 0
        (monolith/btprnt-width bp)
        (monolith/btprnt-height bp)])
    (def gate (monolith/chan-get chan))
    (def center (monolith/btprnt-centerbox bp main 8 8))
    (if-not (= gate 0)
      (monolith/btprnt-rect-filled
       bp (mkreal center) 0 0 8 8 1))))

(defn draw-bigdot [bp s]
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])
  (def center (monolith/btprnt-centerbox bp main 32 32))
  (monolith/btprnt-rect-filled bp (mkreal center) 0 0 32 32 1))

(defn draw-sweep [bp s]
  (def pos (monolith/chan-get 0))
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])

  (def size 8)
  (def posx (math/floor (* pos (- (main 2) size))))

  (monolith/btprnt-rect-filled
   bp main
   posx 0
   size
   (main 3) 1))

(defn draw (rainbow)
  (monolith/gfx-fill 255 255 255)
  (spektrum/border rainbow 24 32)

  (skript/charboxborder
   bp 8 16
   5 5
   black
   rows nchars
   (blessings 0))

  # Replace with btprnt animation
  (monolith/gfx-rect-fill
   (+ 8 8) (+ 16 8)
   (* 3 8) (* 3 8)
   (bg 0)
   (bg 1)
   (bg 2))

  (bitdraw
   (+ 8 8) (+ 16 8)
   (* 3 8) (* 3 8)
   fg bg
   (draw-dot-flick 1))

  (skript/charboxborder
   bp 8 (+ 16 (* 6 8))
   5 5
   black
   rows nchars
   (blessings 1))

  (bitdraw
   (+ 8 8) (+ 16 (* 8 7))
   (* 3 8) (* 3 8)
   bg fg
   (draw-dot-flick 2))

  (skript/charboxborder
   bp
   (+ 8 (* 6 8)) 16
   16 11
   black
   rows nchars
   (blessings 2))

  (bitdraw
   (+ 8 (* 7 8)) (+ 16 8)
   (* 14 8) (* 9 8)
   fg bg
   draw-sweep)

  (skript/charvline
   bp 8 (* 8 15) 8
   @[black (rainbow 0) black black]
   rows nchars
   (blessings 0))

  (skript/charvline
   bp (+ 8 (* 8 2)) (* 8 15) 12
   @[(rainbow 2) (rainbow 4) black black black (rainbow 0)]
   rows nchars
   (blessings 1))

  (skript/charvline
   bp (+ 8 (* 8 4)) (* 8 15) 5
   @[black (rainbow 1) black black]
   rows nchars
   (blessings 2))

  (skript/charvline
   bp (+ 8 (* 8 9)) (* 8 15) 11
   @[(rainbow 3) black black (rainbow 4) black]
   rows nchars
   (blessings 3))

  (skript/charvline
   bp (+ 8 (* 8 13)) (* 8 15) 4
   black
   rows nchars
   (blessings 4))

  (skript/charvline
   bp (+ 8 (* 8 15)) (* 8 15) 8
   @[black (rainbow 1) (rainbow 2)]
   rows nchars
   (blessings 5)))

(defn setup-font ()
  (monolith/btprnt-drawbits
   bp buf @(0 0 width height) 0 0 width height 0 0))

(defn init ()
  (monolith/gfx-fb-init)
  (setup-font)
  (monolith/gfx-setsize 192 256)
  (draw rainbow)
  (monolith/gfx-write-png "dy.png"))

(var framepos 0)
(var shift 0)
(var speed 0.01)
(def fps 60)
(def sr 44100)

(defn render ()
  (draw (spektrum/shift rainbow shift))
  (if (= (% framepos fps) 0) (print framepos))
  (monolith/compute (math/floor (/ sr fps)))
  (monolith/h264-append)
  (set framepos (+ framepos 1))
  (set shift (% (+ shift speed) 1)))

# half the mac se resolution
# (monolith/h264-begin "dy.h264" 60)
#  (var shift 0)
#  (var speed 0.01)
#  (for i 0 (* 10 60)
#    (if (= (% i 60) 0) (print i))
#    (draw (spektrum/shift rainbow shift))
#    (monolith/h264-append)
#    (set shift (% (+ shift speed) 1)))
#  (monolith/h264-end)
