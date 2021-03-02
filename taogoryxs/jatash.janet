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
  (put p :dark spektrum/rainbow-dark)
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
  (put p :slab-center-square (monolith/btprnt-grid
                       (p :slab) (p :slab-main)
                       3 3
                       1 1))
  (slabit p)
  (veins (p :pm))
  (paths/bpwrite (p :pm-bp) (p :paths) (p :pm))

  (put p :cbox (monolith/btprnt-new
                ((p :slab-center-square) 2)
                ((p :slab-center-square) 3)))
  p)

(defn pacing-square [bp creg sqrpos]
  (var sqr-xpos 0)
  (var sqr-ypos 0)

  (cond
    (< sqrpos 1)
    (do
      (set sqr-xpos (math/floor (* (% sqrpos 1) (- (creg 2) 8))))
      (set sqr-ypos 0))
    (< sqrpos 2)
    (do
      (set sqr-xpos (- (creg 2) 8))
      (set sqr-ypos
           (math/floor (* (% sqrpos 1) (- (creg 3) 8)))))
    (< sqrpos 3)
    (do
      (set sqr-xpos
           (math/floor (* (- 1 (% sqrpos 1)) (- (creg 3) 8))))
      (set sqr-ypos (- (creg 3) 8)))
    (< sqrpos 4)
    (do
      (set sqr-xpos 0)
      (set sqr-ypos
           (math/floor (* (- 1 (% sqrpos 1)) (- (creg 3) 8))))))

  (monolith/btprnt-rect-filled
   bp creg
   sqr-xpos sqr-ypos
   8 8 0)
)

(defn mkcenterpiece [p]
  (def bp (p :cbox))
  (def main
    @[0 0 (monolith/btprnt-width bp) (monolith/btprnt-height bp)])

  (def creg (monolith/btprnt-centerbox bp main 56 56))
  (var sqr-xpos 0)
  (var sqr-ypos 0)

  (monolith/btprnt-rect-filled bp main
                               (creg 0) (creg 1)
                               (creg 2) (creg 3)
                               1)

  (pacing-square bp creg (* (p :shift) 4))
  (pacing-square bp creg (* (% (+ (p :shift) 0.5) 1) 4))
  #(cond
  #  (< sqrpos 1)
  #  (do
  #    (set sqr-xpos (math/floor (* (% sqrpos 1) (- (creg 2) 8))))
  #    (set sqr-ypos 0))
  #  (< sqrpos 2)
  #  (do
  #    (set sqr-xpos (- (creg 2) 8))
  #    (set sqr-ypos
  #         (math/floor (* (% sqrpos 1) (- (creg 3) 8)))))
  #  (< sqrpos 3)
  #  (do
  #    (set sqr-xpos
  #         (math/floor (* (- 1 (% sqrpos 1)) (- (creg 3) 8))))
  #    (set sqr-ypos (- (creg 3) 8)))
  #  (< sqrpos 4)
  #  (do
  #    (set sqr-xpos 0)
  #    (set sqr-ypos
  #         (math/floor (* (- 1 (% sqrpos 1)) (- (creg 3) 8))))))

  #(monolith/btprnt-rect-filled
  # bp creg
  # sqr-xpos sqr-ypos
  # 8 8 0)
)

(defn colorsquare [p x y w h clr]
  (monolith/gfx-btprnt-stencil
   (p :slab)
   x y
   w h
   x y
   (clr 0) (clr 1) (clr 2)))

(defn colorglyphbox [p x y ncol nrow clr]
  (colorsquare
   p
   (* x 8) (* y 8)
   (* 8 ncol) 8 clr)
  (colorsquare
   p
   (* x 8) (* (+ y (- nrow 1)) 8)
   (* 8 ncol) 8 clr)
  (colorsquare
   p
   (* x 8) (* y 8)
   8 (* 8 nrow) clr)

  (colorsquare
   p
   (* (+ x (- ncol 1)) 8) (* y 8)
   8 (* 8 nrow) clr)
)

(defn draw [data]
  (def glimmer (spektrum/shift (data :rainbow) (data :shift)))
  (def pastel-glimmer (spektrum/shift (data :pastel) (data :shift)))

  (def bands (map pastel-glimmer @[5 4 5 4 3]))
  (def bg ((data :pastel) 5))
  (def fg ((data :dark) 5))

  (def cnt (data :slab-center-square))
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

  (colorsquare data 0 8 16 16 (glimmer 0))
  (colorsquare data 16 24 16 16 (glimmer 1))
  (colorsquare data 32 40 16 16 (glimmer 2))
  (colorsquare data 48 56 16 16 (glimmer 3))

  (colorsquare data (* 22 8) (* 29 8) 16 16 (glimmer 0))
  (colorsquare data (* 20 8) (* 27 8) 16 16 (glimmer 1))
  (colorsquare data (* 18 8) (* 25 8) 16 16 (glimmer 2))
  (colorsquare data (* 16 8) (* 23 8) 16 16 (glimmer 3))


  (colorsquare data (* 3 8) (* 10 8) 8 (* 8 8) (glimmer 4))
  (colorsquare data (* 20 8) (* 2 8) 8 (* 8 8) (glimmer 4))


  (colorglyphbox data 3 20 3 3 (glimmer 3))

  (colorglyphbox data 19 16 3 3 (glimmer 2))

  (colorglyphbox data 0 24 5 5 (glimmer 1))
  (colorglyphbox data 2 26 5 5 (glimmer 4))

  (monolith/gfx-rect-fill
   (cnt 0)
   (+ (cnt 1) 8)
   (cnt 2)
   (cnt 3)
   (bg 0)
   (bg 1)
   (bg 2))

  (mkcenterpiece data)

  (monolith/gfx-btprnt-stencil
   (data :cbox)
   (cnt 0)
   (+ (cnt 1) 8)
   (monolith/btprnt-width (data :cbox))
   (monolith/btprnt-height (data :cbox))
   0 0
   (fg 0) (fg 1) (fg 2)))

(defn render-file []
  (def p (germinate))
  (draw p)
  (monolith/gfx-write-png "jatash.png")
  (for i 0 (* 20 60)
    (hearth/render-block draw p 44100 60 i)
    (set (p :shift) (monolith/chan-get 0))))

(defn test []
  (hearth/gfx-init)
  (def data (germinate))
  (draw data)
  (monolith/gfx-write-png "out.png"))
