(provide br/inf/ufpr/jessmre/procedures/core/missingsubprocedure/noborrowfromzero/borrow_across_zero)
(require br/inf/ufpr/jessmre/procedures/commons/templates)
(require br/inf/ufpr/jessmre/procedures/commons/functions)

;; Reinterprets the location of the decrement as the neares nonzero digit in the top row

; Caso tenha que decrementar 0, passa pra coluna ao lado, até que se encontre uma coluna diferente de 0.
; Alteração na regra decr-borrow.
; Empilha objetivo de decrementar a coluna a esquerda.

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
    "Regra inicial da subtração"
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
    "Regra inicial da subtração, mesmo número de colunas, sem adjacentes"
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
    "Regra inicial da subtração, top com maior número de colunas"
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
    "Não há mais elementos para subtrair"
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
    "Regra para efetuar a subtração de uma coluna -- Sem empréstimo"
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
    "Regra para efetuar a subtração de uma coluna -- Sem empréstimo"
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
	"Regra para efetuar empréstimo"
    ?problem <- (problem (subgoals ?borrowGoal $?goals))
    ?borrowGoal <- (borrow-goal (incr ?column))
    ?subGoal <- (sub1col-goal (top ?t) (bottom ?b) (order ?column))
    =>
    ;(printout t "We have a " ?t " at column " ?column " that will borrow from " ?toBorrow " at column " (+ ?column 1) crlf)    
    (modify ?subGoal (top (+ ?t 10)))
    (bind ?decrGoal (assert (decr-goal (column (+ ?column 1)))))
    (modify ?problem (subgoals ?decrGoal $?goals))
)


(defrule decr
    "Regra para efetuar o decremento -- Sem empréstimo"
    ?problem <- (problem (subgoals ?decrGoal $?goals))
    ?decrGoal <- (decr-goal (column ?column))
    ?subGoal <- (sub1col-goal (top ?t) (order ?column))
	(test (> ?t 0))
    =>
    (modify ?subGoal (top (- ?t 1)))
    (modify ?problem (subgoals $?goals))
)


(defrule decr-borrow
    "Regra para efetuar o decremento -- Com empréstimo"
    ?problem <- (problem (subgoals ?decrGoal $?goals))
    ?decrGoal <- (decr-goal (column ?column))
    ?subGoal <- (sub1col-goal (top ?t) (order ?column))
	(test (eq ?t 0))
    =>
    (bind ?decr (assert (decr-goal (column ( + ?column 1 )))))
    (modify ?problem (subgoals ?decr $?goals))
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


(assert (subtraction (top 3 0 5) (bottom 7)))
(assert (desirable (result 2 0 8)))
(assert (problem (subgoals)))
(run)


