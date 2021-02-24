#! /bin/sh
npm install -g all-the-package-names bash-language-server vscode-css-languageserver-bin vscode-html-languageserver-bin vscode-json-languageserver vim-language-server typescript typescript-language-server yaml-language-server

sudo pacman -S --needed texlab

yay -S --needed clojure-lsp-bin lua-language-server
