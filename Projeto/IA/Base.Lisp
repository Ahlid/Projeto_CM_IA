;;;;       Programa do apoio ao jogo dos pontos e das caixas
;;;;       Apos ter desenvolvido as funcoes pedidas no enunciado
;;;;       utilize a funcao fazer-uma-partida para jogar.

;;;;
;;;; Constantes:
;;;;
 (defvar *jogador2* 2)
 (defvar *jogador1* 1)


;;;;
;;;; Funcoes auxiliares:
;;; ----------------------------------

(defun tabuleiro-inicial (&optional stream)
  "Permite criar o tabuleiro inicial do jogo."
  (cond ((null stream) '(
    ((NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL)
    (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL)
    (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL)
    (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL))
    ((NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL)
    (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL)
    (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL)
    (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL))
))
        (t (read stream))))

(defun tabuleiro-teste ()
  '(
    ((NIL NIL NIL 2 1 NIL NIL) (NIL NIL NIL NIL 2 1 2)
    (1 2 1 2 2 2 NIL) (2 NIL NIL NIL 1 2 NIL)
    (2 2 NIL NIL 2 1 NIL) (2 2 NIL 1 1 2 NIL)
    (2 2 NIL 2 1 1 NIL) (1 1 NIL 1 2 2 NIL))
    ((NIL NIL NIL 1 1 1 1) (NIL NIL NIL 1 1 1 1)
    (NIL 1 NIL NIL 1 1 2) (NIL 2 1 NIL 1 2 1)
    (1 NIL NIL 1 NIL NIL NIL) (1 NIL NIL 1 1 NIL NIL)
    (NIL NIL 1 1 NIL NIL NIL) (NIL 2 1 2 1 NIL 2))
  )
)

  


(defun vencedor-p (caixas-jogador1 caixas-jogador2)
  "Determina se existe um vencedor. Se existir devolve o jogador que venceu. Senao devolve NIL."
	(cond
		((>= caixas-jogador1 25) *jogador1*)
		((>= caixas-jogador2 25) *jogador2*)
		(T NIL)
	)
)

(defun trocar-peca (peca)
	"Troca a peca de um jogador para a peca de outro jogador."
	(cond
		((= peca *jogador1*) *jogador2*)
		((= peca *jogador2*) *jogador1*)
	)
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Classifica??o do tabuleiro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mapear-bool-binario (lista)
	"Mapeia uma lista de valores booleanos (t e nil) para uma lista de valores binarios (1 0)"
	(mapcar
		(lambda
			(elemento)
			(cond
				((null elemento) 0) ; se o elemento ? nil devolve 0
				(t 1) ; caso contr?rio devolve 1
			)
		)
		lista
	)
)

(defun criar-candidatos-aux (matriz)
	"Remove a ?ltima coluna da matriz"
	(mapcar ; passa por cada lista da matriz
		(lambda
			(linha)
			(reverse (rest (reverse linha))) ; retira o ?ltimo elemento da lista
		)
		matriz
	)
)

(defun alisa (lista)
	"Retorna a lista com todos os elementos contidos na lista principal"
	(cond
		( (null lista) nil )
		( t (append (first lista) (alisa (rest lista))) )
	)
)

(defun criar-candidatos (matriz)
	"Cria uma matriz com os candidatos tendo em conta que arcos paralelos na mesma caixa s?o considerados candidatos"
	(criar-candidatos-aux
		(mapcar
			(lambda
				(linha)
				(maplist
					(lambda
						(lista)
						(cond
							( (< (length lista) 2) nil ) ; se exitirem menos de 2 elementos em paralelo n?o pode existir um candidato
							( t (and (first lista) (second lista)) ) ; se existirem ambos os arcos paralelos e consecutivos devolve t, caso contr?rio nil
						)
					)
					linha
				)
			)
			(matriz2d-transposta matriz) ; tranposta da matriz para que se consiga ter as linhas da matriz com os arcos paralelos
		)
	)
)



(defun numero-caixas-fechadas (tabuleiro)
	"Devolve o n?mero fechadas num tabuleiro"
	(let
		(
			(candidatos1 (alisa (criar-candidatos (get-arcos-horizontais tabuleiro)))) ; gera os candidatos dos arcos horizontais num lista linear
			(candidatos2 (alisa (matriz2d-transposta (criar-candidatos (get-arcos-verticais tabuleiro))))) ; gera os candidatos dos arcos verticais numa lista linear
		)
		(apply  '+ 	(mapear-bool-binario ; mapeia a lista para elementos bin?rios e somas os seus valores
						(mapcar
							(lambda (&rest lista)
									(and (first lista) (second lista)); aplica um and entre o candidato dos horizontais e o candidato dos verticais, caso ambos sejam t existe de facto um quadrado
							)
							candidatos1
							candidatos2
						)
					)
		)
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Impress?o do tabuleiro
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




