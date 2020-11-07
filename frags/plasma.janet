(defn vertical-sine []
  (var width 320)
  (var height 200)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)

  (for y 0 height
    (for x 0 width
      (var color (math/floor (+ 128 (* 128 (math/sin (/ x 8))))))
      (monolith/gfx-pixel-set x y color color color 255)))

  (monolith/gfx-write-png "vertical_sine.png"))
(defn radial-sine []
  (var width 320)
  (var height 200)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)

  (for y 0 height
    (for x 0 width
      (var kernel
           (math/sqrt
            (+
             (* (- x (/ width 2)) (- x (/ width 2)))
             (* (- y (/ height 2)) (- y (/ height 2))))))
      (var color
           (math/floor
            (+ 128 (* 128 (math/sin kernel)))))
      (monolith/gfx-pixel-set x y color color color 255)))

  (monolith/gfx-write-png "radial_sine.png"))
(defn basic-plasma (w h xfreq yfreq)
  (var p (array/new (* w h)))
  (for y 0 h
    (for x 0 w
      (put p
           (+ (* y w) x)
           (* 0.25
              (+ 2
              (+ (math/sin (/ x xfreq))
                 (math/sin (/ y yfreq))))))))


  p)
(defn basic-plasma-demo []
  (var width 320)
  (var height 200)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)

  (var p (basic-plasma width height 8 8))

  (for y 0 height
    (for x 0 width
      (var color (math/floor (* (p (+ (* y width) x)) 256)))
      (monolith/gfx-pixel-set x y color color color 255)))

  (monolith/gfx-write-png "basic_plasma.png"))
(defn pal-huecycle [size s l]
  (var pal (array/new size))
  (var incr (/ 1 size))

  (for c 0 size
    (put pal c
         (map
          (fn (x) (* 255 x))
          (monolith/hsluv2rgb
           (* (* incr c) 360)
           s
           l))))
  pal)
(defn pal-huecycle-demo []
  (var width 320)
  (var height 200)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)

  (var pal (pal-huecycle width 100 53))

  #(pp pal)
  #(pp (monolith/hsluv2rgb 10 100 100))

  (for x 0 width
    (var color (pal x))
    (monolith/gfx-line
     x 0 x height
     (color 0)
     (color 1)
     (color 2)))
  (monolith/gfx-write-png "pal_huecycle.png"))
(defn pal-colorbands [size colors]
  (var pal (array/new size))
  (var ncolors (length colors))
  (var inc (/ 1 size))

  (for i 0 size
    (var pos (* (* inc i) (- ncolors 1)))
    (var ipos (math/floor pos))
    (var frac (- pos ipos))
    (var c1 (colors ipos))
    (var c2 (colors (+ ipos 1)))

    (var out
         @((+
            (* (- 1 frac) (c1 0))
            (* frac (c2 0)))
           (+
            (* (- 1 frac) (c1 1))
            (* frac (c2 1)))
           (+
            (* (- 1 frac) (c1 2))
            (* frac (c2 2)))))
    (put pal i out))

  pal)
(defn demo-pal-colorbands []
  (var width 320)
  (var height 200)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)

  (var pal (pal-colorbands
            width
            @([255 0 0] [0 255 0] [0 0 255])))

  (for x 0 width
    (var color (pal x))
    (monolith/gfx-line
     x 0 x height
     (color 0)
     (color 1)
     (color 2)))
  (monolith/gfx-write-png "pal_colorbands.png"))
(defn plasma-make [w h f]
  (var p (array/new (* w h)))
  (defn norm (in)
    (/ (+ in (length f)) (* (length f) 2)))
  (for y 0 h
    (for x 0 w
      (put p
           (+ (* y w) x)
           (norm
            (reduce
              (fn (a b)
                #(print "a: " a)
                #(print "b: " b)
                (+ a (b x y w h))) 0 f)))))
  p)
