(def width 192)
(def height 256)

(defn render-block [draw data sr fps framepos]
  (draw data)
  (if (= (% framepos fps) 0) (print framepos))
  (monolith/compute (math/floor (/ sr fps)))
  (monolith/h264-append))

(defn gfx-init []
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height))
