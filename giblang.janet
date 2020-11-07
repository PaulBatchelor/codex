(def cons (array
           "b" "c" "d" "f"
           "g" "h" "j" "k"
           "l" "m" "n" "p"
           "r" "s" "t" "v"
           "w" "z" "ch" "sh"
           "zh"))

(def vow (array "a" "e" "i" "o" "u" "y" "ee" "ai" "ae"))

(def colors @(
"pa" # red
"fa" # orange
"thu" # yellow
"day" # green
"yu" # blue
"go" # purple
))

(def color-lookup
  (table
   "pa" "red"
   "fa" "orange"
   "thu" "yellow"
   "day" "green"
   "yu" "blue"
   "go" "purple"))

(def syl-upper
  (array "b" "c" "d" "f" "g" "h" "j" "k"
         "l" "m" "n" "p" "q" "r" "s" "t"
         "v" "w" "x" "y" "z" "ch" "zh"
         "th" "ng" "sh"))

(def syl-mid
  (array "a" "e" "o" "i" "u" "yx" "q" "uo"
         "ao" "au" "ua" "ii" "eu" "ue"))

(def syl-tail
  (array "l" "r" "zk" "s" "" "c"))

# Note: because I'm dumb, syllables must be manually added
# to the grammar *and* the tables above
(def word-grammar
  '{:upper
      (+ "ch" "zh" "th" "ng" "sh" "b" "c"
         "d" "f" "g" "h" "j" "k" "l" "m" "n"
         "p" "q" "r" "s" "t" "v" "w" "x" "y" "z")
    :mid (+ "au" "ao" "ua" "ii" "eu" "ue" "uo"
            "a" "e" "o" "i" "u" "yx" "q" "uo")
    :tail (+ "l" "r" "zk" "s" "" "ck")
    :color (+ "pa" "fa" "thu" "day" "yu" "go")
    :main (* :upper :mid (capture :color))})


(defn rpick (t)
  (t (math/floor (* (math/random) (length t)))))


(defn seed () (math/seedrandom (os/time)))

(defn syl () (string (rpick cons) (rpick vow)))

(defn word ()
  (do
    (var str "")
    (for i 0 (+ (math/floor (* (math/random) 3)) 1)
      (set str (string str (syl))))
    (cond (> (math/random) 0.2)
          (set str (string str (rpick cons))))
    (string str)))

(defn utter ()
  (seed)
  (print (word)))

(defn sentence (&opt maxwords minwords)
  (default maxwords 20)
  (default minwords 3)

  (def nwords (+ minwords
                 (math/floor
                  (* (math/random)
                     (- maxwords minwords)))))
  (var words @[])

  (for i 0 nwords (array/push words (word)))
  (string (string/join words " ") "."))

(defn prayer ()
  (seed)
  (print (sentence 10)))

(defn paragraph [&opt minsent maxsent]
  (default maxsent 5)
  (default minsent 3)

  (def nsentences (+ minsent
                     (math/floor
                      (* (math/random)
                         (- maxsent minsent)))))
  (var sentences @[])

  (for i 0 nsentences (array/push sentences (sentence)))
  (string (string/join sentences " ") " "))

(defn header (level)
  (string (string/repeat "*" level) " " (word)))

(defn pgname ()
  (string (rpick syl-upper)
          (rpick syl-mid)
          (rpick colors)
          (rpick syl-upper)
          (rpick syl-mid)
          (rpick syl-tail)))

(defn extract-color (name)
  (var c (peg/match word-grammar name))
  (if-not (nil? c) (c 0)))

(defn color-meaning (name)
  (color-lookup name))

(defn writesection [f]
  (var nsubheaders (math/floor (* (math/random) 4)))
  (if (= nsubheaders 1) (set nsubheaders 0))
  (file/write f (string (header 1) "\n"))
  (if (= nsubheaders 0)
    (file/write f (string (paragraph) "\n"))
    (for n 0 nsubheaders
      (do
        (file/write f (string (header 2) "\n"))
        (file/write f (string (paragraph) "\n"))))))

(defn page (name)
  (print "conjuring " name)
  (var f (file/open (string name ".org") :w))
  (var nheaders (+ (math/floor (* (math/random) 4)) 1))

  (file/write f (string "#+TITLE: " name "\n"))

  (for h 0 nheaders (writesection f))

  (file/close f))
