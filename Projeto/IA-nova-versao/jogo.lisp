
(defun tabuleiro-teste-heuristica()

'(
(
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL) 
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 ) 
 (
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 (NIL NIL NIL NIL NIL NIL NIL)
 )
 )

)

(defun iniciar ()	
"Fun��o que inicializa o programa, chamando a fun��o que apresenta o menu inicial."
	(progn
		(compile-file (concatenate 'string (diretoria-atual)"alfabeta.lisp"))  ;compila o ficheiro procura.lisp
		(compile-file (concatenate 'string (diretoria-atual)"pontosecaixas.lisp"))	;compila o ficheiro puzzle.lisp
		(load (concatenate 'string (diretoria-atual)"alfabeta.ofasl"))  ;faz load do ficheiro compilado da procura.lisp
		(load (concatenate 'string (diretoria-atual)"pontosecaixas.ofasl")) ;faz load do ficheiro compilado do puzzle.lisp
		
	)
)

(defun diretoria-atual () 
	"Fun��o que define um caminho para leitura dos ficheiros."
	(let (

			;(path-ricardo "C:/Users/Ricardo Morais/Documents/IA_Lisp_projeto/Projeto/")
			(path-tiago  "C:/Users/pcts/Documents/Projeto_CM_IA/Projeto/IA-nova-versao/")
			;(path-professor (pedir-directoria))
		)
			
		path-tiago
		;path-ricardo
		;path-professor
	)
)

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

(defun call-memory-functions()
  (gc-generation t)          ; first collect all dead objects
  (multiple-value-bind (tf tsb tlb)
      (check-fragmentation 2) ; check the fragmentation
    (when  (and (> 10000000 tlb)         
                (> (ash tf -2) tlb))
       (try-move-in-generation 2 0))))

(defun jogar()
  (let ((caixas1 0) (caixas2 0) (vez 2) (tabuleiro (tabuleiro-teste-heuristica)) (jogada '())) 
   (loop
   (progn (call-memory-functions) 
     (cond
      ((null (vencedor-p caixas1 caixas2))
       (progn (setf jogada (fazer-jogada tabuleiro vez caixas1 caixas2))
         (cond 
          ((> (car jogada) 0)
           (cond 
            ((= 1 vez)
             (progn 
               (setf caixas1 (+ 1 caixas1))
               (setf tabuleiro (cdr jogada))					
               )					
             )
            (T (progn 
                 (setf caixas2 (+ 1 caixas2))
                 (setf tabuleiro (cdr jogada))							
                 )
               )
            )
           )
          (T 
           (progn 			
             (setf vez (cond ((= 1 vez) 2) (t 1)))
             (setf tabuleiro (cdr jogada))
             (list vez jogada tabuleiro)
             )
           )
          )
         
         )
       
       )
      
      (T (return(vencedor-p caixas1 caixas2)))
      )
     )
  ))
)



(defun fazer-jogada(tabuleiro vez caixas1 caixas2)
	(cond 
		((= 1 vez) (progn 
			(imprime-tabuleiro tabuleiro) (format t "~A" tabuleiro) (format t "~%")
				(let* ((jogada (implementar-jogada-humano tabuleiro (ler-jogada))))
					(cons  (- (numero-caixas-fechadas jogada) (numero-caixas-fechadas tabuleiro)) jogada)
				)
			)
		)
		(T 
		(let* ((jogada (no-estado (escolher-jogada (no-criar tabuleiro nil 0 (list caixas1 caixas2 *jogador2* nil 0)) 5000))) )
		
			(cons (- (numero-caixas-fechadas jogada) (numero-caixas-fechadas tabuleiro)) jogada)
		)
		
		
		
		)
	)
)

(defun implementar-jogada-humano (tabuleiro listaComandos)

	(cond 
		((= 0(first listaComandos) )
		 (append (list (jogada-no-tabuleiro (get-arcos-horizontais tabuleiro) (second listaComandos) (third listaComandos) 1)) (list (get-arcos-verticais tabuleiro)))
		
		)
		(t
		(append (list (get-arcos-horizontais tabuleiro)) (list (jogada-no-tabuleiro (get-arcos-verticais tabuleiro) (second listaComandos) (third listaComandos) 1)) )
		)
		
	)

)

(defun jogada-no-tabuleiro(arco x y valor)
(cond 
	((= 0 x) (cons (substituir y valor (car arco)) (rest arco)))
	(t (cons (car arco) (jogada-no-tabuleiro (rest arco) (- x 1) y valor)))
)

)


(defun ler-jogada (&optional (i 0))

(cond
	((= 3 i) nil)
	(t (cons (read) (ler-jogada (+ 1 i))))
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



