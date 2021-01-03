(defn render-block [draw data sr fps framepos]
  (draw data)
  (if (= (% framepos fps) 0) (print framepos))
  (monolith/compute (math/floor (/ sr fps)))
  (monolith/h264-append))
