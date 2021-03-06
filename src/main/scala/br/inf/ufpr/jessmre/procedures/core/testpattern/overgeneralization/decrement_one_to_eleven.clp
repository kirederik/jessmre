(provide br/inf/ufpr/jessmre/procedures/core/testpattern/overgeneralization/decrement_one_to_eleven)

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
    (modify ?subtract (result (create$)))
    (bind ?subGoal (assert (subtract-goal (top $?top) (bottom $?bottom))))
    (bind ?endGoal end-goal)
    (modify ?problem (subgoals ?subGoal ?endGoal))
)

; Subtract rule
; IF there is a problem 
;    AND current subgoal is subtract-goal
;    AND there is the same number of columns on top and on bottom
;    AND there is more than one adjacent columns
; THEN for each column on the problem
;      set the sub1col-goal to this column
(defrule subtract 
    "Regra inicial da subtra��o"
	?problem <- (problem (subgoals ?subGoal $?endGoal))
    ?subGoal <- (subtract-goal (top ?thead $?ttail) (bottom ?bhead $?btail))
	(test (eq (length$ $?ttail) (length$ $?btail)))
	(test (> (length$ $?ttail) 0))
    =>
    (assert (adjacent (n (first$ $?ttail)) (adj ?thead) (column (- (length$ $?ttail) 1))))
    (bind ?sub1ColGoal (assert (sub1col-goal  (top ?thead) (bottom ?bhead) (order (length$ ?ttail)))))
    (bind ?subNextGoal (assert (subtract-goal (top ?ttail) (bottom ?btail))))
    (bind ?goals (create$ ?sub1ColGoal $?endGoal))
	(modify ?problem (subgoals ?subNextGoal ?goals))
)

; Subtract rule
; IF there is a problem 
;    AND current subgoal is subtract-goal
;    AND there is the same number of columns on top and on bottom
;    AND there is no more adjacent columns
; THEN for each column on the problem
;      set the sub1col-goal to this column
(defrule subtract-no-adjacent
    "Regra inicial da subtra��o, mesmo n�mero de colunas, sem adjacentes"
	?problem <- (problem (subgoals ?subGoal $?endGoal))
    ?subGoal <- (subtract-goal (top ?thead $?ttail) (bottom ?bhead $?btail))
	(test (eq (length$ $?ttail) (length$ $?btail)))
	(test (eq (length$ $?ttail) 0))
    =>
    (bind ?sub1ColGoal (assert (sub1col-goal  (top ?thead) (bottom ?bhead) (order (length$ ?ttail)))))
    (bind ?subNextGoal (assert (subtract-goal (top ?ttail) (bottom ?btail))))
    (bind ?goals (create$ ?sub1ColGoal $?endGoal))
	(modify ?problem (subgoals ?subNextGoal ?goals))
)

; Subtract rule
; IF there is a problem 
;    AND current subgoal is subtract-goal
;    AND there is the more columns on top than on bottom
;    AND there is more than one adjacent columns
; THEN for each column on the problem
;      set the sub1col-goal to this column
(defrule subtract-no-bottom
    "Regra inicial da subtra��o, top com maior n�mero de colunas"
	?problem <- (problem (subgoals ?subGoal $?endGoal))
    ?subGoal <- (subtract-goal (top ?thead $?ttail) (bottom ?bhead $?btail))
	(test (> (length$ $?ttail) (length$ $?btail)))
    =>
    (assert (adjacent (n (first$ $?ttail)) (adj ?thead) (column (- (length$ $?ttail) 1))))
    (bind ?sub1ColGoal (assert (sub1col-goal (top ?thead) (bottom 0) (order (length$ $?ttail)))))
    (bind ?subNextGoal (assert (subtract-goal (top ?ttail) (bottom (create$ ?bhead ?btail)))))
    (bind ?goals (create$ ?sub1ColGoal $?endGoal))
	(modify ?problem (subgoals ?subNextGoal ?goals))
)

; Subtract rule
; IF there is a problem 
;    AND current subgoal is subtract-goal
;    AND there is nothing to subtract from
; THEN remove subtract-goal from stack
(defrule subtract-no-more-elements
    "N�o h� mais elementos para subtrair"
    ?problem <- (problem (subgoals ?subGoal $?endGoal))
    ?subGoal <- (subtract-goal (top $?t) (bottom $?b))
    (test (eq (length$ $?b) 0))
    =>
	(modify ?problem (subgoals $?endGoal))
)

