#! /bin/sh

pkill --echo --uid "$USER" --exact nvim
# curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage --create-dirs -o ~/.local/bin/nvim
curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage --create-dirs -o ~/.local/bin/nvim
chmod u+x ~/.local/bin/nvim
