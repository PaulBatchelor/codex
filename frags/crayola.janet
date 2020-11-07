(monolith/gfx-fb-init)
(monolith/gfx-zoom 1)
(var rows 7)
(var cols 19)

(monolith/gfx-setsize (* cols 8) (* rows 8))

(def fp (file/open "crayola.json" :r))

(def json-str (file/read fp :all))

(def tbl (json/decode json-str))

(var pos 0)

(print (length tbl))

(each color tbl
  (var rgb (color "rgb"))
  (var xpos (* (% pos cols) 8))
  (var ypos (* (math/floor (/ pos cols)) 8))
  (monolith/gfx-rect-fill
   xpos
   ypos
   8 8
   (rgb 0)
   (rgb 1)
   (rgb 2))
  (set pos (+ pos 1)))

(monolith/gfx-write-png "crayola.png")

(file/close fp)
