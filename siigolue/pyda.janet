(import ../skript)
(import ../spektrum)
(import ../matter)
(import ../paths)
(import ../hearth)


(defn veins [pm]
  # vein 1
  (paths/moveto pm 1 2)
  (paths/stamp pm paths/bulb-e-filled)

  (paths/right pm)
  (paths/rightstamp pm 4 paths/road-filled)

  (paths/stamp pm paths/turn-sw-filled)

  (paths/down pm)
  (paths/downstamp pm 8 paths/wall-filled)

  (paths/stamp pm paths/turn-ne-filled)
  (paths/right pm)
  (paths/rightstamp pm 4 paths/road-filled)

  (paths/stamp pm paths/turn-sw-filled)

  (paths/down pm)
  (paths/downstamp pm 8 paths/wall-filled)

  (paths/stamp pm paths/bulb-s-filled)

  # vein 2
  (paths/moveto pm 3 6)
  (paths/stamp pm paths/bulb-e-empty)
  (paths/right pm)
  (paths/smartrightstamp pm 5 paths/road-empty)
  (paths/stamp pm paths/bulb-w-empty)

  # vein 3
  (paths/moveto pm 8 3)
  (paths/stamp pm paths/bulb-n-empty)
  (paths/down pm)
  (paths/smartdownstamp pm 10 paths/wall-empty)
  (paths/stamp pm paths/bulb-s-empty)

  # vein 4
  (paths/moveto pm 5 9)
  (paths/stamp pm paths/bulb-e-empty)
  (paths/right pm)
  (paths/smartrightstamp pm 7 paths/road-empty)
  (paths/stamp pm paths/turn-sw-empty)

  (paths/down pm)
  (paths/downstamp pm 8 paths/wall-empty)
  (paths/stamp pm paths/bulb-s-empty)

)

(defn stroll [bp s]
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])

  (monolith/btprnt-scrolltext
   bp
   ((s :skrp) :bpfont)
   main
   (math/floor (* (s :shift) (main 2))) 0
   (skript/curse @[0 1 2 3]))

  (monolith/btprnt-scrolltext
   bp
   ((s :skrp) :bpfont)
   main
   (math/floor (* (s :shift) (main 2) 2.1)) 8
   (skript/curse @[4 5 6 7]))

  (monolith/btprnt-scrolltext
   bp
   ((s :skrp) :bpfont)
   main
   (math/floor (* (s :shift) (main 2) 1.3)) (* 8 5)
   (skript/curse @[8 9 10 11]))


  (def s (math/floor (+ (* (s :shift) 10) 10)))
  (monolith/btprnt-rect-filled
   bp main
   (math/floor (- (* (main 2) 0.5) (* s 0.5)))
   (math/floor (- (* (main 3) 0.5) (* s 0.5)))
   s s 1)
)

(defn openbox [bp s]
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])
  (def s (math/floor (+ (* (s :shift) 10) 10)))
  (monolith/btprnt-rect
   bp main
   (math/floor (- (* (main 2) 0.5) (* s 0.5)))
   (math/floor (- (* (main 3) 0.5) (* s 0.5)))
   s s 1)
)

(defn mkdata []
  (var p @{})
  (put p :paths (skript/mkfont "../pathways.txt" 8 16))
  (put p :rainbow spektrum/rainbow1)
  (put p :koan
     (string/split
      " "
      "jailegysh bid laelazeel kusaizho shocog jyb"))
  (put p :skrp (skript/mkfont "../a.txt" 8 8))
  (put p :pm (paths/mkpathmap))
  (put p :pm-bp (paths/mkbtprnt (p :pm)))
  (veins (p :pm))
  (paths/bpwrite (p :pm-bp) (p :paths) (p :pm))
  (put p :shift 0)
  (put p :speed 0.008)
  p)

(defn draw [data]
  (def glimmer (spektrum/shift (data :rainbow) (data :shift)))
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (skript/utter-blackletter
   (data :skrp)
   ((data :koan) 0)
   8 16 27)

  (skript/utter-blackletter
   (data :skrp)
   ((data :koan) 1)
   8 (- hearth/height (+ 16 8)) 27)


  (skript/utter-blackletter
   (data :skrp)
   ((data :koan) 2)
   (- hearth/width (* (+ (length ((data :koan) 2)) 2) 8))
   16
   27)

  (skript/utter-blackletter
   (data :skrp)
   ((data :koan) 3)
   (- hearth/width (* (+ (length ((data :koan) 3)) 2) 8))
   (- hearth/height (+ 16 8))
   27)

  (skript/utter-blackletter
   (data :skrp)
   ((data :koan) 4)
   8
   (/ hearth/height 2)
   27)

  (skript/utter-blackletter
   (data :skrp)
   ((data :koan) 5)
   (- hearth/width (* (+ (length ((data :koan) 5)) 2) 8))
   (/ hearth/height 2)
   27)

  # veins
  (paths/colorit (data :pm) (data :pm-bp) glimmer)

  (def bg (spektrum/rainbow-pastel 5))
  (def fg (spektrum/rainbow-dark 5))

  (matter/window
   skript/charboxborder-v2
   (data :skrp)
   (matter/bottomleft 5 5 2 4)
   @[0 0 0]
   fg bg (skript/bless ((data :koan) 0)) openbox data)

(matter/window
   skript/charboxborder-v2
   (data :skrp)
   (matter/bottomleft 7 7 15 3)
   @[0 0 0]
   fg bg (skript/bless ((data :koan) 1)) openbox data)

(matter/window
   skript/charboxborder-v2
   (data :skrp)
   (matter/topleft 8 8 15 5)
   @[0 0 0]
   fg bg (skript/bless ((data :koan) 2)) stroll data)

)

(defn render-file []
  (def data (mkdata))
  (draw data)
  (monolith/gfx-write-png "pyda.png")
  (for i 0 (* 20 60)
    (hearth/render-block draw data 44100 60 i)
    (set (data :shift) (% (+ (data :shift) (data :speed)) 1))))

(defn test []
  (hearth/gfx-init)
  (def data (mkdata))
  (draw data)
  (monolith/gfx-write-png "pyda.png"))

#(test)
