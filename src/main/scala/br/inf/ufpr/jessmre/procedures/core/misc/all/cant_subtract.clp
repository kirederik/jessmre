(provide br/inf/ufpr/jessmre/procedures/core/misc/cant_subtract)

(require br/inf/ufpr/jessmre/procedures/commons/templates)
(require br/inf/ufpr/jessmre/procedures/commons/functions)

; Initial rule
; IF exists a problem and there is no subgoals
; THEN set the subtract as the new subgoal
(defrule setup-rule
	"Regra que configura a base de fatos"
    ?problem <- (problem (subgoals))
    ?subtract <- (subtraction (top $?top) (bottom $?bottom))
	=>
    (modify ?subtract (result (create$ _)))
    (bind ?endGoal end-goal)
    (modify ?problem (subgoals ?endGoal))
)


(defrule end-rule
	"Última regra. Apenas imprime o resultado"
    ?problem <- (problem (subgoals ?endGoal $?rest))
    (test (eq ?endGoal end-goal))
    ?r <- (subtraction (result $?res))
    ?d <- (desirable (result $?des))
	=>
    ; (facts)
;    (if (neq (implode$ $?res) (implode$ $?des)) then
;    	(throw (new java.lang.Exception (str-cat (implode$ $?des) " expected but "(implode$ $?res) " found" )))
;    )
    (printout t "Subtraction = " $?res crlf "The End" crlf )
)


;(assert (subtraction (top 2 0 0) (bottom 2 5 )))
;(assert (desirable (result _)))
(assert (problem (subgoals)))
;(run)