; Sub1Col rule
; IF there is a problem
;    AND current subgoal is sub1col-goal
;    AND top is bigger or equal than bottom (no borrow needed)
; THEN calculate top - bot
;      pop the current subgoal from goals stack
(defrule sub1Col
    "Regra para efetuar a subtra��o de uma coluna -- Sem empr�stimo"
    ?problem <- (problem (subgoals ?subGoal $?goals))
    ?subGoal <- (sub1col-goal (top ?t) (bottom ?b) (order ?order))
    ?result <- (subtraction (result $?r))
    (test (>= ?t ?b))
	=>
    (bind ?resp (do-sub ?t ?b))
    ;(printout t "Sub less than fired: " ?t " - " ?b " = " ?resp crlf) 
    (modify ?result (result (create$ ?resp $?r)))
    (modify ?problem (subgoals $?goals))
)


; Sub1Col rule
; IF there is a problem
;    AND current subgoal is sub1col-goal
;    AND top is less than bottom (need borrow)
; THEN calculate top - bot
;      pop the current subgoal from goals stack
(defrule sub1Col-borrow
    "Regra para efetuar a subtra��o de uma coluna -- Sem empr�stimo"
    ?problem <- (problem (subgoals ?subGoal $?goals))
    ?subGoal <- (sub1col-goal (top ?t) (bottom ?b) (order ?order))
    ?result <- (subtraction (result $?r))
    (test (< ?t ?b))
	=>
    (bind ?borrow (assert (borrow-goal (incr ?order))))
    (modify ?problem (subgoals ?borrow ?subGoal $?goals))
)

; Borrow Rule
; IF there is a problem
;    AND current subgoal is borrow-goal
; THEN increment top by 10
;      decrement adjacent
(defrule borrow
	"Regra para efetuar empr�stimo"
    ?problem <- (problem (subgoals ?borrowGoal $?goals))
    ?borrowGoal <- (borrow-goal (incr ?column))
    ?subGoal <- (sub1col-goal (top ?t) (bottom ?b) (order ?column))
    ?adjacent <- (adjacent (adj ?toBorrow) (column ?column))
    =>
    ;(printout t "We have a " ?t " at column " ?column " that will borrow from " ?toBorrow " at column " (+ ?column 1) crlf)    
    (modify ?subGoal (top (+ ?t 10)))
    (bind ?decrGoal (assert (decr-goal (column (+ ?column 1)))))
    (modify ?problem (subgoals ?decrGoal $?goals))
)


(defrule decr
    "Regra para efetuar o decremento -- Sem empr�stimo"
    ?problem <- (problem (subgoals ?decrGoal $?goals))
    ?decrGoal <- (decr-goal (column ?column))
    ?subGoal <- (sub1col-goal (top ?t) (order ?column))
	(test (> ?t 1))
    =>
    (modify ?subGoal (top (- ?t 1)))
    (modify ?problem (subgoals $?goals))
)

(defrule decr-bug
    "Regra para efetuar o decremento -- Sem empr�stimo"
    ?problem <- (problem (subgoals ?decrGoal $?goals))
    ?decrGoal <- (decr-goal (column ?column))
    ?subGoal <- (sub1col-goal (top ?t) (order ?column))
	(test (eq ?t 1))
    =>
    (modify ?subGoal (top 11))
    (bind ?decrGoal2 (assert (decr-goal (column (+ 1 ?column)))))    
    (modify ?problem (subgoals ?decrGoal2 $?goals))
)


(defrule decr-borrow
    "Regra para efetuar o decremento -- Com empr�stimo"
    ?problem <- (problem (subgoals ?decrGoal $?goals))
    ?decrGoal <- (decr-goal (column ?column))
    ?subGoal <- (sub1col-goal (top ?t) (order ?column))
	(test (eq ?t 0))
    =>
    (bind ?borrow (assert (borrow-goal (incr ?column))))
    (modify ?problem (subgoals ?borrow ?decrGoal $?goals))
)


(defrule end-rule
	"�ltima regra. Apenas imprime o resultado"
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


;(assert (subtraction (top 3 1 4) (bottom 6)))
;(assert (desirable (result 2 11 8)))
(assert (problem (subgoals)))
;(run)