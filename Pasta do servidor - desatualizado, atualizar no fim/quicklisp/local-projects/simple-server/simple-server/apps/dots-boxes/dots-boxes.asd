;;;; dots-boxes.asd

(asdf:defsystem #:dots-boxes
  :serial t
  :depends-on ("simple-server" "cl-json" "drakma")
  :components ((:file "dots-boxes")(:file "alfabeta")(:file "jogo")(:file "pontosecaixas")))

