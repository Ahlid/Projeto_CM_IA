;;
;;
;;TODO: CRIAR UMA HASH TABLE E GERAR CONHECIMENTO PREENCHER
;;TODO: TER EM CONTA A SIMETRIA DO TABULEIRO ATRAVÉS DAS 4 PERSPETIVAS
;;


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
	(substituir (1- i) peca lista) ; substitui pela peca no indice
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
;; Operadores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun criar-operacao (x y funcao)
	"Cria uma fun??o lambda que representa uma opera??o atrav?s de uma opera??o (arco-horizontal/arco-vertical) e a posi??o x e y"
	(lambda (no) ; operador
		(let*
			(
				( peca (no-jogador no))
				( numero-caixas (+ (no-numero-caixas-jogador1 no) (no-numero-caixas-jogador2 no)) )
				( tabuleiro (funcall funcao x y (no-estado no) peca) ) ;executa a opera??o sobre o no
			)
			(cond
				((equal (no-estado no) tabuleiro) nil) ; se o estado do antecessor ? igual ao estado do sucessor, ? discartando devolvendo nil
				(t 	
					(let* 
						(
							(no-resultado 	(set-no-profundidade  ;altera a profundidade do n?
												(set-no-pai ;altera a pai do n? antecessor devolvendo um novo n?
														(set-no-estado no tabuleiro) ; altera o estado do n?
														no
												)
												(1+ (no-profundidade no));altera a profundidade do n?
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



;; N?o existe grande peso de performance aqui pois as opera??es s?o geradas apenas no ?nicio

(defun criar-operacoes-decrementarY (x y funcao)
	"Decrementa o valor de y recursivamente e vai criando opera??es com o valor de x e y e a fun??o"
	(cond
		( (= y 0) nil ) ; se y igual a 0 devolve nil
		( t (cons (criar-operacao x y funcao) (criar-operacoes-decrementarY x (1- y) funcao)) ) ; cria a opera??o para x e y e chama recusivamente a fun??o com y-1
	)
)


(defun criar-operacoes-decrementarX (x y funcao)
	"Decrementa o valor de x recursivamente e vai chamando a fun??o 'criar-operacoes-decrementarY' com o valor de x e y e a funcao"
	(cond
		( (= x 0) nil ) ; se x igual a 0 devolve nil
		( t (append (criar-operacoes-decrementarY x y funcao) (criar-operacoes-decrementarX (1- x) y funcao)) ) ; chama a fun??o que cria as opera??es decrementando y para x e come?ando em y e chama recusivamente a fun??o com x-1
	)
)


(defun criar-operacoes (n m funcao-verticais funcao-horizontais)
	"Gera todos os operadores poss?veis para um tabuleiro de n por m"
	(append
		(criar-operacoes-decrementarX (1+ n) m funcao-horizontais) ; chama a fun??o que cria as opera??es decrementando x partindo de x = (n+1) e y = m
		(criar-operacoes-decrementarX (1+ m) n funcao-verticais) ; chama a fun??o que cria as opera??es decrementando x partindo de x = (m+1) e y = n
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


;; avaliar-folha

;Defina uma fun??o avaliar-folha que recebe um n? final (validado anteriormente
;pela fun??o vencedor-p) e o tipo de jogador [MAX ; MIN]. A fun??o retorna o valor [100] em
;caso de vitoria do jogador MAX, o valor [-100] em caso de vitoria do jogador MIN ou o valor [0]
;em caso de empate.
(defun avaliar-folha (no)
	""
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



;; avaliar-folha-limite
(defun avaliar-folha-limite (no)
	""
	(let*
		(
			(valor (random 100))
			(heuristic (- (random (1+ valor)) (floor valor 2)))
		
		)
		(cond 
			((= (trocar-peca (no-jogador no)) *jogador1*) (- heuristic) )
			((= (trocar-peca (no-jogador no)) *jogador2*) heuristic )
		)
	)	
)



;; sucessores-no
;Defina uma fun??o sucessores-no que recebe 1) um n?, 2) a indica??o do s?mbolo usado
;pelo jogador m?quina [1 ; 2] e 3) dois valores inteiros que representam respetivamente o
;n?mero de caixas fechadas pelo jogador 1 e o n?mero de caixas fechadas pelo jogador 2.
;A fun??o retorna a lista dos sucessores do tabuleiro para o tipo de s?mbolo recebido por
;par?metro. Numa fase mais adiantada do desenvolvimento, esta fun??o poder? receber
;outros par?metros, tal como a profundidade limite de expans?o da ?rvore do jogo.


;; N?o esquecer das trasposition tables - guardar os inputs(hash) - outputs  
(defun sucessores-no (no operadores)
	""
	(let
		(
			(funcao (lambda (op) ;função que irá gerar os nós sucessores para cada operação
							(funcall op no)
					)
			)
		)
		(limpar-nils (mapcar funcao operadores)) ; executa todas as operações e limpa aquelas que não foram aplicadas
	)
)
;(sucessores-no (no-criar (tabuleiro-inicial) nil 0 (list 0 0 *jogador1*) (criar-operacoes 7 7 #'arco-vertical #'arco-horizontal))

;; Nao esquecer de verificar a profundidade para ver se vale a pena ordenar ou não (caso não seja devolve os sucessores)
(defun ordenar (sucessores)
	sucessores
)




