;;; dots-boxes.lisp
;;; Definicao de um serviço web para o jogo dos pontos e das caixas, comum com a disciplina de computação móvel. O serviço web é baseado no servidor Aserve e na framework Simple Server.  Permite criar uma aplicação web baseada em JSON.
;;; Adapted from https://www.cs.northwestern.edu/academics/courses/325/readings/web-services.php#simple-server
;;; JSON server built on Simple Server
;;;
;;; Defines STOP-SERVER and PARAM-VALUE
;;; Needs server-specific implementations of DEFROUTE and START-SERVER

(defpackage #:dots-boxes
  (:use #:common-lisp #:json #:simple-server))

(in-package :dots-boxes)

;;;
;;; Key parts:
;;;   - static HTML5 files (HTML, CSS, JavaScript, images, ...)
;;;   - JavaScript in browser sends and gets JSON from the server, using AJAX
;;;   - Lisp code on server gets data from request parameters and JSON, and returns JSON
;;;
;;;
;;; One form lets a user store a key-value pair on the server, and get back a JSON
;;; object with all stored key value pairs. This example illustrates sending data in JSON form.
;;;



;;; Publishing routes to JSON endpoints
;;; -----------------------------------


;;; POST /save-data?name=... + JSON data
;;;   Push the list equivalent of the JSON data in the global Lisp
;;;   variable name
;;;   Return the new list of stored values.

(defroute :post "/save-data" 'save-data)

(defvar *alist* nil)

(defun save-data (data params)
  (encode-json-alist-to-string (update-alist (get-json-from-string data))))

(defun get-json-from-string (str)
  (and str (stringp str) (> (length str) 0)
       (decode-json-from-string str)))

(defun update-alist (alist)
  "Atualiza a lista com a jogada da maquina"
  (setq *alist*  (formatar-saida (jogar alist))))


(defun formatar-saida (tabuleiro)
  "Permite formatar o tabuleiro com a jogada do PC antes de ser transformado numa string JSON"
    (list (list ':tabuleiro (get-arcos-horizontais tabuleiro) (get-arcos-verticais tabuleiro)))
  )


;;; ------------------------------
;;; Jogada da maquina
;;; O código a seguir deverá ser alterado para permitir jogadas com o algoritmo AlfaBeta
;;; A funcao jogar é o ponto de entrada para a execução da jogada da maquina
;;; ------------------------------

;;; faz jogada aleatoria nos arcos horizontais
(defun jogar (jogada-anterior)
    "Efetua uma jogada aleatoria nos arcos horizontais para o jogador maquina com base nos dados do jogo recebidos: tabuleiro, peca da maquina,
     numero de caixas do jogador com as pecas 1 e numero de caixas do jogador com as pecas 2."
    (let*
		(
		  (peca (get-peca-maquina jogada-anterior))
		  (tabuleiro (get-tabuleiro jogada-anterior))
		  (caixas-j1 (cdr (fourth (car jogada-anterior))))
		  (caixas-j2 (cdr (fifth (car jogada-anterior))))
		  (no-jogada-maquina (escolher-jogada (no-criar tabuleiro nil 0 (list 0 0 (trocar-peca peca) nil (n-arestas-preenchidas tabuleiro))) 4000))
		)
        (no-estado no-jogada-maquina)
    )
  )


  ;;; Manipulacao dos dados do jogo
  (defun get-tabuleiro (jogada-anterior)
    "Retorna o tabuleiro a partir dos dados do jogo recebidos"
    (list (second (cadar jogada-anterior)) (third (cadar jogada-anterior)))
  )

  (defun get-numero-caixas (jogada-anterior)
    "Retorna o numero de caixas fechadas no tabuleiro a partir dos dados do jogo recebidos"
    (+ (cdr (fourth (car jogada-anterior))) (cdr (fifth (car jogada-anterior))))
  )

  (defun get-peca-maquina (jogada-anterior)
    "Retorna o simbolo (1 ou 2)com o qual a maquina joga"
    (cdr (third (car jogada-anterior)))
  )

  ;;; Manipulacao do tabuleiro

  (defun get-arcos-horizontais (tabuleiro)
    "Retorna a lista dos arcos horizontais de um tabuleiro"
    (car tabuleiro)
  )

  (defun get-arcos-verticais (tabuleiro)
    "Retorna a lista dos arcos verticiais de um tabuleiro"
    (cadr tabuleiro)
  )

  (defun arco-na-posicao (indice peca lista &aux (casa (nth indice lista)))
    "Recebe uma lista de arcos e insere um arco na posicao indice.
    So insere o arco se nao existir nenhum arco no indice da lista"
    (cond
      (casa nil)
      (T (inserir-na-lista (1- indice) peca lista))
    )
  )

  (defun arco-aux (x y peca arcos)
    "Recebe uma matriz de arcos e insere um arco na posicao x y"
    (let*
      (
        (lista (get-elemento-lista (1- x) arcos))
        (nova-lista (arco-na-posicao y peca lista))
      )
      (cond
        ((null nova-lista) nil)
        (T (inserir-na-lista (1- x) nova-lista arcos))
      )
    )
  )

  (defun get-elemento-lista (indice lista)
    "Retorna o elemento de uma lista de acordo com índice i"
    (cond
      ( (null lista) nil )
      ( (zerop indice) (car lista) )
      ( T (get-elemento-lista (1- indice) (cdr lista)))
    )
  )

  (defun arco-horizontal (x y peca tabuleiro)
    "Recebe par de coordenadas, uma peca e um tabuleiro.
    Retorna um novo tabuleiro onde foi inserido um arco na posição x y dos arcos horizontais. "
    (let*
      (
        (arcos-horizontais (get-arcos-horizontais tabuleiro))
        (novos-arcos-horizontais (arco-aux x y peca arcos-horizontais))
      )
      (cond
        ((null novos-arcos-horizontais) nil)
        (t (inserir-na-lista 0 novos-arcos-horizontais tabuleiro))
      )
    )
  )

  (defun arco-vertical (x y peca tabuleiro)
    "Recebe par de coordenadas, uma peca e um tabuleiro.
    Retorna um novo tabuleiro onde foi inserido um arco na posição x y dos arcos verticas. "
    (let*
      (
        (arcos-verticais (get-arcos-verticais tabuleiro))
        (novos-arcos-verticais (arco-aux x y peca arcos-verticais))
      )
      (cond
        ( (null novos-arcos-verticais) nil)
        ( t (inserir-na-lista 1 novos-arcos-verticais tabuleiro) )
      )
    )
  )

  (defun inserir-na-lista (indice elemento lista)
    "Insere um elemento numa lista, de acordo com indice.
    O elemento, o indice e a lista sao recebidos por parametro."
    (cond
          ( (null lista) nil )
      ( (zerop indice) (cons elemento (cdr lista)) )
      ( t (cons (car lista) (inserir-na-lista (1- indice) elemento (cdr lista))) )
    )
  )

  