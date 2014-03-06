(deftemplate sum (multislot top) (multislot bottom) (multislot result) (slot carry))
;; Goals
(deftemplate sum-goal (multislot top) (multislot bottom))
(deftemplate sum-column-goal (slot top) (slot bottom) (slot result) (slot order))
(deftemplate end-goal (multislot result))
(deftemplate problem (multislot subgoals))

(deffunction do-sum (?top ?bot ?cin)
	"Do the sum calculation"
	(return  (+ (+ ?top ?bot) ?cin))
)

(deffunction get-carry (?s)
	"Return the carry"
	(return  (div ?s 10))
)

(deffunction get-sum (?s)
	"Return the "
	(return  (mod ?s 10))
)

; Initial rule
; IF exists a problem and there is no subgoals
; THEN set the sum as the new subgoal
(defrule initial-rule
	"Where it begins"
    ?problem <- (problem (subgoals))
    ?sum <- (sum (top $?top) (bottom $?bottom))
	=>
    ;(printout t "Initial rule fired" crlf)
    (modify ?sum (carry 0) (result (create$)))
    (bind ?sumGoal (assert (sum-goal (top $?top) (bottom $?bottom))))
    (bind ?endGoal end-goal)
    (modify ?problem (subgoals ?sumGoal ?endGoal))
)

; Initial Sum rule
; IF exists a problem and there is a sum-goal subgoal
; THEN set the sum-column as a subgoal
;; Desempilha subobjetivo sum-goal
;; Empilha subobjetivo sum-column-goal com 
(defrule sum-goal-rule
    "Initial sum"
    ?problem <- (problem (subgoals ?sumGoal $?endGoal))
    ?sumGoal <- (sum-goal (top ?thead $?ttail) (bottom ?bhead $?btail))
    (test (eq (length$ $?ttail) (length$ $?btail)))
     =>
    (printout t ?bhead)
    (bind ?sumColumnGoal (assert
            (sum-column-goal (top ?thead) (bottom ?bhead) (order (length$ ?ttail)))))
    (bind ?sumNextGoal (assert (sum-goal (top ?ttail) (bottom ?btail))))
    (bind ?goals (create$ ?sumColumnGoal $?endGoal))
	(modify ?problem (subgoals ?sumNextGoal ?goals))
)

; Sum rule
; IF exists a problem and there is a sum-goal subgoal
; THEN set the sum-column as a subgoal
;; Desempilha subobjetivo sum-goal
;; Empilha subobjetivo sum-column-goal com 
(defrule sum-goal-no-bottom
    "Initial sum"
    ?problem <- (problem (subgoals ?sumGoal $?endGoal))
    ?sumGoal <- (sum-goal (top ?thead $?ttail) (bottom ?bhead $?btail))
    (test (> (length$ $?ttail) (length$ $?btail)))
    =>
    (bind ?sumColumnGoal (assert (sum-column-goal (top ?thead) (bottom 0) (order (length$ $?ttail)))))
    (bind ?sumNextGoal (assert (sum-goal (top ?ttail) (bottom (create$ ?bhead ?btail)))))
    (bind ?goals (create$ ?sumColumnGoal $?endGoal))
	(modify ?problem (subgoals ?sumNextGoal ?goals))
)

;; No more elements
(defrule no-more-elements
    "Initial sum"
    ?problem <- (problem (subgoals ?sumGoal $?endGoal))
    ?sumGoal <- (sum-goal (top $?t) (bottom $?b))
    (test (eq (length$ $?b) 0))
    =>
	(modify ?problem (subgoals $?endGoal))
)

; Sum Columns
; IF exists a problem 
;; AND there is a sum-column-goal subgoal
;; AND top + bottom + carry < 10
; THEN set the sum-column as a subgoal
;; ----------------------------------------
;; Desempilha subobjetivo sum-column-goal
;; Executa a soma e dá append do resultado
(defrule sum-column-no-carry
    "Sum a column"
    ?problem <- (problem (subgoals ?sumColumnGoal $?goals))
    ?sumColumnGoal <- (sum-column-goal (top ?t) (bottom ?b))
    ?result <- (sum (result $?r) (carry ?ci))
    (test (< (do-sum ?t ?b ?ci) 10))
	=>
    (bind ?resp (do-sum ?t ?b ?ci))
    (printout t "Sum Column (no carry) fired: " crlf 
       "  " ?t  " + " ?b " + " ?ci " = " ?resp crlf)
    (modify ?result (result (create$ ?resp $?r)) (carry 0))
    (modify ?problem (subgoals $?goals))
)

; Sum Columns
; IF exists a problem 
;; AND there is a sum-column-goal subgoal
;; AND top + bottom + carry > 10
; THEN set the sum-column as a subgoal
;; ----------------------------------------
;; Desempilha subobjetivo sum-column-goal
;; Executa a soma e dá append do resultado
(defrule sum-column-with-carry
    "Sum a column with carry"
    ?problem <- (problem (subgoals ?sumColumnGoal $?goals))
    ?sumColumnGoal <- (sum-column-goal (top ?t) (bottom ?b))
    ?sum <- (sum (result $?r) (carry ?ci))
    (test (> (do-sum ?t ?b ?ci) 9))
	=>
    (bind ?resp (do-sum ?t ?b ?ci))
    (bind ?cout (get-carry ?resp))
    (bind ?resp2 (get-sum ?resp))
    (printout t "Sum Column (carried) fired: " crlf 
       "  " ?t  " + " ?b " + " ?ci " = " ?resp crlf)
    (modify ?sum (result (create$ ?resp2 $?r)) (carry ?cout))
    (modify ?problem (subgoals $?goals))
)

; Sum Carry
; IF exists a problem 
;; AND there is a sum-column-goal subgoal
;; AND top is empty
;; AND still exists a carry
; THEN set the sum-column as a subgoal
;; ----------------------------------------
;; Desempilha subobjetivo sum-column-goal
;; Executa a soma e dá append do resultado
(defrule sum-only-carry
    "Sum a column with carry"
    ?problem <- (problem (subgoals ?endGoal $?rest))
    (test (eq ?endGoal end-goal))
    ?sum <- (sum (result $?r) (carry ?ci))
    (test (> ?ci 0))
	=>
    (printout t "Down the carry: " ?ci crlf)
    (modify ?sum (result (create$ ?ci $?r)) (carry 0))
    (modify ?problem (subgoals ?endGoal $?rest))
)


(defrule end
	"Where it ends"
    ?problem <- (problem (subgoals ?endGoal $?rest))
    (test (eq ?endGoal end-goal))
    ?r <- (sum (result $?res))
	=>
    (printout t "Sum = " $?res crlf "The End" crlf )
    
)

(assert (sum (top 9 9 9) (bottom 1)))
(assert (problem (subgoals)))
(run)
