(defn loadbuf [filename rows chars width height]
  #(var buf (array/new (* width height)))
  (var xpos 0)
  (var ypos 0)
  (var buf (buffer/new-filled (* width height)))
  (var f (file/open filename :r))
  (var linepos 0)
  (def width (* chars 8))
  (def height (* rows 8))

  (defn pixel [x y s]
    (var off (math/floor (/ x 8)))
    (var pos (+ (* y chars) off))
    (var bitpos (- x (* off 8)))

    (if (= s 1)
      (set (buf pos)
           (bor (buf pos) (blshift 1 bitpos)))
      (set (buf pos)
           (band (buf pos) (bnot (blshift 1 bitpos))))))

  (for i 0 (* width height) (set (buf i) 0))

  (loop [line :iterate (:read f :line)]
    (var a (string/bytes line))
    (if (and (>= (length a) 9) (or (= (a 0) 45) (= (a 0) 35)))
      (do
        (if (> linepos 7)
          (do (set linepos 0)
              (set xpos (+ xpos 8))
              (if (> xpos (* (- chars 1) 8))
                (do (set xpos 0) (set ypos (+ ypos 8))))))

        (for i 0 8
          (cond
            (= (a i) 45) (pixel (+ xpos i) (+ ypos linepos) 0)
            (= (a i) 35) (pixel (+ xpos i) (+ ypos linepos) 1)))
        (set linepos (+ linepos 1)))))

  (file/close f)
  buf)

(defn char [bp x y ch c rows]
  (var cx (% ch rows))
  (var cy (math/floor (/ ch rows)))
  (monolith/gfx-btprnt-stencil
   bp x y 8 8 (* cx 8) (* cy 8) (c 0) (c 1) (c 2)))

(defn rchar [bp x y c rows nchars]
  (def ch (math/floor (* (math/random) nchars)))
  (char bp x y ch c rows))

(defn getcolor [clr i]
  (if (array? (clr 0)) (clr (% i (length clr))) clr))

(defn charhline [bp xpos ypos size clr rows nchars &opt pat]
  (default pat nil)
  (for i 0 size
    (if (nil? pat)
    (rchar bp (+ xpos (* i 8)) ypos (getcolor clr i) rows nchars)
    (char bp (+ xpos (* i 8)) ypos (pat (% i (length pat)))
          (getcolor clr i) rows))))

(defn charhline-v2 [fnt x y sz clr &opt pat]
  (default pat nil)
  (charhline (fnt :bp)
             x y
             sz clr
             (fnt :rows) (fnt :cols)
             pat))

(defn charvline [bp xpos ypos size clr rows nchars &opt pat]
  (default pat nil)
  (for i 0 size
    (if (nil? pat)
      (rchar
       bp xpos (+ ypos (* i 8))
       (getcolor clr i)
       rows nchars)
      (char bp
            xpos (+ ypos (* i 8))
            (pat (% i (length pat)))
            (getcolor clr i) rows))))

(defn charvline-v2 [fnt x y sz clr &opt pat]
  (default pat nil)
  (charvline (fnt :bp)
             x y
             sz clr
             (fnt :rows) (fnt :cols)
             pat) (default pat nil))


(defn charboxborder [bp xpos ypos ncols nrows clr rows nchars &opt pat]
  (default pat nil)
  (charhline bp xpos ypos ncols clr rows nchars pat)
  (charhline bp xpos (+ ypos (* (- nrows 1) 8)) ncols clr rows nchars pat)

  (charvline bp xpos (+ ypos 8) (- nrows 2) clr rows nchars pat)
  (charvline
   bp
   (+ xpos (* (- ncols 1) 8))
   (+ ypos 8) (- nrows 2) clr rows nchars pat))

(defn charboxborder-v2 [fnt xpos ypos ncols nrows clr &opt pat]
  (default pat nil)
  (charboxborder (fnt :bp)
                 xpos ypos
                 ncols nrows
                 clr
                 (fnt :rows) (fnt :cols) pat))


(defn charbox [bp xpos ypos ncols nrows clr rows nchars &opt pat]
  (default pat nil)

  (for y 0 nrows
    (for x 0 ncols
      (if (nil? pat)
        (rchar bp
               (+ xpos (* x 8))
               (+ ypos (* y 8)) clr rows nchars)
        (char bp
              (+ xpos (* x 8))
              (+ ypos (* y 8))
              (% (+ (* y ncols) x) (length pat))
              clr rows)))))

(defn jewel [bp xpos ypos clr rows nchars &opt patout patin]
  (default patout nil)
  (default patin nil)
  (def black @[0 0 0])
  (charboxborder bp xpos ypos 4 4 black rows nchars patout)
  (charbox
   bp
   (+ xpos 8) (+ ypos 8)
   2 2
   clr
   rows
   nchars
   patin))

(defn mkfont [txt rows cols]
  (def f @{})

  (put f :rows rows)
  (put f :cols cols)
  (put f :width (* cols 8))
  (put f :height (* rows 8))
  (put f :buf (loadbuf
               txt
               (f :rows) (f :cols)
               (f :width) (f :height)))

  (put f :bp (monolith/btprnt-new (f :width) (f :height)))
  (put f :bpfont (monolith/btprnt-bp->font (f :bp) 8 8))

  (monolith/btprnt-drawbits
   (f :bp) (f :buf)
   @(0 0 (f :width) (f :height))
   0 0 (f :width) (f :height) 0 0)

  (put f :font (monolith/btprnt-bp->font (f :bp) 8 8))

  f)

(defn bless (str)
  (map (fn (x) (- x 97)) (string/bytes str)))

(defn utter-blackletter [fnt utter x y punc]
  (charhline-v2
   fnt x y
   (+ (length utter) 1)
   @[0 0 0]
   (array/push (bless utter) punc)))

(defn curse [bytes]
  (apply string/from-bytes
         (map (fn (x) (+ x 32)) bytes)))
