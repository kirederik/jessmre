(deftemplate coordinate (multislot c) )
(watch all)
(reset)
(defrule example-2
    (coordinate (c ?y ?tail))
    =>
    (printout t "Saw 'coordinate " ?y "'" crlf))

(assert (coordinate (c 12 2)))
(run)