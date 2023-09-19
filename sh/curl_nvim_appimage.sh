#! /bin/sh

mkdir -pv ~/.local/bin
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim
chmod u+x ~/.local/bin/nvim