(defn interesting-plasma [w h]
  (var p (array/new (* w h)))
  (defn norm (in)
    (/ (+ 4 in) 8))
  (for y 0 h
    (for x 0 w
      (put p
           (+ (* y w) x)
           (norm (+
                  (math/sin (/ x 16))
                  (math/sin (/ y 8))
                  (math/sin (/ (+ x y) 16))
                  (math/sin
                   (/ (math/sqrt (+ (* x x) (* y y))) 8)))))))


  p)
(defn demo-interesting-plasma ()
  (var width 320)
  (var height 200)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)

  (var p (interesting-plasma width height))
  (var lite-terra [0xE8 0xDD 0xCB])
  (var terra [0xCD 0xB3 0x80])
  (var aqua [0x03 0x65 0x64])
  (var aqua-profonda [0x03 0x36 0x49])
  (var abisso [0x03 0x16 0x34])

  (var pal (pal-colorbands
            256
            [lite-terra terra aqua
            aqua-profonda
            aqua-profonda
            abisso
            abisso
            abisso
            abisso
            abisso
             ]))

  (for y 0 height
    (for x 0 width
      (var pos (math/floor (* (p (+ (* y width) x)) 256)))
      (var color (pal pos))
      (monolith/gfx-pixel-set
       x y
       (color 0)
       (color 1)
       (color 2)
       255)))

  (monolith/gfx-write-png "interesting_plasma.png"))
(defn demo-basic-palette-mapping []
  (var width 320)
  (var height 200)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)

  (var p (basic-plasma width height 8 8))
  (var pal (reverse (pal-huecycle 256 80 53.7)))

  (for y 0 height
    (for x 0 width
      (var color
           (pal
            (math/floor
             (* (length pal) (p (+ (* y width) x))))))
      (monolith/gfx-pixel-set
       x y
       (color 0)
       (color 1)
       (color 2) 255)))

  (monolith/gfx-write-png "basic_palette_mapping.png"))
(defn demo-basic-palette-looping ()
  (var width 320)
  (var height 200)
  (var fps 60)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)


  (var p (interesting-plasma width height))
  (var lite-terra [0xE8 0xDD 0xCB])
  (var terra [0xCD 0xB3 0x80])
  (var aqua [0x03 0x65 0x64])
  (var aqua-profonda [0x03 0x36 0x49])
  (var abisso [0x03 0x16 0x34])

  (var pal (pal-colorbands
            256
            [abisso
             abisso
             lite-terra
             terra
             aqua
             aqua-profonda
             aqua-profonda
             abisso
             abisso
             abisso
            ]))

  (monolith/h264-begin "basic_palette_looping.h264" fps)
  (for n 0 (* fps 10)
    (print "frame " n)
    (for y 0 height
      (for x 0 width
        (var pos (math/floor (* (p (+ (* y width) x)) 256)))
        (var color (pal (% (+ pos n) 256)))
        (monolith/gfx-pixel-set
         x y
         (color 0)
         (color 1)
         (color 2)
         255)))
    (monolith/h264-append))
  (monolith/h264-end))
(defn more-interesting-plasma [w h]
  (var p (array/new (* w h)))
  (defn norm (in)
    (/ (+ 4 in) 8))
  (for y 0 h
    (for x 0 w
      (put p
           (+ (* y w) x)
           (norm (+
                  (math/sin (/ x 16))
                  (math/sin (/ y 32))
                  (math/sin
                   (/ (math/sqrt
                       (+
                        (*
                         (/ (- x w) 2.0)
                         (/ (- x w) 2.0))
                        (*
                         (/ (- y h) 2.0)
                         (/ (- y h) 2.0))
                        )

                       ) 8))
                  (math/sin
                   (/ (math/sqrt (+ (* x x) (* y y))) 8)))))))


  p)
