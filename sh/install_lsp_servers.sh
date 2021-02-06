#! /bin/sh
npm install -g all-the-package-names vscode-css-languageserver-bin vscode-html-languageserver-bin vscode-json-languageserver vim-language-server typescript typescript-language-server

sudo pacman -S --needed bash-language-server texlab

yay -S clojure-lsp-bin lua-language-server-git
