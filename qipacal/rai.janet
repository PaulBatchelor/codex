(import ../skript)
(import ../spektrum)
(import ../matter)
(import ../paths)
(import ../hearth)

(defn mkdata []
  (var p @{})
  (put p :paths (skript/mkfont "../pathways.txt" 8 16))
  (put p :rainbow spektrum/rainbow1)
  (put p :koan
     (string/split
      " "
      "peer gek hishytob waraen zaewykof hip saij daer"))
  (put p :skrp (skript/mkfont "../a.txt" 8 8))
  (put p :pm (paths/mkpathmap))
  (put p :pm-bp (paths/mkbtprnt (p :pm)))
  (paths/bpwrite (p :pm-bp) (p :paths) (p :pm))
  (put p :shift 0)
  (put p :speed 0.008)
  p)

(defn draw [data]
  (def glimmer (spektrum/shift (data :rainbow) (data :shift)))
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)

  (for i 0 (length (data :koan))
    (skript/utter-blackletter
     (data :skrp)
     ((data :koan) i)
     8 (* 8 (+ i 2)) (if (= i (- (length (data :koan)) 1)) 30 27)))

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
  (monolith/gfx-write-png "rai.png"))

(test)
