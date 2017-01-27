
;;HASH TABLES
;;CRIAR HASH
;(defparameter *my-hash* (make-hash-table))
;;CRIAR A CHAVE
;(setf (gethash 'CHAVE *my-hash*) "VALOR")
;;BUSCAR O VALOR DA CHAVE
;(gethash 'CHAVE *my-hash*)


(defparameter *avaliacoes-hash* (make-hash-table))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Negamax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun log-teste(alfa beta novo-maior jogador-atual jogador-max profundidade)
	(progn 
		(cond
			((= jogador-atual jogador-max) (write-line "Corte Alfa"))
			(t (write-line "Corte Beta"))
		)
		(write-line (concatenate 'string "Profundidade: " (write-to-string profundidade)))
	)
)


(defun negamax-max(sucessores profundidade profundidade-maxima operadores alfa beta maior jogador tempo-inicio tempo-maximo)
	"Passa por todos os sucessores devolvendo o valor max dos mesmos"
	(cond
		((null sucessores) alfa) ; 
		(t 
			(let*
				(
					( no (first sucessores) )
					( valor (cond 
								((= (no-jogador no) jogador) ; se o jogador a jogar neste no for o jogador que queremos maximizar
																(negamax 	no  
																		(1+ (no-profundidade no)) 
																		profundidade-maxima 
																		operadores 
																		alfa
																		beta
																		jogador
																		tempo-inicio 
																		tempo-maximo))
								( t (- (negamax no 			 ; se o jogador a jogar neste no for o jogador que queremos minimizar
																		(1+ (no-profundidade no)) 
																		profundidade-maxima 
																		operadores 
																		(- beta)  
																		(- alfa)
																		jogador
																		tempo-inicio 
																		tempo-maximo)))
																				
							)
					)
					( novo-maior (max valor maior) )
					( novo-alfa (max valor alfa) )
				)
				(cond 
					( (>= novo-alfa beta) (progn (log-teste alfa beta novo-maior (no-jogador no) jogador profundidade) novo-maior )) ; situação de corte
					( t (max 	novo-alfa 
								(negamax-max 	(rest sucessores) 
												profundidade 
												profundidade-maxima 
												operadores 
												novo-alfa
												beta
												novo-maior
												jogador
												tempo-inicio 
												tempo-maximo)) )
				)
			)
		)
	)
)



;;IMPORTANTE... para escolher a jogada o melhor é gerar os sucessores e chamar o negamax para cada 1 desses e ver qual o que tem o maior valor.


;(negamax (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1*)) 0 2 (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal) -100 100 *jogador1*)

(defun negamax-simples (no profundidade profundidade-maxima operadores alfa beta jogador tempo-inicio tempo-maximo)
	""
	(cond 
		( (> (- (get-internal-real-time) tempo-inicio) tempo-maximo) (avaliar-folha-limite no) );excedeu o tempo-maximo
		( (>= profundidade profundidade-maxima) (avaliar-folha-limite no) ) ; Devolve uma avaliação do nó
		( (vencedor-p (no-numero-caixas-jogador1 no) (no-numero-caixas-jogador2 no)) (avaliar-folha no) ) ; Devolve o valor do nó
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
								jogador
								tempo-inicio 
								tempo-maximo
				)
			)
		)
	)
)

