(import ../skript :as skript)

(defn mkfont [txt rows cols]
  (def f @{})

  (put f :rows rows)
  (put f :cols cols)
  (put f :width (* cols 8))
  (put f :height (* rows 8))
  (put f :buf (skript/loadbuf
               txt
               (f :rows) (f :cols)
               (f :width) (f :height)))

  (put f :bp (monolith/btprnt-new (f :width) (f :height)))
  f)

#(def pathrows 8)
#(def pathcols 16)
#(def pathw (* pathcols 8))
#(def pathh (* pathrows 8))

#(def buf (skript/loadbuf
          "../pathways.txt"
#          pathrows pathcols
#          pathw pathh))

#(def font (monolith/btprnt-font-default))

#(def bp (monolith/btprnt-new pathw pathh))

(def paths (mkfont "../pathways.txt" 8 16))

(monolith/btprnt-drawbits
 (paths :bp) (paths :buf)
 @(0 0 (paths :width) (paths :height))
 0 0 (paths :width) (paths :height) 0 0)

(def bp (monolith/btprnt-new 128 128))
#(def font (monolith/btprnt-font-default))
(def font (monolith/btprnt-bp->font (paths :bp) 8 8))
(def main @(0 0
              (monolith/btprnt-width bp)
              (monolith/btprnt-height bp)))


(def text (apply string/from-bytes (range 33 (+ 33 44))))

(def empty " ")

(def road-filled "!")
(def road-empty "\"")

(def wall-filled "#")
(def wall-empty "$")

(def turn-sw-filled "5")
(def turn-sw-empty "6")

(def turn-nw-filled "7")
(def turn-nw-empty "8")

(def turn-ne-filled "9")
(def turn-ne-empty ":")

(def turn-se-filled ";")
(def turn-se-empty "<")

(def weave-ef-over "*")
(def weave-ef-under ")")
(def weave-ee-over "+")
(def weave-ee-under ",")

(def term-e-filled "1")
(def term-e-empty "2")
(def term-w-filled "-")
(def term-w-empty ".")

(def bulb-w-filled "E")
(def bulb-w-empty "F")

(def pathway-1
  (string
   turn-se-filled road-filled turn-sw-filled
   wall-filled term-e-empty weave-ef-over
   turn-ne-filled road-filled turn-nw-filled))

(def pathway-2
  (string
   turn-se-filled road-filled turn-sw-filled
   weave-ef-under road-empty weave-ef-over
   turn-ne-filled road-filled turn-nw-filled))

(def pathway-3
  (string
   turn-se-empty road-empty turn-sw-empty
   weave-ee-under road-empty weave-ee-over
   turn-ne-empty road-empty turn-nw-empty))


(def pathway-4
  (string
empty empty empty
bulb-w-empty empty empty
empty empty empty
   ))

(monolith/btprnt-wraptext
 bp
 font
 @(0 0 24 24)
 0 0 pathway-1)

(monolith/btprnt-wraptext
 bp
 font
 @(24 0 24 24)
 0 0 pathway-2)

(monolith/btprnt-wraptext
 bp
 font
 @((* 2 24) 0 24 24)
 0 0 pathway-3)

(monolith/btprnt-wraptext
 bp
 font
 @((* 3 24) 0 24 24)
 0 0 pathway-4)

(monolith/btprnt-write-pbm bp "out.pbm")
