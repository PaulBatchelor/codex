(import giblang)

(def ww-dir "_site/codex")
(def webroot (if (ww-server?) "/wiki" "/codex"))
(def artifacts-path
  (if (ww-server?)
    "/artifacts"
    (string webroot "/artifacts")))

(def core-colors (table
"purple" @[0xdb 0xc9 0xe9]
"blue" @[0xc9 0xf4 0xfb]
"green" @[0xc9 0xef 0xcb]
"yellow" @[0xff 0xfa 0xc9]
"orange" @[0xff 0xe7 0xc9]
"red" @[0xfd 0xc9 0xc9]
))

(def core-colors-dark (table
"purple" @[0x22 0x01 0x3c]
"blue" @[0x04 0x2b 0x31]
"green" @[0x03 0x31 0x06]
"yellow" @[0x61 0x58 0x00]
"orange" @[0x5a 0x32 0x00]
"red" @[0x6d 0x00 0x00]
))

(defn pgexists? (name)
  (var db (ww-db))
  (var x
       (sqlite3/eval
        db (string
            "SELECT EXISTS(SELECT key from wiki "
            "where key is \""name"\") as doiexist;")))
  (= ((x 0) "doiexist") 1))

(defn pglink (page &opt target)
  (var link "")
  (if (nil? target)
    (set link page)
    (set link (string page "#" target)))
  (cond
    (= page "index")
    (string webroot "/")
    (pgexists? page)
    (string webroot "/" link) "#"))

(defn ref (link &opt name target)
  (default target nil)
  (if (nil? name)
    (org (string "[[" (pglink link) "][" link "]]"))
    (org
     (string
      "[["
      (pglink link target)
      "]["
      name
      "]]"))))

(defn img [path &opt alt]
  (print
   (string
    "<img src=\""
    path "\""
    (if-not (nil? alt) (string " alt=\"" alt "\""))
    ">")))

(defn slab [name]
  (img (string "/" (ww-name) "/" name ".png") name))

(defn video [path &opt alt fallback]
  (print "<video controls>")
  (print
   (string
    "<source src=\""
    path "\""
    (if-not (nil? alt) (string " alt=\"" alt "\""))
    " type=\"video/mp4\">"))
  (if-not (nil? fallback) (img fallback alt))
  (print "</video>"))

(defn glimmer [name]
  (video
   (string artifacts-path "/" (ww-name) "/" name ".mp4")
   name
   (string artifacts-path "/" (ww-name) "/" name ".png")))

(defn img-link [path link &opt alt]
  (print
   (string
    "<a href=\"" link "\">"
    "<img src=\""
    path "\""
    (if-not (nil? alt) (string " alt=\"" alt "\""))
    "></a>")))

(defn color-start [color]
  (string "<span style=\"color:"color"\">"))

(defn color-end []
  (string "</span>"))

(defn color-string [color str]
  (string
   (color-start color)
   str
   (color-end)))

(defn bodycolor [bgcolor fgcolor]
  (print
   (string
    "<body style=\"background-color:"
    bgcolor
    ";color:"fgcolor"\">")))

(defn colorhex (c)
  (string/format "#%02x%02x%02x" (c 0) (c 1) (c 2)))

(defn colorpair [name]
  (var c (giblang/color-meaning
          (giblang/extract-color name)))
  (if (nil? c)
    #(bodycolor "#dcdcdc" "#392423")
    (bodycolor "#FFFFFF" "#000000")
    (bodycolor
     (colorhex (core-colors c))
     (colorhex (core-colors-dark c)))))

(defn html-header
  []
(print
``<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>
``)

(if (= (ww-name) "index")
  (bodycolor "#FFFFFF" "#000000")
  (colorpair (ww-name)))
(print "<div id=\"main\">")
)

(defn html-footer
  []
  (print
``
</div>
</body>
</html>
``
))
(def colorband-light @[
"#fdc9c9"
"#ffe7c9"
"#fffac9"
"#c9efcb"
"#c9f4fb"
"#dbc9e9"
])

(def colorband-bold @[
"#e73131"
"#ff9420"
"#6ec81d"
"#006fd3"
"#5400a3"
])

(defn colorshuf [str &opt colors]
  (var c 0)
  (default colors colorband-bold)
  (each s str
    (prin
     (color-string
      (colors c)
      (string/from-bytes s)))
    (set c (% (+ c 1) (length colors)))))
