#! /bin/sh

curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
