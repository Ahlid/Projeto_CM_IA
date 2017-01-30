
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Negamax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun log-teste(alfa beta novo-maior jogador-atual jogador-max profundidade)
"para um log onde se percebe os cortes no algoritmo"
	(progn 
	(write-line (concatenate 'string "A: " (write-to-string alfa)) )
	(write-line (concatenate 'string "B: " (write-to-string beta)) )
		(cond
			((= jogador-atual jogador-max) (setf *cortes-alfa* (1+ *cortes-alfa*))) ; estamos num nó max
			(t (setf *cortes-beta* (1+ *cortes-beta*))) ; estamos num nó min
		)
		(write-line (concatenate 'string "Profundidade: " (write-to-string profundidade)))
	)
)

(defun log-teste2(alfa beta jogador-atual jogador-max)
"para um log onde se percebe os cortes no algoritmo"
	(progn 
	(cond
			((= jogador-atual jogador-max) (write-line "NO MAX")) ; estamos num nó max
			(t (write-line "NO MIN")) ; estamos num nó min
	)
	(write-line (concatenate 'string "A: " (write-to-string alfa)) )
	(write-line (concatenate 'string "B: " (write-to-string beta)) )
	)	
)


(defun negamax-max(sucessores profundidade profundidade-maxima operadores alfa beta maior jogador tempo-inicio tempo-maximo)
	"Passa por todos os sucessores devolvendo o valor max dos mesmos"
	(cond
		((null sucessores) alfa) ; caso não haja mais sucessores   //Duvidas sobre o que retornar aqui
		(t 
			(let*
				(
				
					(start-tempo (get-internal-real-time))
					( no (first sucessores) ) ; buscar o primeiro dos sucessores
					( valor (cond 
								((= (no-jogador no) jogador) ; se o jogador a jogar neste no for o jogador que queremos maximizar
																(negamax 	no  
																		(1+ (no-profundidade no)) ; incrementa a profundidade
																		profundidade-maxima ; profundidade máxima da árvore
																		operadores ; operadores
																		alfa ; alfa
																		beta ; beta
																		jogador ; jogador que queremos optimizar
																		tempo-inicio ; tempo de inicio do negamax
																		tempo-maximo)) ; tempo máximo para correr o negamax
								( t (- (negamax no 			 ; se o jogador a jogar neste no for o jogador que queremos minimizar
																		(1+ (no-profundidade no))  ; incrementa a profundidade
																		profundidade-maxima  ; profundidade máxima da árvore
																		operadores ; operadores
																		(- beta)  ; beta negado no lugar do alfa para que o nó seja tratado como um nó min
																		(- alfa)  ; alfa negado no lugar do beta para que o nó seja tratado como um nó min
																		jogador  ; jogador que queremos optimizar
																		tempo-inicio ; tempo de inicio do negamax
																		tempo-maximo))) ; tempo máximo para correr o negamax
																				
							)
					)
					( novo-maior (max valor maior) ) ; novo valor max de todos os valores calculados alteriormente
					( novo-alfa (max valor alfa) ) ; novo alfa é o max entre o valor calculado para este nó e o alfa atual
					(end-tempo (get-internal-real-time))
					
				)(progn 
					;;(log-teste2 alfa beta (no-jogador no) jogador)
				
				(cond 
					( (>= novo-alfa beta) (progn (log-teste alfa beta novo-maior (no-jogador no) jogador profundidade) novo-maior )) ; situação de corte
					( t (max 				; Devolve o valor máximo entre o novo-alfa e o valor negamax retornado pela proxima chamada recursiva
								novo-alfa  
								(negamax-max 	(rest sucessores) ; restantes sucessores
												profundidade ; profundidade atual
												profundidade-maxima  ; profundidade maxima
												operadores ; operadores
												novo-alfa ; novo-beta no lugar do alfa
												beta ; continuamos com o mesmo beta 
												novo-maior ; mandamos os novo-maior para efeitos de comparação
												jogador ; jogador que queremos optimizar
												tempo-inicio ; tempo de inicio do negamax
												(max 0 (- tempo-maximo (- end-tempo start-tempo)) ))) ) ; tempo máximo para correr o negamax
				))
			)
		)
	)
)



;;IMPORTANTE... para escolher a jogada o melhor é gerar os sucessores e chamar o negamax para cada 1 desses e ver qual o que tem o maior valor.


;(negamax (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1*)) 0 2 (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal) -100 100 *jogador1*)

(defun negamax-simples (no profundidade profundidade-maxima operadores alfa beta jogador tempo-inicio tempo-maximo)
	"Executa o negamax no seu mais rudimentar sem HashTables"
	(cond 
		( (> (- (get-internal-real-time) tempo-inicio) tempo-maximo) (avaliar-folha-limite no jogador) ) ; excedeu o tempo-maximo devolvemos uma avaliação do tabuleiro
		( (>= profundidade profundidade-maxima) (avaliar-folha-limite no jogador) ) ; Devolve uma avaliação do tabuleiro
		( (vencedor-p (no-numero-caixas-jogador1 no) (no-numero-caixas-jogador2 no)) (avaliar-folha no) ) ; Devolve o valor real do nó
		( t 
			(let*
				(
					(sucessores (sucessores-no no operadores)) ; gera os sucessores
					;(sucessores-ordenados (ordenar sucessores))
				)
				(negamax-max 	sucessores ; sucessores gerados do no
								profundidade ; profundidade atual
								profundidade-maxima ; profundidade máxima do nó
								operadores ; operadores
								alfa ; alfa
								beta ; beta
								-100 ; o valor mínimo possível para tomar o lugar do maior
								jogador ; o jogador a optimizar
								tempo-inicio ; tempo de inicio do negamax
								tempo-maximo ; tempo máximo para correr o negamax
				)
			)
		)
	)
)

(defun guarda-na-hashtable (alfa beta valor no profundidade-maxima) 
"serve para guardar um valor na hash table"
	(cond 
		((<= valor alfa) (setf (gethash (no-estado no) *avaliacoes-hash*) (list 'LOWERBOUND profundidade-maxima valor))) ; Guarda o tabuleiro, o valor e a profundidade máxima como lowerbound
		((>= valor beta) (setf (gethash (no-estado no) *avaliacoes-hash*) (list 'UPPERBOUND profundidade-maxima valor))) ; Guarda o tabuleiro, o valor e a profundidade-maxima como upperbound
		( t (setf (gethash (no-estado no) *avaliacoes-hash*) (list 'EXACT profundidade-maxima valor)) ) ; ; Guarda o tabuleiro, o valor e a profundidade-maxima como valor exato
	)
)



(defun negamax (no profundidade profundidade-maxima operadores alfa beta jogador tempo-inicio tempo-maximo)
	"Acrescenta ao algoritmo negamax-simples a funcionalidade de guardar tabuleiros nas hashtables de modo a optimizar o algoritmo"
	(let* 
		(
			(valor (gethash (no-estado no) *avaliacoes-hash*)) ; Vai buscar o valor da na hashtable através do tabuleiro do no
		)
		(cond
			( (or (null valor) (< (second valor) profundidade-maxima)) ; se a profundidade maxima guardada for inferior à profundidade-maxima atual nao usamos o valor
			
				(let 
					(
						(resultado (negamax-simples no profundidade profundidade-maxima operadores alfa beta jogador tempo-inicio tempo-maximo)) ; Aplicamos normamente o negamax-simples
					)
					(progn
						(guarda-na-hashtable alfa beta resultado no profundidade-maxima) ; Guarda na hashtable o valor obtido para este tabuleiro
						resultado) ; devolve o valor obtido
				)
					
			)
			( (eq 'EXACT (first valor)) (third valor) ) ; Se o valor do tabuleiro é um valor exacto, devolvemos esse valor
			( (and (eq 'LOWERBOUND (first valor)) (< (max alfa (third valor)) beta) ) ; se o valor do tabuleiro for um lowerbound e o max(alfa, valor) < beta vamos utilizar como alfa o max(alfa, valor)
			

				(let 
					(
						(resultado (negamax-simples no profundidade profundidade-maxima operadores (max alfa (third valor)) beta jogador tempo-inicio tempo-maximo)) ;chamamos o negamax-simples com o alfa = max(alfa, valor)
					)
					(progn
						(guarda-na-hashtable alfa beta resultado no profundidade-maxima) ; Guardamos na hashtable o valor retornado
						resultado) ; devolve o valor obtido
				)	
			
			)
			( (and (eq 'UPPERBOUND (first valor)) (<  alfa (min (third valor) beta)) ) ; se o valor do tabuleiro for um upperbound e o min(beta, valor) > alfa vamos utilizar como beta como o min(beta, valor)
			
				(let 
					(
						(resultado (negamax-simples no profundidade profundidade-maxima operadores alfa (min beta (third valor)) jogador tempo-inicio tempo-maximo) );chamamos o negamax-simples com o beta = max(beta, valor
					)
					(progn
						(guarda-na-hashtable alfa beta resultado no profundidade-maxima) ; Guardamos na hashtable o valor retornado
						resultado) ; devolve o valor obtido
				)
				
			)
			(t (third valor)) ; caso contrário devolvemos o valor
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
(defun escolher-jogada-aux (sucessores profundidade-maxima operadores tempo-disponivel jogador) 
	"Tendo um lista de sucessores, usa o negamax em cada um deles e escolhe a melhor jogada de acordo com os valores retornados pelo negamax"
	(cond 
		((null sucessores) nil) ; se a lista de sucessores estiver vazia devolve nil
		(t 
			(let*
				(
					( no (first sucessores) ) ; nó é o primeiro dos sucessores
					(tempo-inicio (get-internal-real-time)) ; iniciado o chronometro
					( valor  (- (negamax 	; chamar o negamax como nó min
										no ; no atual
										1 ; profundidade atual
										profundidade-maxima ; profundidade-maxima
										operadores ; operadores
										-100 ; valor mínimo para iniciar o alfa
										100 ; valor mínimo para iniciar o beta
										jogador ; jogador que queremos optimizar
										tempo-inicio ; timestamp atual
										(/ tempo-disponivel (length sucessores)) ; tempo limite calculado a partir do length dos sucessores (ou seja o numero de sucessores que faltam)
										))
					)
					(tempo-fim (get-internal-real-time)) ; fim do chronometro
					( resultado (escolher-jogada-aux	(rest sucessores) ; resto da lista de sucessores
														profundidade-maxima  ; profundidade-maxima
														operadores ; operadores
														(- tempo-disponivel (- tempo-fim tempo-inicio) ) ; retirar o tempo gasto do tempo disponível e mandar como tempo disponivel na chamada recursiva
														jogador
														)) ; jogador que queremos optimizar
										
				)
				(cond 
					( (null resultado) (list valor no) ) ; se o resultado for nil devolvemos uma lista com este nó e o valor
					( (> valor (first resultado)) (list valor no) ) ; se o valor encontrado deste sucessor é maior que o devolvido devolvemos uma lista com este nó e o valor
					( t resultado ) ; caso contrário devolvemos o resultado
				)
			)
		)
	)
)


; (imprime-tabuleiro  (no-estado (escolher-jogada (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1* nil 0)) 5000)))
(defun escolher-jogada (no tempo-limite)
	"Escolhe uma jogada partindo de um nó"
	(progn
		(defvar *cortes-alfa* 0)
		(defvar *cortes-beta* 0)
		(defvar *sucessores* 0)
	
		(let*
			(
				(operadores (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal)) ; Gera os operadores de um tabuleiro 7 por 7
				(sucessores (sucessores-no no operadores)) ; Gera os sucessores apartir dos operadores e do nó recebido
				(tempo-inicio (get-internal-real-time)) ; Começa o chronometro
				(resultado (escolher-jogada-aux sucessores ; procura o melhor sucessor
							4 ; Profundidade máxima
							operadores ; operadores
							(- tempo-limite 3000) ; tempo disponível para realizar a escolha da jogada
							(no-jogador no))) ; jogador que vai jogar neste nó
				(tempo-fim (get-internal-real-time)) ; Para o chronometro
				(tempo-gasto (- tempo-fim tempo-inicio))
				(path "C:/Users/Ricardo Morais/Documents/")
				;(path-tiago  "C:\\Users\\pcts\\Desktop\\ProjIA\\Projeto\\"))
			)
			
			(cond	
				((null resultado) (first sucessores)) ; se o resultado é nil devolve o primeiro sucessor por default
				(t 
					(progn
						
						(write-line (format nil "Cortes alfa: ~a" *cortes-alfa*) )
						(write-line (format nil "Cortes beta: ~a" *cortes-beta*) )
						(write-line (format nil "Sucessores: ~a" *sucessores*) )
						(write-line (format nil "Operação: ~a" (second (no-jogada (second resultado)))))
						(write-line (format nil "X: ~a" (third (no-jogada (second resultado)))))
						(write-line (format nil "Y: ~a" (third (no-jogada (second resultado)))))
						(write-line (format nil "Tempo gasto: ~a" tempo-gasto) )
						(with-open-file (ficheiro (concatenate 'string path "log.dat") :direction :output
									:if-exists :append
									:if-does-not-exist :create)
							(write-line (format nil "Cortes alfa: ~a" *cortes-alfa*)  ficheiro )
							(write-line (format nil "Cortes beta: ~a" *cortes-beta*) ficheiro )
							(write-line (format nil "Sucessores: ~a" *sucessores*) ficheiro )
							(write-line (format nil "Operação: ~a" (second (no-jogada (second resultado)))) ficheiro)
							(write-line (format nil "X: ~a" (third (no-jogada (second resultado)))) ficheiro)
							(write-line (format nil "Y: ~a" (third (no-jogada (second resultado)))) ficheiro)
							(write-line (format nil "Tempo gasto: ~a" tempo-gasto)  ficheiro)
						)
						
						(second resultado) ; devolve o nó resultante
					)
				)
			)
			
			
		)
	)
)


