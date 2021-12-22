(define (skript:load file)
  (lvl (list "loadglyphs" "skript" file (num2str 8) (num2str 8))))

(define (skript:text reg x y str)
  (reg)
  (lvl (list
        "bptxtbox"
        "zz"
        "[grab skript]"
        (num2str x) (num2str y) str)))

(define (skript:char reg x y str scale clr)
  (reg)
  (lvl (list
        "bpchar"
        "zz"
        "[grab skript]"
        (num2str x) (num2str y) str (num2str scale) (num2str clr))))

(define (skript:hline-iter reg x y s lstr sz)
  (let ((ns (cdr s)))
    (if (= sz 0)
        s
        (begin
          (skript:char reg x y (string (car s)) 1 1)
          (skript:hline-iter
           reg
           (+ x 8) y
           (if (null? ns) lstr ns)
           lstr
           (- sz 1))))))

(define (skript:hline reg x y str sz)
  (let ((lstr (string->list str)))
    (skript:hline-iter reg x y lstr lstr sz)))

(define (skript:vline-iter reg x y s lstr sz)
  (let ((ns (cdr s)))
    (if (= sz 0)
        s
        (begin
          (skript:char reg x y (string (car s)) 1 1)
          (skript:vline-iter
           reg
           x (+ y 8)
           (if (null? ns) lstr ns)
           lstr
           (- sz 1))))))

(define (skript:vline reg x y str sz)
  (let ((lstr (string->list str)))
    (skript:vline-iter reg x y lstr lstr sz)))

(define (skript:box reg x y str w h)
  (let ((lstr (string->list str)))
    (skript:vline-iter
     reg (+ x (* 8 (- w 1))) y
     (skript:hline-iter reg x y lstr lstr (- w 1))
     lstr (- h 1))

    (skript:hline-iter
     reg x (+ y (* 8 (- h 1)))
     (skript:vline-iter reg x y lstr lstr (- h 1))
     lstr w)
))