(defn demo-more-interesting-plasma ()
  (var width 320)
  (var height 200)
  (var fps 60)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)


  (var p (more-interesting-plasma width height))
  (var pastel-pink [0xFF 0xBA 0xCD])
  (var dark-pink [0xDA 0x46 0x7D])
  (var deep-pink [0xCB 0x01 0x62])

  (var rollup1 [0xff 0x44 0x00])
  (var rollup2 [0xff 0xdd 0x00])
  (var rollup3 [0x88 0xff 0x00])

  (var sunset1 [0xff 0xdd 0x00])
  (var sunset2 [0xff 0x88 0x00])
  (var sunset3 [0xff 0x22 0x00])
  (var sunset4 [0xff 0x00 0x88])
  (var sunset5 [0x99 0x00 0xff])


   (var pal (pal-colorbands
             256
             [
             pastel-pink
             pastel-pink
             dark-pink
             pastel-pink
             pastel-pink
             dark-pink
             deep-pink
             dark-pink
             pastel-pink
             ]))
  #(var pal (pal-colorbands
  #          256
  #          [
  #          rollup1
  #          rollup2
  #          rollup3
  #          rollup1
  #          ]))
  #(var pal (pal-colorbands
  #          256
  #          [
  #          sunset1
  #          sunset2
  #          sunset3
  #          sunset4
  #          sunset5
  #          sunset1
  #          ]))

  (monolith/h264-begin "more_interesting_plasma.h264" fps)
  (for n 0 (* fps 10)
    (print "frame " n)
    (for y 0 height
      (for x 0 width
        (var pos (math/floor (* (p (+ (* y width) x)) 256)))
        (var color (pal (% (+ pos n) 256)))
        (monolith/gfx-pixel-set
         x y
         (color 0)
         (color 1)
         (color 2)
         255)))
    (monolith/h264-append))
  (monolith/h264-end))
(defn demo-plasma-sound ()
  (var width 320)
  (var height 200)
  (var fps 60)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)
  (monolith/runt-loader)
  (monolith/runt-eval ``
                      patchwerk nodes

                      1 8 / 1 sine 0 1 biscale

                      bhold 0 cabset

                      0 cabget 4 20 scale metro
                      bdup
                      0.001 0.001 0.008 tenvx
                      bswap -4 4 trand
                      0 cabget 48 80 scale add mtof
                      0.5 sine mul
                      bdup
                      0 cabget 0.3 0.9 scale 0.1 0.001 8 randi 1 vdelay
                      bdup jcrev add dcblock
                      add

                      bdup bdup
                      0 cabget 0.3 0.98 scale 10000 revsc bdrop
                      -20 ampdb mul dcblock add

                      "plasma_sound.wav" wavout
                      0 cabget 0 monset

                      0 cabget bunhold

                      monout ps
                      ``)

  (var p (more-interesting-plasma width height))
  (var pastel-pink [0xFF 0xBA 0xCD])
  (var dark-pink [0xDA 0x46 0x7D])
  (var deep-pink [0xCB 0x01 0x62])

  (var pal (pal-colorbands
            256
            [
             pastel-pink
             pastel-pink
             dark-pink
             pastel-pink
             pastel-pink
             dark-pink
             deep-pink
             dark-pink
             pastel-pink
            ]))

  (monolith/h264-begin "plasma_sound.h264" fps)
  (var off 0)
  (var speed 1)
  (for n 0 (* fps 30)
    (monolith/compute (/ 44100 fps))
    (set speed (* (monolith/chan-get 0) 9))
    (print "frame " n)
    (for y 0 height
      (for x 0 width
        (var pos (math/floor (* (p (+ (* y width) x)) 256)))
        (var color (pal (% (math/floor (+ pos off)) 256)))
        (monolith/gfx-pixel-set
         x y
         (color 0)
         (color 1)
         (color 2)
         255)))
    (set off (% (+ off speed) 256))
    (monolith/h264-append))

  (monolith/h264-end)
  (os/shell
   (string
    "ffmpeg -y -i plasma_sound.h264 -i plasma_sound.wav "
    "-vf format=yuv420p "
    "-ac 2 "
    "-codec:a libmp3lame -b:a 320k "
    "plasma_sound.mp4"
    )))
