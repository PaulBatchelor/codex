(import ../skript)
(import ../spektrum)
(import ../matter)
(import ../paths)
(import ../hearth)

(defn mkdata []
  (var p @{})
  (put p :rainbow spektrum/rainbow1)
  p
)

(defn draw [data]
  (def glimmer (data :rainbow))
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32))

(defn render-file []
  (def data (mkdata))
  (for i 0 (* 20 60)
    (hearth/render-block draw data 44100 60 i)))
