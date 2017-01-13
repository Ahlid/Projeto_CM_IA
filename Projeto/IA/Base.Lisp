;;;;       Programa do apoio ao jogo dos pontos e das caixas
;;;;       Apos ter desenvolvido as funcoes pedidas no enunciado
;;;;       utilize a funcao fazer-uma-partida para jogar.

;;;;
;;;; Constantes:
;;;;
 (defvar *jogador2* 2)
 (defvar *jogador1* 1)



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
  '(
    ((NIL NIL NIL 2 1 NIL NIL) (NIL NIL NIL NIL 2 1 2)
    (1 2 1 2 2 2 NIL) (2 NIL NIL NIL 1 2 NIL)
    (2 2 NIL NIL 2 1 NIL) (2 2 NIL 1 1 2 NIL)
    (2 2 NIL 2 1 1 NIL) (1 1 NIL 1 2 2 NIL))
    ((NIL NIL NIL 1 1 1 1) (NIL NIL NIL 1 1 1 1)
    (NIL 1 NIL NIL 1 1 2) (NIL 2 1 NIL 1 2 1)
    (1 NIL NIL 1 NIL NIL NIL) (1 NIL NIL 1 1 NIL NIL)
    (NIL NIL 1 1 NIL NIL NIL) (NIL 2 1 2 1 NIL 2))
  )
)
;;; Funcoes para imprimir um tabuleiro
;;; ----------------------------------

(defun converte-arco-horizontal (v)
  "Converte os inteiros dos arcos horizontais para os simbolos --- (jogador com peca 1) e ... (jogador com peca 2)"
  (cond ((equal v 1) "___")
        ((equal v 2) "...")
        (t "   ")))

(defun converte-arco-vertical (v)
  "Converte os inteiros dos arcos verticais para os simbolos | (jogador com peca 1) e  . (jogador com peca 2) "
  (cond ((equal v 1) "|  ")
        ((equal v 2) ".  ")
        (t "   ")))

(defun imprime-linha (lista)
  "Imprime uma linha formatada do tabuleiro"
  (format t ". ~A . ~A . ~A . ~A . ~A . ~A . ~A . ~%"
          (converte-arco-horizontal (first lista))
          (converte-arco-horizontal (second lista))
          (converte-arco-horizontal (third lista))
          (converte-arco-horizontal (fourth lista))
          (converte-arco-horizontal (fifth lista))
          (converte-arco-horizontal (sixth lista))
          (converte-arco-horizontal (seventh lista))
          (converte-arco-horizontal (eighth lista))
))

(defun imprime-arcos-horizontais (lista)
(mapcar #'(lambda (linha) (imprime-linha linha) ) lista)
)

(defun imprime-coluna (lista)
  "Imprime uma linha formatada do tabuleiro"
  (format t "~A   ~A   ~A   ~A   ~A   ~A   ~A   ~A  ~%"
          (converte-arco-vertical (first lista))
          (converte-arco-vertical (second lista))
          (converte-arco-vertical (third lista))
          (converte-arco-vertical (fourth lista))
          (converte-arco-vertical (fifth lista))
          (converte-arco-vertical (sixth lista))
          (converte-arco-vertical (seventh lista))
          (converte-arco-vertical (eighth lista))

))
;; (imprime-tabuleiro (tabuleiro-teste))
(defun imprime-tabuleiro (tabuleiro)
  "Imprime o tabuleiro, linha a linha"
  (let ((linhas (first tabuleiro)) (colunas (rodar (second tabuleiro))))
    (mapcar #'(lambda (linha coluna) (progn (imprime-linha linha) (imprime-coluna coluna) (imprime-coluna coluna))) linhas colunas)
  )
)

(defun rodar (matriz)
  (apply #'mapcar #'list matriz))

  
;(defun faz-jogada (jogador x y tabuleiro)
 ; (cond ((null tabuleiro) nil)
 ;       ((= pos 0) (cons jogador (rest tabuleiro)))
 ;       (t (cons (first tabuleiro) (faz-jogada jogador (1- pos) (rest tabuleiro))))))

;;; Funcoes para o jogo
;;; ----------------------------------


	  
(defun faz-jogada (tabuleiro peca operador x y)
  "Faz uma jogada com base numa das duas operacoes posiveis, num tabuleiro, uma peca com a qual jogar e duas coordenadas recebidos por parametro."
  (funcall operador tabuleiro peca (1- x) (1- y) )
)





;(defun tabuleiro-preenchido-p  (tabuleiro)
;  "Verifica se o tabuleiro ja esta completamente preenchido"
;)


;;;;
;;;; funcoes de jogo (humano e computador c/minimax)
;;;;



(defun vencedor-p (caixas-jogador1 caixas-jogador2)
  "Determina se existe um vencedor. Se existir devolve o jogador que venceu. Senao devolve NIL."
	(cond
		(
			((>= caixas-jogador1 25) *jogador1*)
			((>= caixas-jogador2 25) *jogador2*)
			(T NIL)
		)
	)
)

(defun trocar-peca (peca)
  "Troca a peca de um jogador para a peca de outro jogador."
  (cond
    ((= peca *jogador1*) *jogador2*)
    ((= peca *jogador2*) *jogador1*)
    )
)










