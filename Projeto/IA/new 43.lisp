
  
  (let ((tabuleiro '()) )
    
        
        (defun teste(x y)
		
	
		
		
          
          (let ((quadrado (obter-quadrado tabuleiro x y))) ;;aqui vou obter o quadrado na posicao x e y
            
            (cond 
             ((and (is-quadrado-aberto quadrado) (= 2 (n-arestas-por-preencher-quadrado quadrado))) ;;se o quadrado esta aberto e tem apenas 2 arestas por completas
              (let ((tabuleiro-atualizado (setf tabuleiro (fechar-quadrado tabuleiro x y)))) ;;fechamos o quadrado
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
              
              )
             
             (T 0)
             
             )
			
            )
          
          )


      
      
	(defun f-avaliacao(tabuleiro tabuleiro-pai n-jogador n-caixas-jogador n-caixas-adrevesario n-arestas)
	
	(cond 
		
		((< (+ n-caixas-jogador n-caixas-adrevesario) (numero-caixas-fechadas tabuleiro) ) 9000 )
	
		(T (let* 
			(tabuleiro-convertido (converter-tabuleiro tabuleiro);;tabuleiro convertido para calcular as correntes
			(tabuleiro-pai-convertido (converter-tabuleiro tabuleiro-pai)) ;;tabuleiro pai convertido para calcular as correntes
			(resultados-tabuleiro  (sort (f-avaliacao-no-no tabuleiro-convertido)) #'>) ;;resultados das correntes do tabuleiro
			(resultados-tabuleiro-pai (sort (f-avaliacao-no-no tabuleiro-pai-convertido))#'>) ;;resultados das correntes do tabuleiro-pai
			(LChains-tabuleiro (obter-LChains resultados-tabuleiro)) ; Lista correntes grandes do tabuleiro
			(DChains-tabuleiro (obter-DChains resultados-tabuleiro)) ; Lista correntes de tamanho 2 do tabuleiro
			(SChains-tabuleiro (obter-SChains resultados-tabuleiro)) ; Lista de uma caixa com 2 arestas por completar do tabuleiro
			(LChains-tabuleiro-pai (obter-LChains resultados-tabuleiro-pai)) ; Lista correntes grandes do tabuleiro-pai
			(DChains-tabuleiro-pai (obter-DChains resultados-tabuleiro-pai)) ;Lista correntes de tamanho 2 do tabuleiro-pai
			(SChains-tabuleiro-pai (obter-SChains resultados-tabuleiro-pai)) ; Lista de uma caixa com 2 arestas por completar do tabuleiro-pai
			(n-LChains-tabuleiro (length LChains-tabuleiro)) ;numero correntes grandes do tabuleiro
			(n-DChains-tabuleiro (length DChains-tabuleiro)) ;numero correntes de tamanho 2 do tabuleiro
			(n-SChains-tabuleiro (length SChains-tabuleiro)) ;numero de caixas com 2 arestas por completar do tabuleiro
			(n-LChains-tabuleiro-pai (length LChains-tabuleiro-pai))  ;numero correntes grandes do tabuleiro-pai
			(n-DChains-tabuleiro-pai (length DChains-tabuleiro-pai))  ;numero correntes de tamanho 2 do tabuleiro-pai
			(n-SChains-tabuleiro-pai (length SChains-tabuleiro-pai))  ;numero de caixas com 2 arestas por completar do tabuleiro-pai 
			
			
			)
		
		
			(cond 
				((= 1 n-jogador ) ;somos os primeiros a jogar
					(cond 
						((= 0 (mod n-LChains-tabuleiro 2));;o primeiro jogador para ganhar deve procurar um número par de LChains
							(- (+ (- n-caixas-jogador n-caixas-adrevesario) (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) ) (1- (length LChains-tabuleiro)))
						)
						
						
						(T ;;quando nao tem um numero par de LChains ou seja está numa má situação
							(+ (- (- n-caixas-jogador n-caixas-adrevesario) (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) ) (1- (length LChains-tabuleiro)))
							
						)
					
					)
				
				)
				(T ;somos os segundos a jogar
				
						
						(cond 
						((= 0 (mod n-LChains-tabuleiro 2));;o segundo jogador para ganhar deve procurar um número impar de LChains
								(+ (- (- n-caixas-jogador n-caixas-adrevesario) (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) ) (1- (length LChains-tabuleiro)))
							
						)
						
						
						(T ;;quando nao tem um numero par de LChains ou seja está numa má situação
							(- (+ (- n-caixas-jogador n-caixas-adrevesario) (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) ) (1- (length LChains-tabuleiro)))
							
						)
					
					)
				
				
				)
			
			)
		
		)
		
		)
		)
	
	
	
	)

	)
	
    
