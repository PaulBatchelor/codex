(import ../skript)
(import ../spektrum)
(import ../matter)
(import ../paths)
(import ../hearth)

(defn mkdata []
  (var p @{})
  (put p :rainbow spektrum/rainbow1)
  (put p :koan
     (string/split
      " "
      "jailegysh bid laelazeel kusaizho shocog jyb"))
  (put p :skrp (skript/mkfont "../a.txt" 8 8))
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
   27))

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
