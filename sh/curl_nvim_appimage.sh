#! /bin/sh

pkill --echo --uid "$USER" --exact nvim
# curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage --create-dirs -o ~/.local/bin/nvim
curl --location https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage --create-dirs --output ~/.local/bin/nvim
chmod u+x ~/.local/bin/nvim
