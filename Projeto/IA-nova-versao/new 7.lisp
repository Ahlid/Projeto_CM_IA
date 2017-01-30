

	  (defun f-avaliacao(tabuleiro tabuleiro-pai n-jogador n-caixas-jogador n-caixas-adrevesario n-arestas)
		"função de devolve a avaliação do tabuleiro (resultado da função de avaliação do tabuleiro)"
		(cond
		 
		 ( (< 20 n-arestas) (- (numero-caixas-fechadas tabuleiro) n-caixas-adrevesario ) );;se tiver menos de 20 arestas
		 (T (let*
				
				(
				 (tabuleiro-convertido (converter-tabuleiro tabuleiro));;tabuleiro convertido para calcular as correntes
				 (tabuleiro-pai-convertido (converter-tabuleiro tabuleiro-pai)) ;;tabuleiro pai convertido para calcular as correntes
				 (resultados-tabuleiro  (sort (f-avaliacao-no-no tabuleiro-convertido) #'>)) ;;resultados das correntes do tabuleiro
				 (resultados-tabuleiro-pai (sort (f-avaliacao-no-no tabuleiro-pai-convertido)#'>)) ;;resultados das correntes do tabuleiro-pai
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
				 (n-quadrados-onde-falta-1-aresta (apply '+ (quadrados-onde-falta-1-aresta tabuleiro-convertido (- (length tabuleiro-convertido) 1) (- (length (first tabuleiro-convertido)) 1) (- (length (first tabuleiro-convertido)) 1) )) )
				 (n-quadrados-onde-falta-1-aresta-pai (apply '+ (quadrados-onde-falta-1-aresta tabuleiro-pai-convertido (- (length tabuleiro-pai-convertido) 1) (- (length (first tabuleiro-pai-convertido)) 1) (- (length (first tabuleiro-pai-convertido)) 1) )) )
				 
				 )
			  
			  (cond 
			   (( = ( + n-quadrados-onde-falta-1-aresta (apply '+ LChains-tabuleiro) (* 2 n-DChains-tabuleiro) n-SChains-tabuleiro ) (- 49 (numero-caixas-fechadas tabuleiro) )  ) ;;se estamos numa fase final (tested)
				
				(cond 
				
				((> (numero-caixas-fechadas tabuleiro) (numero-caixas-fechadas tabuleiro-pai)) ;;caixas foram fechadas (tested)
					   
					   ;;casos de quando preenche
					   (cond
						
						(
						 (and
						  (= n-LChains-tabuleiro n-LChains-tabuleiro-pai)
						  (= n-DChains-tabuleiro n-DChains-tabuleiro-pai)
						  (= n-SChains-tabuleiro (- n-SChains-tabuleiro-pai 1))
						  (= n-quadrados-onde-falta-1-aresta-pai n-quadrados-onde-falta-1-aresta)
						  
						  
						  );;preencheu o fim de uma LChain e nao devia muito má jogada
						 -100
						 )
						(t 
						 100
						 )) ;;caso contratio
					   
					   )
					  
					  
					  
					  
				
				(t  ;;situação dos pares e impares
					(cond
					 ((= 1 n-jogador ) ;somos os primeiros a jogar
					  
					  
					   (cond
					   ((= 0 (mod (+ n-DChains-tabuleiro n-SChains-tabuleiro) 2));;caso bom para o j1
						
						(- (+	
							
							 (+ 
							  (- (numero-caixas-fechadas tabuleiro) n-caixas-adrevesario )
							  (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) 
							  )
							 
							(* 2 (floor (/ n-DChains-tabuleiro 2))))
						   (* 2 (ceiling (/ n-DChains-tabuleiro 2) ))
						   ))
						   
						   (t ;;caso mau para o j1
						   
						  (+ (-	
							
							 (- 
							  (- (numero-caixas-fechadas tabuleiro) n-caixas-adrevesario )
							  (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) 
							  )
							 
							(* 2 (floor (/ n-DChains-tabuleiro 2))))
						   (* 2 (ceiling (/ n-DChains-tabuleiro 2) ))
						   )
						   )
						  
						  
						  )
					   
					   
					   )
					 (T ;somos os segundos a jogar
					  
						(cond
					   ((= 1 (mod (+ n-DChains-tabuleiro n-SChains-tabuleiro) 2));;caso bom para o j2, quando é impar
						
						(progn (format t "bom j2 ~A"  (list n-quadrados-onde-falta-1-aresta (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) (* 2 (1- (length LChains-tabuleiro))) ))
						(- (+	
							
							 (+ 
							  (- (numero-caixas-fechadas tabuleiro) n-caixas-adrevesario )
							  (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) 
							  )
							 
							(* 2 (floor (/ n-DChains-tabuleiro 2))))
						   (* 2 (ceiling (/ n-DChains-tabuleiro 2) ))
						   )))
					   
					   (t ;;caso mau para o j2
					   
						  ((= 0 (mod (+ n-DChains-tabuleiro n-SChains-tabuleiro) 2));;caso bom para o j1
						   
						   (progn (write-line "mau 2")(+ (-	
							   (+ (-	
							
							 (- 
							  (- (numero-caixas-fechadas tabuleiro) n-caixas-adrevesario )
							  (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) 
							  )
							 
							(* 2 (floor (/ n-DChains-tabuleiro 2))))
						   (* 2 (ceiling (/ n-DChains-tabuleiro 2) ))
						   ) )
						   )
						  
						  
						  )
					   
					   )
					  
					  )
					 )
					
					
					)
				
				)
	)			
			   
			   (t
				;;(- (numero-caixas-fechadas tabuleiro) n-caixas-adrevesario )
				(list n-quadrados-onde-falta-1-aresta)
				)
			   
			   
			   )
			  
			  )
			
			)
		 
		 )	
		
	)

		