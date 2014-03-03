(deftemplate subtraction "Subtração" (multislot top) (multislot bottom) (multislot result))

;; Goals

(deftemplate subtract-goal (multislot top) (multislot bottom))
(deftemplate sub1col-goal (slot top) (slot bottom) (slot result) (slot order))
(deftemplate end-goal (multislot result))
(deftemplate borrow-goal (multislot incr))
(deftemplate decr-goal (slot column))
(deftemplate problem (multislot subgoals))
(deftemplate adjacent (slot adj) (slot n) (slot adjbot) (slot column))

;; For tests purpose
(deftemplate desirable (multislot result))

(provide br/inf/ufpr/jessmre/procedures/commons/templates)
