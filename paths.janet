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

(def weave-ee-under 12)
(def weave-fe-under 8)

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

(defn mkpathmap []
  (var p @{})
  (put p :rows 30)
  (put p :cols 24)
  (put p :map (array/new-filled (* (p :cols) (p :rows)) 0))
  (put p :width (* (p :cols) 8))
  (put p :height (* (p :rows) 8))
  (put p :xpos 0)
  (put p :ypos 0)
  p)

(defn moveto [p x y]
  (set (p :xpos) x)
  (set (p :ypos) y))

(defn right [p]
  (if (< (p :xpos) (- (p :cols) 1))
    (set (p :xpos) (+ (p :xpos) 1))))

(defn left [p]
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

(defn rightstamp [p n c &opt stamper]
  (default stamper stamp)
  (for i 0 n (stamper p c) (right p)))

(defn rightstampend [p c]
  (rightstamp p (- (p :cols) (p :xpos)) c))

(defn downstamp [p n c &opt stamper]
  (default stamper stamp)
  (for i 0 n (stamper p c) (down p)))

(defn downstampend [p c]
  (downstamp p (- (p :rows) (p :ypos)) c))

(defn colorrow [pathmap bp clr pos]
  (monolith/gfx-btprnt-stencil
   bp
   0 (+ 8 (* 8 pos)) (pathmap :width) 8 0 (* 8 pos)
   (clr 0) (clr 1) (clr 2)))

(defn mkbtprnt [pm]
  (monolith/btprnt-new
   (pm :width)
   (pm :height)))

(defn bpwrite [bp paths pm]
  (monolith/btprnt-wraptext
   bp
   (paths :font)
   @(0 0 (pm :width) (pm :height))
   0 0
   (apply string/from-bytes
          (map (fn (x) (+ x 32)) (pm :map)))))

(defn colorit [pm bp glimmer]
  (for i 0 (pm :rows)
    (colorrow pm
              bp
              (glimmer (% i (length glimmer)))
              i)))

(defn getstamp [p]
  ((p :map) (+ (* (p :ypos) (p :cols)) (p :xpos))))


# IN PROGRESS

(def pathstates
  @{
    wall-empty
      @{empty wall-empty
        wall-empty wall-empty
        road-empty weave-ee-under
        road-filled weave-fe-under
       }
})

(defn pickstamp [p c]
  (def s
    (if (nil? (pathstates c))
      nil
      ((pathstates c) (getstamp p))))
  (if (nil? s) c s))

(defn smartstamp [p c]
  (stamp p (pickstamp p c)))

(defn smartrightstamp [p n c]
  (rightstamp p n c smartstamp))

(defn smartdownstamp [p n c]
  (downstamp p n c smartstamp))
