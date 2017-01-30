

;;;;
;;;; Constantes:
;;;;
 (defvar *jogador2* 2)
 (defvar *jogador1* 1)
 (defparameter *avaliacoes-hash* (make-hash-table :rehash-size 100000))

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
 "serve para se testar o projeto durante o seu desenvolvimento"
  '(((NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL)) ((2 2 1 2 1 2 1) (2 1 2 1 2 1 2) (1 2 1 2 1 2 1) (2 1 2 1 2 1 NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL) (NIL NIL NIL NIL NIL NIL NIL)))
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
	"devolve o numero de arestas que o tabuleiro contem"
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Classificação do tabuleiro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mapear-bool-binario (lista)
	"Mapeia uma lista de valores booleanos (t e nil) para uma lista de valores binarios (1 0)"
	(mapcar
		(lambda
			(elemento)
			(cond
				((null elemento) 0) ; se o elemento nil devolve 0
				(t 1) ; caso contrário devolve 1
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
;; Metodos do tabuleiro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun get-arcos-horizontais (tabuleiro)
	"Retorna a lista dos arcos horizontais de um tabuleiro"
	(first tabuleiro) ; devolve o primeiro elemento do tabuleiro
)

(defun get-arcos-verticais (tabuleiro)
	"Retorna a lista dos arcos verticiais de um tabuleiro"
	(second tabuleiro) ; devolve o segundo elemento do tabuleiro
)

(defun arco-na-posicao (i lista peca)
	"Recebe uma lista de arcos e tenta inserir um arco na posição i"
	(let
		(
			(elemento (elemento-por-indice (1- i) lista))
		)
		(cond
			((null elemento) (substituir (1- i) peca lista))
			(t nil)
		)
	)
)

(defun arco-aux (x y matriz peca)
	"Recebe uma matriz de arcos e tenta inserir um arco na posição x y"
	(let*
		(
			(x-aux (1- x)) ; altera a indexação do x para x-1
			(lista (elemento-por-indice x-aux matriz)) ;vai buscar a lista a matriz na posição x-1
			(nova-lista (arco-na-posicao y lista peca)) ; mete o arco na posição
		)
		(cond
			((null nova-lista) nil) ; se devolveu nil devolve nil
			(T (substituir x-aux nova-lista matriz)) ; caso contrário substitui a lista
		)
	)
)

(defun arco-horizontal (x y tabuleiro peca)
	"Recebe um tabuleiro e tenta inserir um arco na posição x y dos arcos horizontais"
	(let*
		(
			(arcos-horizontais (get-arcos-horizontais tabuleiro)) ; vai buscar a matriz de arcos horizontais ao tabuleiro
			(arcos-horizontais-resultado (arco-aux x y arcos-horizontais peca)) ; mete o arco na posição x e y da matriz
		)
		(cond
			((null arcos-horizontais-resultado) nil) ; se devolveu nil devolve nil
			(t (substituir 0 arcos-horizontais-resultado tabuleiro)) ; caso contrário substitui a matriz nos arcos horizontais do tabuleiro
		)
	)
)


(defun arco-vertical (x y tabuleiro peca)
	"Recebe um tabuleiro e tenta inserir um arco na posição x y dos arcos verticais"
	(let*
		(
			(arcos-verticais (get-arcos-verticais tabuleiro)) ; vai buscar a matriz de arcos verticais ao tabuleiro
			(arcos-verticais-resultado (arco-aux x y arcos-verticais peca)) ; mete o arco na posição x e y da matriz
		)
		(cond
			( (null arcos-verticais-resultado) nil) ; se devolveu nil devolve nil
			( t (substituir 1 arcos-verticais-resultado tabuleiro) ) ; caso contrário substitui a matriz nos arcos verticais do tabuleiro
		)
	)
)

(defun numero-caixas-horizontal (tabuleiro)
	"Dá número de caixas na horizontal"
	(length (first (get-arcos-horizontais tabuleiro)))
)

(defun numero-caixas-vertical (tabuleiro)
	"Dá número de caixas na vertical"
	(length (first (get-arcos-verticais tabuleiro)))
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Manipulação de nós
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun no-criar (estado &optional (pai nil) (profundidade 0) (controlo nil))
  "Cria um nó"
  (list estado pai profundidade controlo)
)

(defun no-estado (no)
	"Devolve o estado do nó"
	(elemento-por-indice 0 no)
)

(defun no-pai (no)
	"Devolve o pai do nó"
	(elemento-por-indice 1 no)
)

(defun no-profundidade (no)
	"Devolve a profundidade do nó"
	(elemento-por-indice 2 no)
)

(defun no-controlo (no)
	(elemento-por-indice 3 no)
)

(defun set-no-estado (no estado)
 "Altera o estado de um nó"
  (substituir 0 estado no)
)

(defun set-no-pai (no pai)
 "Altera o pai do nó"
  (substituir 1 pai no)
)

(defun set-no-profundidade (no profundidade)
 "Altera o pai do nó"
  (substituir 2 profundidade no)
)

(defun set-no-controlo (no controlo)
 "Altera o elemeto de controlo do nó"
  (substituir 3 controlo no)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Manipulação de nós - Controlo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun no-numero-caixas-jogador1 (no)
  "Devolve o número de caixas do jogador1"
  (elemento-por-indice 0 (no-controlo no))
)

(defun set-no-numero-caixas-jogador1 (no numero-caixas)
	"Altera o número de caixas do jogador 1"
	(set-no-controlo no (substituir 0 numero-caixas (no-controlo no)))
)

(defun no-numero-caixas-jogador2 (no)
  "Devolve o número de caixas do jogador2"
  (elemento-por-indice 1 (no-controlo no))
)

(defun set-no-numero-caixas-jogador2 (no numero-caixas)
	"Altera o número de caixas do jogador 2"
	(set-no-controlo no (substituir 1 numero-caixas (no-controlo no)))
)

(defun no-jogador (no)
  "Devolve o jogador que vai jogar sobre este nó"
  (elemento-por-indice 2 (no-controlo no))
)

(defun set-no-jogador (no jogador)
	"Altera o jogador que vai jogar sobre este nó"
	(set-no-controlo no (substituir 2 jogador (no-controlo no)))
)

(defun no-jogada (no)
  "Devolve a jogada que deu origem a este nó"
  (elemento-por-indice 3 (no-controlo no))
)

(defun set-no-jogada (no jogada)
	"Altera a jogada que deu origem a este nó"
	(set-no-controlo no (substituir 3 jogada (no-controlo no)))
)

(defun no-numero-arestas (no)
  "Devolve o número de arestas do tabuleiro"
  (elemento-por-indice 4 (no-controlo no))
)

(defun set-no-numero-arestas (no numero-aresta)
	"Altera o número de arestas do tabuleiro"
	(set-no-controlo no (substituir 4 numero-aresta (no-controlo no)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simetrias
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun rodar90 (tabuleiro)
 "roda o tabuleiro num angulo de 90graus"
	(let*
		(
			(horizontais (get-arcos-horizontais tabuleiro))
			(verticais (get-arcos-verticais tabuleiro))
			(novo-horizontais
				(mapcar 'reverse verticais)
			)
			(novo-verticais
				(reverse horizontais)
			)
		)
		(list novo-horizontais novo-verticais)
	)
)

(defun espelhar-horizontal (tabuleiro)
 "espelha o tabuleiro em relação ao  eixo dos x"
	(let*
		(
			(horizontais (get-arcos-horizontais tabuleiro))
			(verticais (get-arcos-verticais tabuleiro))
			(novo-horizontais
				(mapcar 'reverse horizontais)
			)
			(novo-verticais
				(reverse  verticais)
			)
		)
		(list novo-horizontais novo-verticais)
	)
)


(defun espelhar-vertical (tabuleiro)
 "espelha o tabuleiro em relação ao eixo dos y"
	(let*
		(
			(horizontais (get-arcos-horizontais tabuleiro))
			(verticais (get-arcos-verticais tabuleiro))
			(novo-horizontais
				(reverse horizontais)
			)
			(novo-verticais
				(mapcar 'reverse verticais)
			)
		)
		(list novo-horizontais novo-verticais)
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Operadores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun criar-operacao (x y funcao nome-funcao)
	"Cria uma função lambda que representa uma opera??o atrav?s de uma opera??o (arco-horizontal/arco-vertical) e a posi??o x e y"
	(lambda (no) ; operador
		(let*
			(
				( peca (no-jogador no))
				( numero-caixas (+ (no-numero-caixas-jogador1 no) (no-numero-caixas-jogador2 no)) )
				( tabuleiro (funcall funcao x y (no-estado no) peca) ) ;executa a opera??o sobre o no
			)
			(cond
				((null tabuleiro) nil)
				((equal (no-estado no) tabuleiro) nil) ; se o estado do antecessor ? igual ao estado do sucessor, ? discartando devolvendo nil
				(t
					(let*
						(
							(no-resultado 	(set-no-numero-arestas (set-no-jogada ;altera a jogada do nó
																		(set-no-profundidade  ;altera a profundidade do n?
																			(set-no-pai ;altera a pai do n? antecessor devolvendo um novo n?
																					(set-no-estado no tabuleiro) ; altera o estado do nó pai
																					no ; nó pai
																			)
																			(1+ (no-profundidade no));altera a profundidade do n?
																		)
																		(list funcao nome-funcao x y)
																)
																(cond
																	((null (no-numero-arestas no)) (1+(n-arestas-preenchidas (no-estado no))))
																	( t (1+ (no-numero-arestas no)) )
																)
											)
							)
							(no-numero-caixas (numero-caixas-fechadas tabuleiro))
						)
						(cond
							((= no-numero-caixas numero-caixas) (set-no-jogador no-resultado (trocar-peca peca)));numero de caixas não mudou
							((= peca *jogador1*) (set-no-numero-caixas-jogador1 no-resultado (1+ (no-numero-caixas-jogador1 no-resultado))));incrementa o numero de caixas do jogador
							((= peca *jogador2*) (set-no-numero-caixas-jogador2 no-resultado (1+ (no-numero-caixas-jogador2 no-resultado))));incrementa o numero de caixas do jogador
						)
					)
				)
			)
		)
	)
)


(defun criar-operacoes-decrementarY (x y funcao nome-funcao)
	"Decrementa o valor de y recursivamente e vai criando opera??es com o valor de x e y e a fun??o"
	(cond
		( (= y 0) nil ) ; se y igual a 0 devolve nil
		( t (cons (criar-operacao x y funcao nome-funcao) (criar-operacoes-decrementarY x (1- y) funcao nome-funcao)) ) ; cria a opera??o para x e y e chama recusivamente a fun??o com y-1
	)
)


(defun criar-operacoes-decrementarX (x y funcao nome-funcao)
	"Decrementa o valor de x recursivamente e vai chamando a fun??o 'criar-operacoes-decrementarY' com o valor de x e y e a funcao"
	(cond
		( (= x 0) nil ) ; se x igual a 0 devolve nil
		( t (append (criar-operacoes-decrementarY x y funcao nome-funcao) (criar-operacoes-decrementarX (1- x) y funcao nome-funcao)) ) ; chama a fun??o que cria as opera??es decrementando y para x e come?ando em y e chama recusivamente a fun??o com x-1
	)
)


(defun criar-operacoes (n m funcao-verticais funcao-horizontais)
	"Gera todos os operadores poss?veis para um tabuleiro de n por m"
	(append
		(criar-operacoes-decrementarX (1+ n) m funcao-horizontais "arco-horizontal") ; chama a fun??o que cria as opera??es decrementando x partindo de x = (n+1) e y = m
		(criar-operacoes-decrementarX (1+ m) n funcao-verticais "arco-vertical") ; chama a fun??o que cria as opera??es decrementando x partindo de x = (m+1) e y = n
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Testes para as operações
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun aplicar-consecutivamente (no operacoes)
	"Aplica um conjunto de operações consecutivas a um tabuleiro"
	(cond
		( (null operacoes) no )
		( t (aplicar-consecutivamente (funcall (first operacoes) no) (rest operacoes)) )
	)
)

; (teste-preencher 7 7 *jogador1*)
(defun teste-preencher (n m peca)
	"Realiza um teste que gera todos os operadores possiveis e os aplica num tabuleiro n por m consecutivo, com objetivo a preecher todo o tabuleiro com arcos"
	(let
		(
			(operacoes (criar-operacoes n m #'arco-vertical #'arco-horizontal))
			(tabuleiro (tabuleiro-inicial))
		)
		(aplicar-consecutivamente (no-criar tabuleiro nil 0 (list 0 0 peca)) operacoes)
	)
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sucessores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun remover-sucessores(tabuleiro sucessores)
	"Remove todas a ocorrencias de um tabuleiro nos sucessores"
	(cond
		( (null sucessores) nil )
		( (equal tabuleiro (no-estado (first sucessores))) (remover-sucessores tabuleiro (rest sucessores)) )
		( t (cons (first sucessores) (remover-sucessores tabuleiro (rest sucessores))) )
	)
)


(defun sucessores-sem-simetrias(sucessores)
	"Remove os sucessores simétricos deixando apenas nós com tabuleiros únicos conceptualmente"
	(cond
		((null sucessores) nil)
		(t (let*
				(
				(normal (no-estado (first sucessores)))
				(n-esp-h (espelhar-horizontal normal))
				(n-esp-v (espelhar-vertical normal))
				(rodado90 (rodar90 normal))
				(rodado90-esp-h (espelhar-horizontal rodado90))
				(rodado90-esp-v (espelhar-vertical rodado90))
				(rodado180 (rodar90 rodado90))
				(rodado270 (rodar90 rodado180))

				(s1 (remover-sucessores normal (rest sucessores)))
				(s2 (remover-sucessores rodado90 s1))
				(s3 (remover-sucessores rodado180 s2))
				(s4 (remover-sucessores rodado270 s3))
				(s5 (remover-sucessores n-esp-h s4))
				(s6 (remover-sucessores n-esp-v s5))
				(s7 (remover-sucessores rodado90-esp-h s6))
				(s8 (remover-sucessores rodado90-esp-v s7))
				)
				(cons (first sucessores) (sucessores-sem-simetrias s8))
			)
		)
	)
)



; TODO - GUARDAR OS SUCESSORES GERADOS NUMA HASH TABLE
(defun sucessores-no (no operadores)
	"devolve os sucessores do no recebido conforme os operadores recebidos"
	(let*
		(
			(funcao (lambda (op) ;função que irá gerar os nós sucessores para cada operação
							(funcall op no)
					)
			)
			(sucessores (limpar-nils (mapcar funcao operadores)))
		)
		(cond
			((> (no-numero-arestas no) 20)  (sucessores-sem-simetrias sucessores)) ; optimizações de simetria até 20 arestas
			(t sucessores)
		)
	)
)
;(sucessores-no (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1*)) (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal))
;(sucessores-no (no-criar '(((0 0)(0 0)(0 0))((0 0)(0 0)(0 0))) nil 0 (list 0 0 *jogador1*)) (criar-operacoes 2 2 #'arco-vertical #'arco-horizontal))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ordenação
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun ordenar-crescente (sucessores)
 "ordena uma lista de sucessores por ordem crescente"
	(sort (mapcar 'avaliar-folha-limite sucessores) #'< )
)

(defun ordenar-decrescente (sucessores)
 "ordena uma lista de sucessores por ordem decrescente"
	(sort (mapcar 'avaliar-folha-limite sucessores) #'> )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Heuristica
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun get-squares-example()
"usado para testes na função de avaliação"
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
 "função de devolve um quadrado na posição x-y do tabuleiro"
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
"marca uma quadrado como fechado (ou seja já visitado)"
(list (car quadrado) '1)
)

(defun fechar-quadrado(tabuleiro x y)
"função que tranforma uma quadrado do tabuleiro em fechado/visitado"
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

(defun is-quadrado-aberto(quadrado)
	"serve para saber se o quadrado ja foi fechado/visitado"
	(cond
		((null quadrado) nil)
		( T (= 0 (cadr quadrado)))
	)
)

(defun n-arestas-por-preencher-quadrado (quadrado)
	"devolve o numero de arestar por preencher o quadrado"
	(apply '+ (mapcar (lambda (x) (cond ((= 0 x) 1) (t 0))) (car quadrado)))
)



  (let ((tabuleiro '()) ) ;;para otimizar


        (defun verificar-correntes-tabuleiro(x y)
          "percorre todo o tabuleiro a procura de correntes e devolve uma lista em que cada elemento é o tamanho da corrente"
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
                  (+ 1 (verificar-correntes-tabuleiro (- x 1) y ) (verificar-correntes-tabuleiro x (+ y 1)))) ;;vai somar
                 ;;

                 ((and ;;segunda condicao topo-baixo
                       (= 0 (first(first quadrado ))) ;;se nao tem no topo
                       (= 0 (second(first quadrado ))) ;;se nao tem na baixo
                       )
                  (+ 1 (verificar-correntes-tabuleiro (- x 1) y ) (verificar-correntes-tabuleiro (+ 1 x) y))) ;;vai somar

                 ;;

                 ((and ;;primeira condicao topo-esquerda
                       (= 0 (first(first quadrado ))) ;;se nao tem no topo
                       (= 0 (fourth(first quadrado ))) ;;se nao tem na esquerda
                       )
                  (+ 1 (verificar-correntes-tabuleiro (- x 1) y ) (verificar-correntes-tabuleiro x (- y 1)))) ;;vai somar

                 ((and ;;primeira condicao baixo-direita
                       (= 0 (second(first quadrado ))) ;;se nao tem no baixo
                       (= 0 (third(first quadrado ))) ;;se nao tem na direita
                       )
                  (+ 1 (verificar-correntes-tabuleiro (+ x 1) y ) (verificar-correntes-tabuleiro x (+ y 1)))) ;;vai somar

                 ((and ;;primeira condicao baixo-esquerda
                       (= 0 (second(first quadrado ))) ;;se nao tem no baixo
                       (= 0 (fourth(first quadrado ))) ;;se nao tem na esquerda
                       )
                  (+ 1 (verificar-correntes-tabuleiro (+ x 1) y ) (verificar-correntes-tabuleiro x (- y 1)))) ;;vai somar


                 ((and ;;primeira condicao baixo-esquerda
                       (= 0 (third(first quadrado ))) ;;se nao tem no direita
                       (= 0 (fourth(first quadrado ))) ;;se nao tem na esquerda
                       )
                  (+ 1 (verificar-correntes-tabuleiro x (+ y 1) ) (verificar-correntes-tabuleiro x (- y 1)))) ;; vai somar

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
      "devolve o valor do nó"
					(progn
					(setf tabuleiro tabuleiro-inicial)
					(limpa-zeros (init-procura-correntes (- (length tabuleiro) 1) (- (length (first tabuleiro)) 1) (- (length (first tabuleiro)) 1) )))
			)


			(defun init-procura-correntes(x y z)
      "inicia a procura das correntes no tabuleiro"
				(cond
						((= -1 x) nil )
						((= 0 y) (cons (verificar-correntes-tabuleiro x y) (init-procura-correntes (- x 1) z z)))
						(t (cons (verificar-correntes-tabuleiro x y) (init-procura-correntes x (- y 1) z )))
				)
			)


			(defun limpa-zeros (lista)
      "retira os zeros de uma lista"
				(cond
					((null lista) nil)
					((= 0 (car lista)) (limpa-zeros (rest lista)))
					(t (cons (car lista) (limpa-zeros (rest lista))))
				)

			)

	)


	
	

	  (defun f-avaliacao(tabuleiro tabuleiro-pai n-jogador n-caixas-jogador n-caixas-adrevesario n-arestas)
		"função de devolve a avaliação do tabuleiro (resultado da função de avaliação do tabuleiro)"
		
		  (let*
				
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
					   ((and (= 0 (mod n-LChains-tabuleiro 2)) (= 0 (mod (+ n-DChains-tabuleiro n-SChains-tabuleiro) 2)));;caso bom para o j1
						
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
					   ((and (= 1 (mod n-LChains-tabuleiro 2)) (= 1 (mod (+ n-DChains-tabuleiro n-SChains-tabuleiro) 2)));;caso bom para o j2, quando é impar
						(- (+	
							
							 (+ 
							  (- (numero-caixas-fechadas tabuleiro) n-caixas-adrevesario )
							  (calcular-caixas-ganhas-em-LChains LChains-tabuleiro) 
							  )
							 
							(* 2 (floor (/ n-DChains-tabuleiro 2))))
						   (* 2 (ceiling (/ n-DChains-tabuleiro 2) ))
						   )
						   )
					   
					   (t ;;caso mau para o j2
						  (+ (-	
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
	)	))		
			   
			   (t
				(cond 
				((> (numero-caixas-fechadas tabuleiro) (numero-caixas-fechadas tabuleiro-pai)) (progn (write-line "posso caixa") (+ 0 100)))
				 (t 
					(let* 
						( 
						(tabuleiro-convertido (converter-tabuleiro tabuleiro));;tabuleiro convertido para calcular as correntes)
						(n-quadrados-onde-falta-1-aresta (apply '+ (quadrados-onde-falta-1-aresta tabuleiro-convertido (- (length tabuleiro-convertido) 1) (- (length (first tabuleiro-convertido)) 1) (- (length (first tabuleiro-convertido)) 1) )) )
				
						)
					(cond
					((> n-quadrados-onde-falta-1-aresta 0) (- (expt 3  n-quadrados-onde-falta-1-aresta )))
					(t (+ (- (numero-caixas-fechadas tabuleiro)  (* 3 n-caixas-adrevesario) ) (* 4 n-caixas-jogador)  ) )
					)
					)
				 )
				)
				)
			   
			   
			   )
			  
			  )
			
			
		 
		 	
		
	)

		

	
	
	(defun quadrados-onde-falta-1-aresta (quadrados x y z)
	"numero quadrados com 3 arestas"
				(cond
						((= -1 x) nil )
						((= 0 y) (cons (quadrados-onde-falta-1-aresta-aux quadrados x y) (quadrados-onde-falta-1-aresta quadrados (- x 1) z z)))
						(t (cons (quadrados-onde-falta-1-aresta-aux quadrados x y) (quadrados-onde-falta-1-aresta quadrados x (- y 1) z )))
				)
			)
			
	(defun quadrados-onde-falta-1-aresta-aux(tabuleiro x y)
	
		(cond 
		
		((= 1 (n-arestas-por-preencher-quadrado (obter-quadrado tabuleiro x y))) 1 )

		(t 0))
	
	)

	(defun calcular-caixas-ganhas-em-LChains(lchains &optional(primeira 1))
  "funcao que recebe uma lista de Long Chains com o tamanho de cada uma e devolve quantas caixas consegue-se fazer"
		(cond
			((null lchains) 0)
			((= 1 primeira) (+ (car lchains) (calcular-caixas-ganhas-em-LChains (rest lchains) 0 )))
			(T (+ (- (car lchains) 2) (calcular-caixas-ganhas-em-LChains (rest lchains) 0) ) )

		)

	)

	(defun n-arestas-preenchidas(tabuleiro)
  "funcao que devolve o numero de arestas que o tabuleiro tem preenchidas"
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
  "funcao que filta uma lista de correntes devolvendo as longas (3+)"
		(cond
			((null resultados) nil)
			((> (car resultados) 2) (cons (car resultados) (obter-LChains (rest resultados))))
			(t (obter-LChains (rest resultados)))
		)


	)


	(defun obter-DChains(resultados)
  "funcao de filtra uma lista de correntes e devolve as de tamanho 2"
		(cond
			((null resultados) nil)
			((= (car resultados) 2) (cons (car resultados) (obter-DChains (rest resultados))))
			(t (obter-DChains (rest resultados)))
		)


	)


	(defun obter-SChains(resultados)
  "funcao que filtra uma lista de correntes e devolve as de tamanho 1 (possiveis correntes)"
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
"funcao que converte nils em 0"
(cond
	((null lista) nil)
	((null (car lista)) (cons '0 (nil-to-zero (rest lista))))
	(t (cons (car lista) (nil-to-zero (rest lista))))
)

)


(defun numero-caixas-fechadas (tabuleiro)
	"Devolve o número de caixas fechadas num tabuleiro"
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




(defun tab-pai ()

'(
    ((1 NIL NIL NIL NIL NIL NIL)
	(NIL 1 NIL NIL NIL 2 1)
    (NIL 2 NIL NIL 2 1 2)
	(NIL NIL 2 2 1 2 1)
    (NIL NIL NIL NIL NIL NIL NIL)
	(NIL NIL NIL NIL NIL NIL NIL)
    (NIL NIL NIL NIL NIL NIL NIL)
	(NIL NIL NIL NIL NIL NIL NIL))
	
    ((2 1 2 1 2 1 2)
	(NIL 2 1 2 1 2 1)
    (2 1 NIL 1 2 1 2)
	(1 2 1 NIL 1 2 1)
    (1 2 NIL 1 2 1 2)
	(1 NIL NIL NIL 2 1 2)
    (NIL NIL NIL 2 1 2 1)
	(2 NIL NIL NIL 1 2 NIL))

)

)


(defun tab ()

'(
    ((1 NIL NIL NIL NIL NIL NIL)
	(NIL 1 NIL NIL NIL 2 1)
    (NIL 2 NIL NIL 2 1 2)
	(NIL NIL 2 2 1 2 1)
    (NIL NIL NIL NIL NIL NIL NIL)
	(NIL NIL NIL NIL NIL NIL NIL)
    (NIL NIL NIL NIL NIL NIL NIL)
	(NIL NIL NIL NIL NIL NIL NIL))
	
    ((2 1 2 1 2 1 2)
	(NIL 2 1 2 1 2 1)
    (2 1 NIL 1 2 1 2)
	(1 2 1 NIL 1 2 1)
    (1 2 NIL 1 2 1 2)
	(1 NIL NIL NIL 2 1 2)
    (NIL NIL NIL 2 1 2 1)
	(2 NIL NIL NIL 1 2 1))

)

)

(defun tab-teste ()

'(
    ((1 NIL NIL NIL NIL NIL NIL)
	(NIL 1 NIL NIL NIL 2 1)
    (NIL 2 NIL NIL 2 1 2)
	(NIL NIL 2 2 1 2 1)
    (NIL NIL NIL NIL NIL NIL 2)
	(NIL NIL NIL NIL NIL NIL 2)
    (NIL NIL NIL NIL NIL NIL 2)
	(NIL NIL NIL NIL NIL NIL 1))
	
    ((2 1 2 1 2 1 2)
	(NIL 2 1 2 1 2 1)
    (2 1 NIL 1 2 1 2)
	(1 2 1 NIL 1 2 1)
    (1 2 NIL 1 2 1 2)
	(1 NIL NIL NIL 2 1 2)
    (NIL NIL NIL 2 1 2 1)
	(2 NIL NIL NIL 1 2 1))

)

)


(defun tab-teste-2 ()

'(
    ((1 NIL NIL NIL NIL NIL NIL)
	(NIL 1 NIL NIL NIL 2 1)
    (NIL 2 NIL NIL 2 1 2)
	(NIL NIL 2 2 1 2 1)
    (NIL NIL NIL NIL NIL NIL NIL)
	(NIL NIL NIL NIL NIL NIL 2)
    (NIL NIL NIL NIL NIL NIL 2)
	(NIL NIL NIL NIL NIL NIL 1))
	
    ((2 1 2 1 2 1 2)
	(NIL 2 1 2 1 2 1)
    (2 1 NIL 1 2 1 2)
	(1 2 1 NIL 1 2 1)
    (1 2 NIL 1 2 1 2)
	(1 NIL NIL NIL 2 1 2)
    (NIL NIL NIL 2 1 2 1)
	(2 NIL NIL 2 1 2 1))

)

)

(defun tab-teste-pai ()

'(
    ((1 NIL NIL NIL NIL NIL NIL)
	(NIL 1 NIL NIL NIL 2 1)
    (NIL 2 NIL NIL 2 1 2)
	(NIL NIL 2 2 1 2 1)
    (NIL NIL NIL NIL NIL NIL NIL)
	(NIL NIL NIL NIL NIL NIL 2)
    (NIL NIL NIL NIL NIL NIL 2)
	(NIL NIL NIL NIL NIL NIL 1))
	
    ((2 1 2 1 2 1 2)
	(NIL 2 1 2 1 2 1)
    (2 1 NIL 1 2 1 2)
	(1 2 1 NIL 1 2 1)
    (1 2 NIL 1 2 1 2)
	(1 NIL NIL NIL 2 1 2)
    (NIL NIL NIL 2 1 2 1)
	(2 NIL NIL NIL 1 2 1))

)

)






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avaliação do tabuleiro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun avaliar-folha (no)
	"funcao que avalia o nó folha"
	(let
		(
			(vencedor (vencedor-p (no-numero-caixas-jogador1 no) (no-numero-caixas-jogador2 no)))
		)
		(cond
			((= vencedor (trocar-peca (no-jogador no))) 100)
			((= vencedor nil) 0)
			(t -100)
		)
	)
)

(defun avaliar-folha-limite (no jogador-otimizar)
"funcao que avalia a folha limite no alfa-beta"
(let*
	(
		(tabuleiro (no-estado no)) ;;tabuleiro a avaliar
		(tabuleiro-pai (no-estado (no-pai no))) ;tabuleiro pai
		(jogador (no-jogador no)) ;;o jogador a jogar
		(numero-caixas (cond ;;caixas do jogador
							((= jogador *jogador1*) (no-numero-caixas-jogador1 no))
							(t (no-numero-caixas-jogador2 no)))
		)
		(numero-caixas-adversario (cond ;;caias do adversario
							((= jogador *jogador1*) (no-numero-caixas-jogador2 no))
							(t (no-numero-caixas-jogador1 no)))
		)
		(numero-arestas (no-numero-arestas no)) ;;numero de arestas
 		(resultado 	(f-avaliacao  tabuleiro tabuleiro-pai jogador numero-caixas numero-caixas-adversario numero-arestas)) ;;a pontuacao
	)
	(cond
						((= jogador jogador-otimizar) (- resultado)) ;;verifica o jogador a otimizar
						(t  (- resultado)))
)

)