(defn demo-plasma-make ()
  (var width 320)
  (var height 200)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)

  (var
   p
   (plasma-make
    width height
    @((fn (x y w h) (math/sin (/ x 16)))
      (fn (x y w h) (math/sin (/ y 8)))
      (fn (x y w h) (math/sin (/ (+ x y) 16)))
      (fn (x y w h)
        (math/sin
         (/ (math/sqrt (+ (* x x) (* y y))) 8))))))

  (var lite-terra [0xE8 0xDD 0xCB])
  (var terra [0xCD 0xB3 0x80])
  (var aqua [0x03 0x65 0x64])
  (var aqua-profonda [0x03 0x36 0x49])
  (var abisso [0x03 0x16 0x34])

  (var pal (pal-colorbands
            256
            [lite-terra terra aqua
            aqua-profonda
            aqua-profonda
            abisso
            abisso
            abisso
            abisso
            abisso
             ]))

  (for y 0 height
    (for x 0 width
      (var pos (math/floor (* (p (+ (* y width) x)) 256)))
      (var color (pal pos))
      (monolith/gfx-pixel-set
       x y
       (color 0)
       (color 1)
       (color 2)
       255)))

  (monolith/gfx-write-png "plasma_make.png"))
(defn demo-plasma-dynamic ()
  (var width 320)
  (var height 200)
  (var fps 60)
  (monolith/gfx-fb-init)
  (monolith/gfx-setsize width height)
  (monolith/runt-loader)
  (monolith/runt-eval
``
patchwerk nodes

1 8 / 1 sine 0 1 biscale

bhold 0 cabset

0 cabget 4 20 scale metro
bdup
0.001 0.001 0.008 tenvx
bswap -4 4 trand
0 cabget 48 80 scale add mtof
0.5 sine mul
bdup
0 cabget 0.3 0.9 scale 0.1 0.001 8 randi 1 vdelay
bdup jcrev add dcblock
add

bdup bdup
0 cabget 0.3 0.98 scale 10000 revsc bdrop
-20 ampdb mul dcblock add

"plasma_dynamic.wav" wavout
0 cabget 0 monset

0 cabget bunhold

monout ps
``)

  (var jungle-green [0x04 0x82 0x43])
  (var green-teal [0x32 0xbf 0x84])
  (var merge-light [0xCA 0xFF 0xFB])

  (var pal (pal-colorbands
            256
            [
             jungle-green
             jungle-green
             green-teal
             jungle-green
             jungle-green
             green-teal
             merge-light
             green-teal
             jungle-green
            ]))
  (monolith/h264-begin "plasma_dynamic.h264" fps)
  (var off 0)
  (var speed 1)

  (defn cable-scale (mn mx)
    (+ mn
       (* (- mn mx) (- 1 (monolith/chan-get 0)))))

  (for n 0 (* fps 10)
    (monolith/compute (/ 44100 fps))
    (set speed (* (monolith/chan-get 0) 9))

    (var
     p
     (plasma-make
      width height
      @((fn (x y w h)
          (math/sin (/ x (cable-scale 7 16))))
        (fn (x y w h) (math/sin (/ y 16)))
        (fn (x y w h) (math/sin (/ (+ x y) (cable-scale 10 16))))
        (fn (x y w h)
          (math/sin
           (/ (math/sqrt (+ (* x x) (* y y))) 8))))))
    (print "frame " n)
    (for y 0 height
      (for x 0 width
        (var pos (math/floor (* (p (+ (* y width) x)) 256)))
        (var color (pal (% (math/floor (+ pos off)) 256)))
        (monolith/gfx-pixel-set
         x y
         (color 0)
         (color 1)
         (color 2)
         255)))
    (set off (% (+ off speed) 256))
    (monolith/h264-append))

  (monolith/h264-end)
  (os/shell
   (string
    "ffmpeg -y -i plasma_dynamic.h264 -i plasma_dynamic.wav "
    "-vf format=yuv420p "
    "-ac 2 "
    "-codec:a libmp3lame -b:a 320k "
    "plasma_dynamic.mp4"
    )))
