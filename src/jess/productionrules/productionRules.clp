
(require* wmeTypes "wmeTypes.clp")


(deffunction converte-bin (?d ?p)
    (return (* (** 2 ?p) ?d)))

(deffunction valor-a-usar(?valorInicial ?valorPosicao)
    (if(> ?valorInicial ?valorPosicao) then
        return 1 
      else
        return 0))

;; regras para cada d�gito bin�rio

(defrule inicio-de-tudo
    ?problem <- (problem 
         		(subgoals))
=>
    (bind ?sub1 (assert (preencher-valor-posicao-goal(posicao 7 6 5 4 3 2 1 0) (txts vp7 vp6 vp5 vp4 vp3 vp2 vp1 vp0))))
    (bind ?sub2 (assert (preencher-tabela-goal)))
    (bind ?sub3 (assert (preencher-binario-goal)))
    (modify ?problem (subgoals ?sub1 ?sub2 ?sub3)))

(defrule calculo-posicao-n
   ?problem <- (problem 
               (subgoals ?sub1 $?))
      
    ?sub1 <- (preencher-valor-posicao-goal(posicao ?p $?outras) (txts ?txtCab $?txtsOutros) (valor $?valores ))
    (test (neq ?txtCab nil))
    (test (> (length$ ?txtsOutros) 0)) 
 =>
    (bind ?vp (integer(converte-bin 1 ?p)))
    (bind ?lista-valores (create$ ?valores ?vp))
    (modify ?sub1 (posicao ?outras) (txts ?txtsOutros) (valor ?lista-valores)))

(defrule calculo-posicao-final
   ?problem <- (problem 
               (subgoals ?sub1 ?sub2 ?sub3))
      
    ?sub1 <- (preencher-valor-posicao-goal(posicao ?p $?outras) (txts ?txtCab $?txtsOutros) (valor $?valores ))
    (test (neq ?txtCab nil))
    (test (eq (length$ ?txtsOutros) 0)) 
 =>
    (bind ?vp (integer(converte-bin 1 ?p)))
    (bind ?lista-valores (create$ ?valores ?vp))
    (modify ?sub2 (txtDec vi r6 r5 r4 r3 r2 r1 r0) (txtPos vps7 vps6 vps5 vps4 vps3 vps2 vps1 vps0) (txtBin vpb7 vpb6 vpb5 vpb4 vpb3 vpb2 vpb1 vpb0) (txtRes vf7 vf6 vf5 vf4 vf3 vf2 vf1 vf0))
    (modify ?problem (subgoals ?sub2 ?sub3) (tblDec ?lista-valores)))

(defrule preenchimento-tabela
    ?problem <- (problem (subgoals ?sub2 $?))
    ?sub2 <- (preencher-tabela-goal (subgoals))
    =>
     (bind ?subTabela (assert (preencher-linha-tabela)))
     (modify ?sub2 (subgoals ?subTabela))
    )

(defrule preenchimento-tabela-n
    ?problem <- (problem (subgoals ?sub2 $?) )
    ?sub2 <- (preencher-tabela-goal (txtDec ?txtD $?txtDs) (txtPos ?txtP $?txtPs) (txtBin ?txtB $?txtBs) (txtRes ?txtR $?txtRs) (subgoals ?subTabela))
    ?subTabela <- (preencher-linha-tabela)
    ;(test (>= (length$ ?txtDs) 0))
    =>
     (modify ?subTabela (txtDec ?txtD) (txtPos ?txtP) (txtBin ?txtB) (txtRes ?txtR)))

(defrule preenchimento-tabela-final
    ?problem <- (problem (subgoals ?sub2 ?sub3) )
    ?sub2 <- (preencher-tabela-goal (txtDec $?txtDs) (txtPos $?txtPs) (txtBin $?txtBs) (txtRes $?txtRs) (subgoals ?subTabela))
    ?subTabela <- (preencher-linha-tabela)
    (test (eq (length$ ?txtDs) 0))
    =>
     (modify ?sub2 (txtDec ?txtD) (txtPos ?txtP) (txtBin ?txtB) (txtRes ?txtR) (subgoals)))

(defrule preenche-linha-r
    ?problem <- (problem (subgoals ?sub2 $?) (tblDec ?vpD $?vpDs))
    (valor-inicial (valor-i ?vi))
    ?sub2 <- (preencher-tabela-goal (txtDec ?txtD $?txtDs) (txtPos ?txtP $?txtPs) (txtBin ?txtB $?txtBs) (txtRes ?txtR $?txtRs) (subgoals ?subTabela))
    ?subTabela <- (preencher-linha-tabela (txtDec ?txtD) (txtPos ?txtP) (txtBin ?txtB) (txtRes ?txtR))
    =>
     (construct-message "Qual � o valor a ser convertido?")
     (predict ?txtD UpdateTextField ?vi)
     (construct-message "Qual � o valor da posi��o em decimal que voc� est� tratando?")
     (predict ?txtP UpdateTextField ?vpD)
	 (construct-message "Ser� que esta posi��o deve ser usada ou n�o?")
     (bind ?valorausar valor-a-usar(?vi ?vpD))
     (predict ?txtB UpdateTextField ?valorausar)
     (construct-message ["Acho que sua conta est� errada. Tente novamente."] 
        ["Quanto � " ?vi " - " ?vpD " x " ?valorausar "?"])
     (modify ?problem (tblDec ?vpDs))
     (modify ?sub2 (txtDec ?txtDs) (txtPos ?txtPs) (txtBin ?txtBs) (txtRes ?txtR)))

(defrule helpme
	?problem <- (problem 
        		(subgoals ?sub3)
        		(tblBin $?res))
    ?sub3 <- (preencher-binario-goal)
    (test (< (length$ ?res) 8))
    
=>  
    (predict hint ButtonPressed -1)
    (construct-message 
        ["O exerc�cio n�o foi resolvido ainda. Preencha o valor bin�rio. Voc� est� quase l�."]
        ["Agora � s� transcrever da coluna do meio, lembra????"] ))