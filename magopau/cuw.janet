(import ../skript :as skript)
(import ../spektrum :as spektrum)
(import ../matter :as matter)


(def paths (skript/mkfont "../pathways.txt" 8 16))

(def bp (monolith/btprnt-new 128 128))

(def font (paths :font))
(def main @(0 0
              (monolith/btprnt-width bp)
              (monolith/btprnt-height bp)))


(def text (apply string/from-bytes (range 33 (+ 33 44))))

(def koan @["nymawa" "shaef" "gov"])

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

(def slab-width 192)
(def slab-height 256)

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
   empty empty empty))

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

#(monolith/btprnt-write-pbm bp "out.pbm")

(def main-rainbow spektrum/rainbow1)

(def skrp (skript/mkfont "../a.txt" 8 8))

(def black @[0 0 0])
(defn draw (rainbow glimmer)
  (def bg (spektrum/rainbow-pastel 5))
  (def fg (spektrum/rainbow-dark 5))
  (monolith/gfx-fill 255 255 255)
  (spektrum/border glimmer 24 32)
  (skript/utter-blackletter skrp (koan 0) 8 16 27)
  (skript/utter-blackletter skrp (koan 1) 8 (+ 16 8) 27)
  (skript/utter-blackletter skrp (koan 2) 8 (+ 16 16) 27)

  (matter/window
   skript/charboxborder-v2
   skrp
   (matter/bottomleft 8 8 1 1)
   black
   fg bg (skript/bless (koan 0)) matter/empty))

(monolith/gfx-fb-init)
(monolith/gfx-setsize slab-width slab-height)
(draw main-rainbow main-rainbow)
(monolith/gfx-write-png "cuw.png")
