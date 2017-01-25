

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Negamax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun log-teste(alfa beta novo-maior )
	(progn 
		(write-line "corte")
		(write-line (write-to-string alfa))
		(write-line (write-to-string beta))
		(write-line (write-to-string novo-maior ))
	)
)


(defun negamax-max(sucessores profundidade profundidade-maxima operadores alfa beta maior)
	""
	(cond 
		((null sucessores) alfa)
		(t 
			(let*
				(
					( no (first sucessores) )
					( valor (cond 
								((= (no-jogador no) *jogador1*) (negamax 	no 
																			(1+ (no-profundidade no)) 
																			profundidade-maxima 
																			operadores 
																			alfa
																			beta))
								((= (no-jogador no) *jogador2*) (- (negamax no 
																			(1+ (no-profundidade no)) 
																			profundidade-maxima 
																			operadores 
																			(- beta)  
																			(- alfa))))
																				
							)
					)
					( novo-maior (max valor maior) )
					( novo-alfa (max valor alfa) )
				)
				(cond 
					( (>= novo-alfa beta) (progn (log-teste alfa beta novo-maior) novo-maior )) ; situação de corte
					( t (max 	novo-alfa 
								(negamax-max 	(rest sucessores) 
												profundidade 
												profundidade-maxima 
												operadores 
												novo-alfa
												beta
												novo-maior)) )
				)
			)
		)
	)
)



;;IMPORTANTE... para escolher a jogada o melhor é gerar os sucessores e chamar o negamax para cada 1 desses e ver qual o que tem o maior valor.


;(negamax (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1*)) 0 2 (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal) -100 100)
(defun negamax (no profundidade profundidade-maxima operadores alfa beta)
	
	(cond 
		( (>= profundidade profundidade-maxima) (avaliar-folha-limite no) ) ;Devolve uma avaliação do nó
		( (vencedor-p (no-numero-caixas-jogador1 no) (no-numero-caixas-jogador2 no)) (avaliar-folha no)) ; Devolve o valor do nó
		( t 
			(let*
				(
					(sucessores (sucessores-no no operadores))
					;(sucessores-ordenados (ordenar sucessores))
				)
				(negamax-max 	sucessores 
								profundidade 
								profundidade-maxima 
								operadores 
								alfa 
								beta
								-100
				)
			)
		)
	)
)



; (let*
		; (
			; (no (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1*)))
			; (operadores (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal))
			; (sucessores (sucessores-no no operadores))
			; (resultado (escolher-jogada-aux sucessores 
						; 3
						; operadores 
						; )
			; )
		; )
		; resultado
; )


;; JUSTIFICAÇÂO: Aqui temos que aplicar o alfa beta em cada nó pois o alfa beta só garante o valor certo no topo da árvore 
(defun escolher-jogada-aux (sucessores profundidade-maxima operadores) 
	""
	(cond 
		((null sucessores) nil)
		(t 
			(let*
				(
					( no (first sucessores) )
					( valor  (negamax 	no
										1
										profundidade-maxima
										operadores
										-100
										100)
					)
					( resultado (escolher-jogada-aux	(rest sucessores)
														profundidade-maxima 
														operadores))
										
				)
				(cond 
					( (null resultado) (list valor no) )
					( (> valor (first resultado)) (list valor no) )
					( t resultado )
				)
			)
		)
	)
)




; (escolher-jogada (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1*)))
(defun escolher-jogada (no)
	(let*
		(
			(operadores (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal))
			(sucessores (sucessores-no no operadores))
			(resultado (escolher-jogada-aux sucessores 
						3
						operadores 
						))
		)
		(cond	
			((null resultado) (first sucessores))
			(t (second resultado))
		)
	)
)






01 function negamax(node, depth, α, β, color)
02     if depth = 0 or node is a terminal node
03         return color * the heuristic value of node

04     childNodes := GenerateMoves(node)
05     childNodes := OrderMoves(childNodes)
06     bestValue := −∞
07     foreach child in childNodes
08         v := −negamax(child, depth − 1, −β, −α, −color)
09         bestValue := max( bestValue, v )
10         α := max( α, v )
11         if α ≥ β
12             break
13     return bestValue



function negamax(node, depth, α, β, color)
    alphaOrig := α

    // Transposition Table Lookup; node is the lookup key for ttEntry
    ttEntry := TranspositionTableLookup( node )
    if ttEntry is valid and ttEntry.depth ≥ depth
        if ttEntry.Flag = EXACT
            return ttEntry.Value
        else if ttEntry.Flag = LOWERBOUND
            α := max( α, ttEntry.Value)
        else if ttEntry.Flag = UPPERBOUND
            β := min( β, ttEntry.Value)
        endif
        if α ≥ β
            return ttEntry.Value
    endif

    if depth = 0 or node is a terminal node
        return color * the heuristic value of node

    bestValue := -∞
    childNodes := GenerateMoves(node)
    childNodes := OrderMoves(childNodes)
    foreach child in childNodes
        v := -negamax(child, depth - 1, -β, -α, -color)
        bestValue := max( bestValue, v )
        α := max( α, v )
        if α ≥ β
            break

    // Transposition Table Store; node is the lookup key for ttEntry
    ttEntry.Value := bestValue
    if bestValue ≤ alphaOrig
        ttEntry.Flag := UPPERBOUND
    else if bestValue ≥ β
        ttEntry.Flag := LOWERBOUND
    else
        ttEntry.Flag := EXACT
    endif
    ttEntry.depth := depth 
    TranspositionTableStore( node, ttEntry )

    return bestValue