(define knobkit-name "knobkit")
(define (knobkit-create) (monolith:knobs-new knobkit-name))
(define (knobkit-select)
  (monolith:page-select knobkit-name))
(define (knobkit-param p min max)
  (let ((lane (car p))
         (x (car (car (cdr p))))
         (y (car (cdr (car (cdr p))))))
    (scale (knobsval lane x y knobkit-name) min max)))
(define (knobkit-sparam p min max smooth)
  (port (knobkit-param p min max) smooth))
(define (knobkit-save prefix)
  (monolith:save-pages prefix (list knobkit-name)))
(define (knobkit-load prefix)
  (monolith:load-pages prefix (list knobkit-name)))
