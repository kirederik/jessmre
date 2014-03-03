(provide br/inf/ufpr/jessmre/procedures/core/misc/add_lr_decr_ans_carry_to_right)

(require br/inf/ufpr/jessmre/procedures/commons/templates)
(require br/inf/ufpr/jessmre/procedures/commons/functions)

(deftemplate size (slot value))

; Initial rule
; IF exists a problem and there is no subgoals
; THEN set the subtract as the new subgoal
(defrule setup-rule
	"Regra que configura a base de fatos"
    ?problem <- (problem (subgoals))
    ?subtract <- (subtraction (top $?top) (bottom $?bottom))
	=>
    (modify ?subtract (result (create$)))
    (assert (size (value (length$ $?top))))
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
    ?size <- (size (value ?val))
	(test (eq (length$ $?ttail) (length$ $?btail)))
	(test (> (length$ $?ttail) 0))
    =>

    (if (neq (+ (length$ $?ttail) 1) ?val) then 
    	(bind ?thead (+ 1 ?thead))
    )
    
    (bind ?thead (- ?thead 1))
    
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
    ?size <- (size (value ?val))    
    =>    
    (if (neq (+ (length$ $?ttail) 1) ?val) then 
    	(bind ?thead (+ 1 ?thead))
    )
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
	=>
    (bind ?resp (+ ?t ?b))
    ;(printout t "Sub less than fired: " ?t " - " ?b " = " ?resp crlf) 
    (modify ?result (result (create$ ?resp $?r)))
    (modify ?problem (subgoals $?goals))
)

(defrule end-rule
	"�ltima regra. Apenas imprime o resultado"
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


(assert (subtraction (top 4 1 1) (bottom 2 1 5)))
(assert (desirable (result 5 2 7)))
(assert (problem (subgoals)))
(run)
