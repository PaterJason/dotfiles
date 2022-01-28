set -gx NPM_PACKAGES "$HOME/.npm-packages"

fish_add_path ~/.npm-packages/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin

# set -gx MANPATH $NPM_PACKAGES/share/man $MANPATH
if status --is-interactive
    source ~/.local/share/nvim/site/pack/packer/start/tokyonight.nvim/extras/fish_tokyonight_night.fish
    set -g fish_greeting
end
