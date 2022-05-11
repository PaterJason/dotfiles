fish_add_path ~/.npm-packages/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin

set -gx NPM_PACKAGES "$HOME/.npm-packages"

if status --is-interactive
    set -g fish_greeting
end