(defun guarda-na-hashtable (alfa beta valor no profundidade-maxima) 
	(cond 
		((<= valor alfa) (setf (gethash (no-estado no) *avaliacoes-hash*) (list 'LOWERBOUND profundidade-maxima valor)))
		((>= valor beta) (setf (gethash (no-estado no) *avaliacoes-hash*) (list 'UPPERBOUND profundidade-maxima valor)))
		( t (setf (gethash (no-estado no) *avaliacoes-hash*) (list 'EXACT profundidade-maxima valor)) )
	)
)



(defun negamax (no profundidade profundidade-maxima operadores alfa beta jogador tempo-inicio tempo-maximo)
	""
	(let* 
		(
			(valor (gethash (no-estado no) *avaliacoes-hash*))
		)
		(cond
			( (or (null valor) (< (second valor) profundidade-maxima))
			
				(let 
					(
						(resultado (negamax-simples no profundidade profundidade-maxima operadores alfa beta jogador tempo-inicio tempo-maximo))
					)
					(progn
						(guarda-na-hashtable alfa beta resultado no profundidade-maxima)
						resultado)
				)
					
			)
			( (eq 'EXACT (first valor)) (third valor) )
			( (and (eq 'LOWERBOUND (first valor)) (< (max alfa (third valor)) beta) ) 
			

				(let 
					(
						(resultado (negamax-simples no profundidade profundidade-maxima operadores (max alfa (third valor)) beta jogador) tempo-inicio tempo-maximo)
					)
					(progn
						(guarda-na-hashtable alfa beta resultado no profundidade-maxima)
						resultado)
				)	
			
			)
			( (and (eq 'UPPERBOUND (first valor)) (<  alfa (min (third valor) beta)) )
			
				(let 
					(
						(resultado (negamax-simples no profundidade profundidade-maxima operadores alfa (min beta (third valor)) jogador tempo-inicio tempo-maximo) )
					)
					(progn
						(guarda-na-hashtable alfa beta resultado no profundidade-maxima)
						resultado)
				)
				
			)
			(t (third valor))
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
(defun escolher-jogada-aux (sucessores profundidade-maxima operadores tempo-disponivel) 
	""
	(cond 
		((null sucessores) nil)
		(t 
			(let*
				(
					( no (first sucessores) )
					(tempo-inicio (get-internal-real-time))
					( valor  (negamax 	no
										1
										profundidade-maxima
										operadores
										-100
										100
										(no-jogador  no)
										tempo-inicio ; timestamp atual
										(/ tempo-disponivel (length sucessores)) ; tempo limite calculado a partir do length dos sucessores (ou seja o numero de sucessores que faltam)
										)
					)
					(tempo-fim (get-internal-real-time))
					( resultado (escolher-jogada-aux	(rest sucessores)
														profundidade-maxima 
														operadores
														(- tempo-disponivel (- tempo-fim tempo-inicio) )))
										
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


; (imprime-tabuleiro  (no-estado (escolher-jogada (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1*)) 5000)))
(defun escolher-jogada (no tempo-limite)
	(let*
		(
			(operadores (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal))
			(sucessores (sucessores-no no operadores))
			(tempo-inicio (get-internal-real-time))
			(resultado (escolher-jogada-aux sucessores 
						5
						operadores
						tempo-limite ; tempo disponível
						))
			(tempo-fim (get-internal-real-time))
		)
		(progn
			(write-line (write-to-string (- tempo-fim tempo-inicio)))
			(cond	
				((null resultado) (first sucessores))
				(t (second resultado))
			)
		)
		
	)
)






; 01 function negamax(node, depth, α, β, color)
; 02     if depth = 0 or node is a terminal node
; 03         return color * the heuristic value of node

; 04     childNodes := GenerateMoves(node)
; 05     childNodes := OrderMoves(childNodes)
; 06     bestValue := −∞
; 07     foreach child in childNodes
; 08         v := −negamax(child, depth − 1, −β, −α, −color)
; 09         bestValue := max( bestValue, v )
; 10         α := max( α, v )
; 11         if α ≥ β
; 12             break
; 13     return bestValue



; function negamax(node, depth, α, β, color)
    ; alphaOrig := α

    ; // Transposition Table Lookup; node is the lookup key for ttEntry
    ; ttEntry := TranspositionTableLookup( node )
    ; if ttEntry is valid and ttEntry.depth ≥ depth
        ; if ttEntry.Flag = EXACT
            ; return ttEntry.Value
        ; else if ttEntry.Flag = LOWERBOUND
            ; α := max( α, ttEntry.Value)
        ; else if ttEntry.Flag = UPPERBOUND
            ; β := min( β, ttEntry.Value)
        ; endif
        ; if α ≥ β
            ; return ttEntry.Value
    ; endif

    ; if depth = 0 or node is a terminal node
        ; return color * the heuristic value of node

    ; bestValue := -∞
    ; childNodes := GenerateMoves(node)
    ; childNodes := OrderMoves(childNodes)
    ; foreach child in childNodes
        ; v := -negamax(child, depth - 1, -β, -α, -color)
        ; bestValue := max( bestValue, v )
        ; α := max( α, v )
        ; if α ≥ β
            ; break

    ; // Transposition Table Store; node is the lookup key for ttEntry
    ; ttEntry.Value := bestValue
    ; if bestValue ≤ alphaOrig
        ; ttEntry.Flag := UPPERBOUND
    ; else if bestValue ≥ β
        ; ttEntry.Flag := LOWERBOUND
    ; else
        ; ttEntry.Flag := EXACT
    ; endif
    ; ttEntry.depth := depth 
    ; TranspositionTableStore( node, ttEntry )

    ; return bestValue