(provide br/inf/ufpr/jessmre/procedures/core/misc/sub_copy_least_bottom_most_top)

(require br/inf/ufpr/jessmre/procedures/commons/templates)
(require br/inf/ufpr/jessmre/procedures/commons/functions)

(deftemplate subtract-head-goal (multislot top) (multislot bottom))
(deftemplate subtract-bottom-goal (multislot bottom))
; Initial rule
; IF exists a problem and there is no subgoals
; THEN set the subtract as the new subgoal
(defrule setup-rule
	"Regra que configura a base de fatos"
    ?problem <- (problem (subgoals))
    ?subtract <- (subtraction (top $?top) (bottom $?bottom))
	=>
    (modify ?subtract (result (create$)))
    (bind ?subGoal (assert (subtract-head-goal (top $?top) (bottom $?bottom))))
    (bind ?endGoal end-goal)
    (modify ?problem (subgoals ?subGoal ?endGoal))
)

(defrule head
    ?problem <- (problem (subgoals ?subHead $?goals))
 	?subHead <- (subtract-head-goal (top ?thead $?ttail) (bottom ?bhead $?btail))
    ?result <- (subtraction (result $?r)) 
    =>
    (modify ?result (result (create$ $?r ?thead)))
    (if (eq (length$ $?btail) (length$ $?ttail)) then
        (bind ?subBot (assert (subtract-bottom-goal (bottom $?btail))))
        (modify ?problem (subgoals ?subBot $?goals))
    else 
        (modify ?subHead (top $?ttail))
    )
)

(defrule bottom
    ?problem <- (problem (subgoals ?subBot $?goals))
 	?subBot <- (subtract-bottom-goal (bottom ?bhead $?btail))
    ?result <- (subtraction (result $?r)) 
    =>
    (modify ?result (result (create$ $?r ?bhead)))
    (bind ?subBot (assert (subtract-bottom-goal (bottom $?btail))))
    (modify ?problem (subgoals ?subBot $?goals))
)

(defrule subtract-no-more-elements
    "Não há mais elementos para subtrair"
    ?problem <- (problem (subgoals ?subBot $?goals))
 	?subBot <- (subtract-bottom-goal (bottom $?btail))
    (test (eq (length$ $?btail) 0))
    =>
	(modify ?problem (subgoals $?goals))
)

(defrule end-rule
	"Última regra. Apenas imprime o resultado"
    ?problem <- (problem (subgoals ?endGoal $?rest))
    (test (eq ?endGoal end-goal))
    ?r <- (subtraction (result $?res))
    ?d <- (desirable (result $?des))
	=>
    ; (facts)
    (if (neq (implode$ $?res) (implode$ $?des)) then
    	(throw (new java.lang.Exception (str-cat (implode$ $?des) " expected but "(implode$ $?res) " found" )))
    )
    (printout t "Subtraction = " $?res crlf "The End" crlf )
)


(assert (subtraction (top 6 4 8) (bottom 2 3 1)))
(assert (desirable (result 6 3 1)))
(assert (problem (subgoals)))
(run)
