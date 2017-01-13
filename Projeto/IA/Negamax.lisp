

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Negamax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun negamax (no, profundidade, operadores, alfa, beta, peca)
	
	(cond 
		( (= profundidade 0)  (avaliar-folha-limite no peca) )
		( (vencedor-p (no-numero-caixas-jogador1 no) (no-numero-caixas-jogador2 no)) (avaliar-folha no peca))
		( t 
			(let
				(
					( ())
				)
				
			)
			
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