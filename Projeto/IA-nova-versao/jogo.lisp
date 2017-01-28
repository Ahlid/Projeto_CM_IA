
(in-package :dots-boxes)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Impressão do tabuleiro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(imprime-tabuleiro (no-estado (teste-preencher 7 7 *jogador2*)))
(defun imprime-tabuleiro (tabuleiro)
	"Imprime um tabuleiro escolhido pelo utilizador"
	(desenhar-tabuleiro tabuleiro *standard-output*)
)

(defun criar-linha-horizontal (lista)
	"Imprime uma linha de valores booleanos como um linha de tra?os horizontais"
	(cond 
		((null lista) "o")
		(t 	(concatenate 'string 
							(cond 
								((null (first lista)) "o   ")
								((=(first lista) *jogador1*) "o---") ; se o elemento ? t devolve a linha		
								((=(first lista) *jogador2*) "o...") ; se o elemento ? t devolve a linha										
								(t "o   ") ; sen?o devolve espa?o em branco		
							) 
							(criar-linha-horizontal (rest lista)) ; chama recusivamente a fun??o com o rest da lista
			)
		)
	)
)

(defun criar-linha-vertical (lista)
	"Imprime uma linha de valores booleanos como um linha de tra?os verticais"
	(cond 
		( (null lista) "" ) ; se n?o houver elementos na lista devolve uma string vazia
		( t 
			(concatenate 'string 	
							(cond 
								((null (first lista)) "    ")
								((and (=(first lista) *jogador1*) (> (length lista) 1)) "|   ") ; se o elemento ? t  e n?o ? o ultimo elemento da lista	devolve a linha com espa?os
								((and (=(first lista) *jogador1*) (<= (length lista) 1)) "|") ; se o elemento ? t  e ? o ultimo elemento da lista devolve a linha
								((and (=(first lista) *jogador2*) (> (length lista) 1)) ":   ") ; se o elemento ? t  e n?o ? o ultimo elemento da lista	devolve a linha com espa?os
								((and (=(first lista) *jogador2*) (<= (length lista) 1)) ":") ; se o elemento ? t  e ? o ultimo elemento da lista devolve a linha
								(t "    ") ; sen?o imprime espa?os em branco
							) 
							(criar-linha-vertical (rest lista)) ; chama recusivamente a fun??o com o rest da lista
			) 
		)
	)
)

(defun desenhar-tabuleiro-aux (matriz1 matriz2 stream)
	"Ajuda a desenhar o tabuleiro recebendo duas listas"
	(cond 
		((and (null matriz1) (null matriz2)) nil) ; quando as duas listas estiverem vazias retorna nil
		(t
			(progn
				(cond 
					((> (length (first matriz1)) 0) ; se j? n?o existir elementos da matriz1 n?o escreve mais linhas horizontais
						(write-line (criar-linha-horizontal (first matriz1)) stream) ; se existe uma linha horizontal escreve-a no stream
					)
				)
				(cond 
					((> (length (first matriz2)) 0) ; se j? n?o existir elementos da matriz2 n?o escreve mais linhas verticais
						(write-line (criar-linha-vertical (first matriz2)) stream) ; se existe uma linha vertical escreve-a no stream
					)
				)
				(desenhar-tabuleiro-aux (rest matriz1) (rest matriz2) stream) ; faz a chamada recursiva com o rest das listas
			)
		)
	)
)	


(defun desenhar-tabuleiro (tabuleiro stream)
	"Desenha o tabuleiro"
	(desenhar-tabuleiro-aux ; Desenha o tabuleiro no stream
		(get-arcos-horizontais tabuleiro) ; Matriz dos arcos horizontais
		(matriz2d-transposta (get-arcos-verticais tabuleiro)) ; Transp?e a matriz dos arcos verticais de forma a termos uma lista de linhas linhas
		stream ; stream de escrita
	)
)


