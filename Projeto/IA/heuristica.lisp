(defun get-squares-example()

'(
( ( (0 1 2 0) 0) ( (0 0 1 2) 0 ) ( (0 0 1 1) 0) ( (0 2 0 1) 0) ( (0 1 2 0) 0) ( (0 0 0 2) 0) ( (0 0 0 0) 0))
( ( (1 2 0 0) 0) ( (0 0 2 0) 0 ) ( (0 0 2 2) 0) ( (2 0 0 2) 0) ( (1 0 0 0) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0))
( ( (2 1 0 0) 0) ( (0 0 2 0) 0 ) ( (0 0 1 2) 0) ( (0 0 0 1) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0))
( ( (1 0 0 0) 0) ( (0 0 1 0) 0 ) ( (0 0 2 1) 0) ( (0 0 0 2) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0))
( ( (0 0 0 0) 0) ( (0 0 2 0) 0 ) ( (0 0 1 2) 0) ( (0 0 0 1) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0))
( ( (0 0 0 0) 0) ( (0 0 1 0) 0 ) ( (0 0 2 1) 0) ( (0 0 0 2) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0))
( ( (0 0 0 0) 0) ( (0 0 2 0) 0 ) ( (0 0 1 2) 0) ( (0 0 0 1) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0) ( (0 0 0 0) 0))
)

)



(defun obter-quadrado(tabuleiro x y)
  (cond
   ((and
     (and (>= x 0) (>= y 0) )
     (and
      (< x (length tabuleiro))
      (< y (length (nth 0 tabuleiro)))))
    (nth y (nth x tabuleiro)))
   (T nil)
   )

  )


(defun meter-quadrado-como-fechado(quadrado)

(list (car quadrado) '1)
)

(defun fechar-quadrado(tabuleiro x y)

	(cond
		( (= 0 x ) (cons (substituir y (meter-quadrado-como-fechado (nth y (car tabuleiro))) (car tabuleiro)) (rest tabuleiro)) )
		(T (cons (car tabuleiro) (fechar-quadrado (rest tabuleiro) (- x 1) y) ))
	)

)


(defun substituir (i valor l)
	"Substitui um elemento de uma lista correpondente ao índice i pelo valor"
	(cond
		( (null l) nil ) ; se a lista está vazia devolve nil
		( (= i 0) (cons valor (rest l)) ) ;se o indice é igual 0, mete o valor atrás da lista
		( t (cons (first l) (substituir (1- i) valor (rest l))) ) ; chama a função com o rest da lista e com o indice decrementado e nao receber o valor junta no ínicio o primeiro elemento da lista
	)
)



(defun contar(tabuleiro &optional (x 0) &optional (y 0) )





)

(defun is-quadrado-aberto(quadrado)
(cond
((null quadrado) nil)
( T (= 0 (cadr quadrado)))

)
)

(defun n-arestas-por-preencher-quadrado (quadrado)

(apply '+ (mapcar (lambda (x) (cond ((= 0 x) 1) (t 0))) (car quadrado)))

)










  (let ((tabuleiro '()) )


        (defun teste(x y)

          (let ((quadrado (obter-quadrado tabuleiro x y))) ;;aqui vou obter o quadrado na posicao x e y
            (cond
             ((is-quadrado-aberto quadrado) ;;se o quadrado esta aberto e tem apenas 2 arestas por completas
              (let ((tabuleiro-atualizado (setf tabuleiro (fechar-quadrado tabuleiro x y)))) ;;fechamos o quadrado
                (cond
				((= 2 (n-arestas-por-preencher-quadrado quadrado))

				(cond
                 ((and ;;primeira condicao topo-direita
                       (= 0 (first(first quadrado ))) ;;se nao tem no topo
                       (= 0 (third(first quadrado ))) ;;se nao tem na direita ou seja se a aresta que falte é em cima e a direita ele faz isto
                       )
                  (+ 1 (teste (- x 1) y ) (teste x (+ y 1)))) ;;vai somar
                 ;;

                 ((and ;;segunda condicao topo-baixo
                       (= 0 (first(first quadrado ))) ;;se nao tem no topo
                       (= 0 (second(first quadrado ))) ;;se nao tem na baixo
                       )
                  (+ 1 (teste (- x 1) y ) (teste (+ 1 x) y))) ;;vai somar

                 ;;

                 ((and ;;primeira condicao topo-esquerda
                       (= 0 (first(first quadrado ))) ;;se nao tem no topo
                       (= 0 (fourth(first quadrado ))) ;;se nao tem na esquerda
                       )
                  (+ 1 (teste (- x 1) y ) (teste x (- y 1)))) ;;vai somar

                 ((and ;;primeira condicao baixo-direita
                       (= 0 (second(first quadrado ))) ;;se nao tem no baixo
                       (= 0 (third(first quadrado ))) ;;se nao tem na direita
                       )
                  (+ 1 (teste (+ x 1) y ) (teste x (+ y 1)))) ;;vai somar

                 ((and ;;primeira condicao baixo-esquerda
                       (= 0 (second(first quadrado ))) ;;se nao tem no baixo
                       (= 0 (fourth(first quadrado ))) ;;se nao tem na esquerda
                       )
                  (+ 1 (teste (+ x 1) y ) (teste x (- y 1)))) ;;vai somar


                 ((and ;;primeira condicao baixo-esquerda
                       (= 0 (third(first quadrado ))) ;;se nao tem no direita
                       (= 0 (fourth(first quadrado ))) ;;se nao tem na esquerda
                       )
                  (+ 1 (teste x (+ y 1) ) (teste x (- y 1)))) ;; vai somar

                 (T 0)

                 )

				)

				(T 0)
				)

                )

              )

             (T 0)

             )

            )

          )






	(defun f-avaliacao-no-no(tabuleiro-inicial)
			(progn
			(setf tabuleiro tabuleiro-inicial)
			(limpa-zeros (init (- (length tabuleiro) 1) (- (length (first tabuleiro)) 1) (- (length (first tabuleiro)) 1) )))
			)


			(defun init(x y z)

			(cond
			((= -1 x) nil )
			((= 0 y) (cons (teste x y) (init (- x 1) z z)))
			(t (cons (teste x y) (init x (- y 1) z )))
			)
			)


			(defun limpa-zeros (lista)

			(cond
				((null lista) nil)
				((= 0 (car lista)) (limpa-zeros (rest lista)))
				(t (cons (car lista) (limpa-zeros (rest lista))))
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

    
