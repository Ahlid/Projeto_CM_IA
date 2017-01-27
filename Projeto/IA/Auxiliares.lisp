;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Funções auxiliares
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun substituir (i valor l)
	"Substitui um elemento de uma lista correpondente ao índice i pelo valor"
	(cond
		( (null l) nil ) ; se a lista está vazia devolve nil
		( (= i 0) (cons valor (rest l)) ) ;se o indice é igual 0, mete o valor atrás da lista
		( t (cons (first l) (substituir (1- i) valor (rest l))) ) ; chama a função com o rest da lista e com o indice decrementado e nao receber o valor junta no ínicio o primeiro elemento da lista
	)
)

(defun elemento-por-indice (i l)
	"Devolve o elemento de uma lista correspondente ao índice i"
	(cond
		( (null l) nil ) ; devolve nil se a lista l está vazia
		( (= i 0) (first l) ) ; se i igual a 0 devolve o primeiro elemento da lista
		( t (elemento-por-indice (1- i) (rest l)) ) ; chama a função com o resta da lista e com o indice decrementado
	)
)

(defun matriz2d-transposta (m)
	"Faz a transposta da matriz m"
	(apply  #'mapcar (cons #'list m)) ; transpões a matriz
)

(defun limpar-nils (lista)
	"Remove os nils de uma lista"
	(apply #'append ; remove todos os nils fazendo o append das listas com os elementos
		(mapcar (lambda (e)
						(cond
							((null e) nil) ; caso o elemento seja nil, devolve nil
							(t (list e)) ; caso contrario cria uma lista com o elemento
						)
				) lista
		)
	)
)

(defun n-arestas-preenchidas(tabuleiro)
	
		(apply '+ (mapcar 
			 (
			  lambda
					 (x)
			   (apply '+ (mapcar 
						  (lambda 
								  (y) 
							(apply '+ (mapcar 
									   (lambda (z) (cond ((null z) 0) (T 1)))
									   y))
							)
						  x))
			   )
			 tabuleiro))
	
	
	)




