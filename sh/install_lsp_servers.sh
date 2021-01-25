#! /bin/sh
npm install -g all-the-package-names vscode-css-languageserver-bin vscode-html-languageserver-bin vscode-json-languageserver vim-language-server typescript typescript-language-server

sudo pacman -S --needed bash-language-server texlab

DST_DIR=${HOME}/bin
# Clojure lsp
URL="https://github.com/snoe/clojure-lsp/releases/latest/download/clojure-lsp"
CLJ_LSP="${DST_DIR}/clojure-lsp"

curl -fLo ${CLJ_LSP} --create-dirs ${URL}
chmod 755 ${CLJ_LSP}
