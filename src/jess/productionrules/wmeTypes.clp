(deftemplate MAIN::button 
   "(Implied)" 
   (multislot __data))
(deftemplate MAIN::label 
   "(Implied)" 
   (multislot __data))
(deftemplate MAIN::problem 
   (slot name)
   (multislot tblDec)
   (multislot tblPos)
   (multislot tblBin) 
   (multislot subgoals)
   (slot done) 
   (slot description))
(deftemplate MAIN::textField 
   (slot name) 
   (slot value))
(deftemplate MAIN::preencher-valor-posicao-goal
   (multislot txts)
   (multislot posicao)
   (multislot valor))
(deftemplate MAIN::preencher-tabela-goal
    (multislot decimal)
	(multislot binario)
    (multislot resultado)
    (multislot txtDec)
    (multislot txtPos)
    (multislot txtBin)
    (multislot txtRes)
    (multislot subgoals))
(deftemplate MAIN::preencher-linha-tabela
    (slot decimal)
    (slot binario)
    (slot resultado)
    (slot txtDec)
    (slot txtPos)
    (slot txtBin)
    (slot txtRes))
(deftemplate MAIN::preencher-binario-goal
    (multislot binario))

(deftemplate MAIN::valor-inicial 
    (slot valor-i))

(deftemplate solucao
    (multislot valor))


; tell productionRules file that templates have been parsed
(provide wmeTypes)
