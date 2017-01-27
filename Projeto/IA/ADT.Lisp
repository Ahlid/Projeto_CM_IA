
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

