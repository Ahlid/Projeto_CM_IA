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
	
	
	
	(defun f-avaliacao(tabuleiro tabuleiro-pai n-jogador n-caixas-jogador n-caixas-adrevesario n-arestas)
	
	(cond 
		
		((< (+ n-caixas-jogador n-caixas-adrevesario) (numero-caixas-fechadas tabuleiro) ) 9000   )
	
		(T (let* 
			(tabuleiro-convertido (converter-tabuleiro tabuleiro)
			(tabuleiro-pai-convertido (converter-tabuleiro tabuleiro-pai))
			(resultados-tabuleiro (f-avaliacao-no-no tabuleiro-convertido))
			(resultados-tabuleiro-pai (f-avaliacao-no-no tabuleiro-pai-convertido))
			(LChains-tabuleiro (obter-LChains resultados-tabuleiro))
			(DChains-tabuleiro (obter-DChains resultados-tabuleiro))
			(SChains-tabuleiro (obter-SChains resultados-tabuleiro))
			(LChains-tabuleiro-pai (obter-LChains resultados-tabuleiro-pai))
			(DChains-tabuleiro-pai (obter-DChains resultados-tabuleiro-pai))
			(SChains-tabuleiro-pai (obter-SChains resultados-tabuleiro-pai))
			)
		
		
		
		)
		
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
	
	
	
	(defun obter-LChains(resultados)
		(cond
			((null resultados) nil)
			((> (car resultados) 2) (cons (car resultados) (obter-LChains (rest resultados))))
			(t (obter-LChains (rest resultados)))
		)
	
	
	)

	
	(defun obter-DChains(resultados)
		(cond
			((null resultados) nil)
			((= (car resultados) 2) (cons (car resultados) (obter-DChains (rest resultados))))
			(t (obter-DChains (rest resultados)))
		)
	
	
	)
    
	
	(defun obter-SChains(resultados)
		(cond
			((null resultados) nil)
			((= (car resultados) 1) (cons (car resultados) (obter-SChains (rest resultados))))
			(t (obter-SChains (rest resultados)))
		)
	
	
	)
	
	

	
	
	
	
	
(defun convert-top-bottom(linha)
	"Função que junta as arestar de baixo e cima de cada caixa conforme a linha"
	(cond
		( (null (second linha)) nil )
		( T
			(cons (mapcar 'list (first linha) (second linha))  (convert-top-bottom (rest linha)));; junta e chama a proxima
		)
	)
)

(defun converter-tabuleiro(tabuleiro)
 "função que converte o tabuleiro em caixas"
	(mapcar 'converter-aux (convert-top-bottom (car tabuleiro)) (matriz2d-transposta (convert-top-bottom (car (rest tabuleiro)))) )
)

(defun converter-aux(tops-bottoms lefts-rights)
 "função que junta os tops-bottoms e os left-rights em toda uma caixa"
	(mapcar
		(lambda (x y)
				(list (append (nil-to-zero x) (reverse (nil-to-zero y))) '0)
		)
		tops-bottoms
		lefts-rights
	)
)


(defun nil-to-zero(lista)

(cond
	((null lista) nil)
	((null (car lista)) (cons '0 (nil-to-zero (rest lista))))
	(t (cons (car lista) (nil-to-zero (rest lista))))
)

)

(defun matriz2d-transposta (m)
	"Faz a transposta da matriz m"
	(apply  #'mapcar (cons #'list m)) ; transpões a matriz
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