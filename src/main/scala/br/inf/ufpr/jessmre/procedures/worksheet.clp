(deftemplate temp (multislot value) (multislot column))

(assert (temp (value 1) (column 8)))

(deffunction hasBor(?currentValue ?column)
	(bind ?t (temp (value ?v) (column ?column)))
    (return (eq ?v ?curentValue))    
)

(facts)