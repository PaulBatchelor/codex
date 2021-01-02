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
