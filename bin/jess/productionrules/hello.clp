(deftemplate lista (multislot list))
(deftemplate user (slot age))

(defrule imprime-cabeca
		"Imprime a cabeça da lista"
    ?l <- (lista (list ?head $?tail))
    =>
    (printout t ?head crlf)
    (assert (lista (list $?tail)))
;	(modify ?l (lista (list $?tail)))
    )

(defrule imprime-idade
	"comment"
	(user (age ?a))
    (test (eq ?a 2))
    =>
    (printout t "Hello, little one!" crlf)
)

(assert (lista (list 1 2 3 4)))
;; (printout t (lista (list)))

(run)
