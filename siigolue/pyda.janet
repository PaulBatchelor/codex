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
  (paths/smartdownstamp pm 5 paths/wall-empty)
  (paths/stamp pm paths/bulb-s-empty)

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
  p)

(defn draw [data]
  (def glimmer (data :rainbow))
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
   fg bg (skript/bless ((data :koan) 0)) matter/empty data)

(matter/window
   skript/charboxborder-v2
   (data :skrp)
   (matter/bottomleft 7 7 15 3)
   @[0 0 0]
   fg bg (skript/bless ((data :koan) 1)) matter/empty data)

(matter/window
   skript/charboxborder-v2
   (data :skrp)
   (matter/topleft 8 8 15 5)
   @[0 0 0]
   fg bg (skript/bless ((data :koan) 2)) matter/empty data)


)

(defn render-file []
  (def data (mkdata))
  (draw data)
  (monolith/gfx-write-png "pyda.png")
  (for i 0 (* 20 60)
    (hearth/render-block draw data 44100 60 i)))

(defn test []
  (hearth/gfx-init)
  (def data (mkdata))
  (draw data)
  (monolith/gfx-write-png "pyda.png"))

#(test)
