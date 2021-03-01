(import ../skript)
(import ../spektrum)
(import ../matter)
(import ../paths)
(import ../hearth)

(defn snake
  [pm x y
  bulb-e
  road
  turn-sw
  turn-nw
  turn-se
  turn-ne
  bulb-w]

  # vein 1
  (paths/moveto pm x y)
  (paths/stamp pm bulb-e)

  (paths/right pm)
  (paths/rightstamp pm 6 road)
  (paths/stamp pm turn-sw)

  (paths/down pm)
  (paths/stamp pm turn-nw)

  (paths/left pm)
  (paths/leftstamp pm 6 road)
  (paths/stamp pm turn-se)

  (paths/down pm)
  (paths/stamp pm turn-ne)

  # again

  (paths/right pm)
  (paths/rightstamp pm 6 road)
  (paths/stamp pm turn-sw)

  (paths/down pm)
  (paths/stamp pm turn-nw)

  (paths/left pm)
  (paths/leftstamp pm 6 road)
  (paths/stamp pm turn-se)

  (paths/down pm)
  (paths/stamp pm turn-ne)


  # again

  (paths/right pm)
  (paths/rightstamp pm 6 road)
  (paths/stamp pm turn-sw)

  (paths/down pm)
  (paths/stamp pm turn-nw)

  (paths/left pm)
  (paths/leftstamp pm 6 road)
  (paths/stamp pm turn-se)

  (paths/down pm)
  (paths/stamp pm turn-ne)

  # again
  (paths/right pm)
  (paths/rightstamp pm 6 road)
  (paths/stamp pm bulb-w))

(defn veins [pm]
  (snake pm 8 0
         paths/bulb-e-filled
         paths/road-filled
         paths/turn-sw-filled
         paths/turn-nw-filled
         paths/turn-se-filled
         paths/turn-ne-filled
         paths/bulb-w-filled)

  (snake pm 8 23
         paths/bulb-e-empty
         paths/road-empty
         paths/turn-sw-empty
         paths/turn-nw-empty
         paths/turn-se-empty
         paths/turn-ne-empty
         paths/bulb-w-empty))

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

(defn mkword [koan n &opt punc]
  (default punc (skript/dot))
  (string
   (skript/cursebless (koan n))
   punc))

(defn mksent [koan s &opt punc]
  (reduce (fn [x1 x2] (string x1 (mkword koan x2 punc))) "" s))

(defn slabit [p]
  (def bp (p :slab))
  (def skrp (p :skrp))
  (def koan (p :koan))
  (def main (p :slab-main))

  (def left (p :slab-left))
  (def right (p :slab-right))

  (monolith/btprnt-wraptext
   bp (skrp :bpfont)
   left
   0 8
   (mksent koan @[
                  0 1 2
                  3 0 1
                  2 3 0
                  1 2 3
                  0 1 2
                  0 1 2
                  3 0 1
                  2 3 0
                  1 2 3
                  0 1 2
                  0 1 2
                  3 0 1
                  2 3 0
                  1 2 3
                  0 1 2
                 ]))

  (monolith/btprnt-wraptext
   bp (skrp :bpfont)
   right
   0 8
   (mksent koan @[
                  4 5 1
                  3 3 1
                  4 5 1
                  2 3 1
                  4 5 1
                  0 5 1
                  4 5 1
                  3 3 1
                  4 5 1
                  2 3 1
                  4 5 1
                  0 5 1
                  4 5 1
                  3 3 1
                  4 5 1
                  2 3 1
                  4 5 1
                  0 5 1
                 ] (skript/parallel))))

(defn germinate []
  (var p @{})

  (put p :paths (skript/mkfont "../pathways.txt" 8 16))
  (put p :rainbow spektrum/rainbow1)
  (put p :pastel spektrum/rainbow-pastel)
  (put p :koan
     (string/split
      " "
      "lazheewich zhozh zhesh mow ryp ceeso"))
  (put p :skrp (skript/mkfont "../a.txt" 8 8))
  (put p :pm (paths/mkpathmap))
  (put p :pm-bp (paths/mkbtprnt (p :pm)))
  (put p :shift 0)
  (put p :speed 0.008)

  (put p :slab
     (monolith/btprnt-new hearth/width (- hearth/height 8)))
  (put p :slab-main
       @[0 0
         (monolith/btprnt-width (p :slab))
         (monolith/btprnt-height (p :slab))])
  (put p :slab-left (monolith/btprnt-grid
                     (p :slab) (p :slab-main)
                     3 1
                     0 0))
  (put p :slab-right (monolith/btprnt-grid
                     (p :slab) (p :slab-main)
                     3 1
                     2 0))
  (slabit p)
  (veins (p :pm))
  (paths/bpwrite (p :pm-bp) (p :paths) (p :pm))
  p)

(defn draw [data]
  (def glimmer (spektrum/shift (data :rainbow) (data :shift)))
  (def pastel-glimmer (spektrum/shift (data :pastel) (data :shift)))

  (def bands (map pastel-glimmer @[5 4 5 4 3]))
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)

  (paths/colorit (data :pm) (data :pm-bp) bands)

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
