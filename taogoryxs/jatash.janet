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

(defn slabit [p]
  (def bp (p :slab))
  (def skrp (p :skrp))
  (def koan (p :koan))
  (def main
    @[0 0
      (monolith/btprnt-width bp)
      (monolith/btprnt-height bp)])
  (monolith/btprnt-wraptext
   bp (skrp :bpfont)
   main
   0 8
   (string
    (skript/cursebless (koan 0))
    (skript/space)
    (skript/cursebless (koan 1))
    (skript/space)
    (skript/cursebless (koan 2))
    (skript/space)
    (skript/cursebless (koan 3))
    (skript/space)
    (skript/cursebless (koan 4))
    (skript/space)
    (skript/cursebless (koan 5))
    (skript/space)
))

  # (pp (skript/curse (skript/bless (koan 0))))
  # (pp (skript/curse @[11 0 25 7]))
)

(defn germinate []
  (var p @{})

  (put p :paths (skript/mkfont "../pathways.txt" 8 16))
  (put p :rainbow spektrum/rainbow1)
  (put p :koan
     (string/split
      " "
      "lazheewich zhozh zhesh mow ryp ceeso"))
  (put p :skrp (skript/mkfont "../a.txt" 8 8))
  (put p :pm (paths/mkpathmap))
  (put p :pm-bp (paths/mkbtprnt (p :pm)))
  (veins (p :pm))
  (paths/bpwrite (p :pm-bp) (p :paths) (p :pm))
  (put p :shift 0)
  (put p :speed 0.008)

  (put p :slab
     (monolith/btprnt-new hearth/width (- hearth/height 8)))
  (slabit p)
  p)

(defn draw [data]
  (def glimmer (spektrum/shift (data :rainbow) (data :shift)))
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (monolith/gfx-btprnt-stencil
   (data :slab)
   0 0
   (monolith/btprnt-width (data :slab))
   (monolith/btprnt-height (data :slab))
   0 0
   0 0 0)

  # (def koan (data :koan))
  # (skript/utter-blackletter (data :skrp) (koan 0) 0 16 27)
  # (pp (skript/bless (koan 0)))
)

(defn test []
  (hearth/gfx-init)
  (def data (germinate))
  (draw data)
  (monolith/gfx-write-png "jatash.png"))

(test)
