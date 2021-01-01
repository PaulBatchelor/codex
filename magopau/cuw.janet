(import ../skript :as skript)
(import ../spektrum :as spektrum)
(import ../matter :as matter)

(def paths (skript/mkfont "../pathways.txt" 8 16))

(def bp (monolith/btprnt-new 128 128))

(def font (paths :font))
(def main @(0 0
              (monolith/btprnt-width bp)
              (monolith/btprnt-height bp)))


(def text (apply string/from-bytes (range 33 (+ 33 44))))

(def koan @["nymawa" "shaef" "gov"])

(def empty 0)

(def road-filled 1)
(def road-empty 2)

(def wall-filled 3)
(def wall-empty 4)

(def turn-sw-filled 21)
(def turn-sw-empty 22)

(def turn-nw-filled 23)
(def turn-nw-empty 24)

(def turn-ne-filled 25)
(def turn-ne-empty 26)

(def turn-se-filled 27)
(def turn-se-empty 28)

(def weave-ef-over "*")
(def weave-ef-under ")")
(def weave-ee-over "+")
(def weave-ee-under ",")

(def term-e-filled "1")
(def term-e-empty "2")
(def term-w-filled "-")
(def term-w-empty ".")

(def bulb-w-filled 37)
(def bulb-w-empty 38)
(def bulb-s-filled 39)
(def bulb-s-empty 40)
(def bulb-e-filled 41)
(def bulb-e-empty 42)
(def bulb-n-filled 43)
(def bulb-n-empty 44)

(def slab-width 192)
(def slab-height 256)
(def pmcols 24)
(def pmrows 30)
(def pmw (* pmcols 8))
(def pmh (* pmrows 8))

(defn mkpathmap []
  (var p @{})
  (put p :map (array/new-filled (* pmcols pmrows) empty))
  (put p :rows 30)
  (put p :cols 24)
  (put p :width (* (p :cols) 8))
  (put p :height (* (p :rows) 8))
  (put p :xpos 0)
  (put p :ypos 0)
  p)

(defn moveto [p x y]
  (set (p :xpos) x)
  (set (p :ypos) y))

(defn left [p]
  (if (< (p :xpos) (- (p :cols) 1))
    (set (p :xpos) (+ (p :xpos) 1))))

(defn right [p]
  (if (> (p :xpos) 0)
    (set (p :xpos) (- (p :xpos) 1))))

(defn down [p]
  (if (< (p :ypos) (- (p :rows) 1))
    (set (p :ypos) (+ (p :ypos) 1))))

(defn stamp [p c]
  (set ((p :map) (+ (* (p :ypos) (p :cols)) (p :xpos))) c))

(defn leftstamp [p n c]
  (for i 0 n (stamp p c) (left p)))

(defn leftstampend [p c]
  (leftstamp p (- (p :cols) (p :xpos)) c))

(defn rightstamp [p n c]
  (for i 0 n (stamp p c) (right p)))

(defn downstamp [p n c]
  (for i 0 n (stamp p c) (down p)))

(defn downstampend [p c]
  (downstamp p (- (p :rows) (p :ypos)) c))

(def pathmap (mkpathmap))
(def pathmap-bp (monolith/btprnt-new
                 (pathmap :width)
                 (pathmap :height)))

(moveto pathmap 8 1)
(stamp pathmap bulb-e-empty)
(left pathmap)
(leftstamp pathmap 8 road-empty)
(stamp pathmap turn-sw-empty)
(down pathmap)
(downstamp pathmap 8 wall-empty)
(stamp pathmap turn-ne-empty)
(left pathmap)
(leftstampend pathmap road-empty)

(moveto pathmap 7 2)
(stamp pathmap bulb-e-empty)
(left pathmap)
(leftstamp pathmap 8 road-empty)
(stamp pathmap turn-sw-empty)
(down pathmap)
(downstampend pathmap wall-empty)
(stamp pathmap bulb-s-empty)

(moveto pathmap 5 3)
(stamp pathmap bulb-e-empty)
(left pathmap)
(leftstamp pathmap 8 road-empty)
(stamp pathmap turn-sw-empty)
(down pathmap)
(downstamp pathmap 8 wall-empty)
(stamp pathmap turn-nw-empty)
(right pathmap)
(rightstamp pathmap 4 road-empty)
(stamp pathmap bulb-e-empty)

(monolith/btprnt-wraptext
 pathmap-bp
 font
 @(0 0 (pathmap :width) (pathmap :height))
 0 0
 (apply string/from-bytes
        (map (fn (x) (+ x 32)) (pathmap :map))))

(monolith/btprnt-write-pbm pathmap-bp "out.pbm")

(def main-rainbow spektrum/rainbow1)

(def skrp (skript/mkfont "../a.txt" 8 8))

(def black @[0 0 0])
(defn draw (rainbow glimmer)
  (def bg (spektrum/rainbow-pastel 5))
  (def fg (spektrum/rainbow-dark 5))
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (skript/utter-blackletter skrp (koan 0) 8 16 27)
  (skript/utter-blackletter skrp (koan 1) 8 (+ 16 8) 27)
  (skript/utter-blackletter skrp (koan 2) 8 (+ 16 16) 27)

  (matter/window
   skript/charboxborder-v2
   skrp
   (matter/bottomleft 8 8 1 1)
   black
   fg bg (skript/bless (koan 0)) matter/empty)

  (monolith/gfx-btprnt-stencil
   pathmap-bp
   0 8 (pathmap :width) (pathmap :height) 0 0 0 0 0))

(monolith/gfx-fb-init)
(monolith/gfx-setsize slab-width slab-height)
(draw main-rainbow main-rainbow)
(monolith/gfx-write-png "cuw.png")
