(import ../skript :as skript)
(import ../spektrum :as spektrum)
(import ../matter :as matter)
(import ../paths :as paths)


#(def font (paths :font))

#(def text (apply string/from-bytes (range 33 (+ 33 44))))

(def koan @["nymawa" "shaef" "gov"])

(def slab-width 192)
(def slab-height 256)
#(def pmcols 24)
#(def pmrows 30)
#(def pmw (* pmcols 8))
#(def pmh (* pmrows 8))

(defn mkdata []
  (var p @{})
  (put p :paths (skript/mkfont "../pathways.txt" 8 16))
  (put p :pathmap (paths/mkpathmap))
  (put p :pathmap-bp
     (monolith/btprnt-new
      ((p :pathmap) :width)
      ((p :pathmap) :height)))
  (put p :main-rainbow spektrum/rainbow1)
  p)

(def main-rainbow spektrum/rainbow1)
# 
(def skrp (skript/mkfont "../a.txt" 8 8))

(defn colorrow [pathmap bp clr pos]
  (monolith/gfx-btprnt-stencil
   bp
   0 (+ 8 (* 8 pos)) (pathmap :width) 8 0 (* 8 pos)
   (clr 0) (clr 1) (clr 2)))

(defn draw (data rainbow glimmer)
  (def bg (spektrum/rainbow-pastel 5))
  (def fg (spektrum/rainbow-dark 5))
  (def black @[0 0 0])
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
   (data :pathmap-bp)
   0 8 ((data :pathmap) :width) ((data :pathmap) :height) 0 0 0 0 0)

  (for i 0 ((data :pathmap) :rows)
    (colorrow (data :pathmap)
              (data :pathmap-bp)
              (glimmer (% i (length rainbow)))
              i)))


(defn init [data &opt imgname]
  (default imgname "cuw.png")
  (def pathmap (data :pathmap))
  (paths/moveto pathmap 8 1)
  (paths/stamp pathmap paths/bulb-e-empty)
  (paths/left pathmap)
  (paths/leftstamp pathmap 8 paths/road-empty)
  (paths/stamp pathmap paths/turn-sw-empty)
  (paths/down pathmap)
  (paths/downstamp pathmap 8 paths/wall-empty)
  (paths/stamp pathmap paths/turn-ne-empty)
  (paths/left pathmap)
  (paths/leftstampend pathmap paths/road-empty)

  (paths/moveto pathmap 7 2)
  (paths/stamp pathmap paths/bulb-e-empty)
  (paths/left pathmap)
  (paths/leftstamp pathmap 8 paths/road-empty)
  (paths/stamp pathmap paths/turn-sw-empty)
  (paths/down pathmap)
  (paths/downstampend pathmap paths/wall-empty)
  (paths/stamp pathmap paths/bulb-s-empty)

  (paths/moveto pathmap 5 3)
  (paths/stamp pathmap paths/bulb-e-empty)
  (paths/left pathmap)
  (paths/leftstamp pathmap 8 paths/road-empty)
  (paths/stamp pathmap paths/turn-sw-empty)
  (paths/down pathmap)
  (paths/downstamp pathmap 8 paths/wall-empty)
  (paths/stamp pathmap paths/turn-nw-empty)
  (paths/right pathmap)
  (paths/rightstamp pathmap 4 paths/road-empty)
  (paths/stamp pathmap paths/bulb-e-empty)

  (monolith/btprnt-wraptext
   (data :pathmap-bp)
   ((data :paths) :font)
   @(0 0 (pathmap :width) (pathmap :height))
   0 0
   (apply string/from-bytes
          (map (fn (x) (+ x 32)) (pathmap :map))))

  ##(monolith/btprnt-write-pbm pathmap-bp "out.pbm")

  (draw data (data :main-rainbow) (data :main-rainbow))
  (monolith/gfx-write-png imgname)
)

(defn gfx-init []
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize slab-width slab-height))

(var shift 0)
(var framepos 0)
(var fps 60)
(var sr 44100)
(var speed 0.07)

(defn render [data]
  (draw data
        (data :main-rainbow)
        (spektrum/shift (data :main-rainbow) shift))
  (if (= (% framepos fps) 0) (print framepos))
  (monolith/compute (math/floor (/ sr fps)))
  (monolith/h264-append)
  (set framepos (+ framepos 1))
  (def overload (monolith/chan-get 0))
  (set shift (% (+ shift speed) 1))
)

(defn render-file []
  (var data (mkdata))
  (init data)
  (for i 0 (* 20 fps) (render data)))
