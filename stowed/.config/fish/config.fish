fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
set -gx NPM_PACKAGES "$HOME/.npm-packages"
fish_add_path ~/.npm-packages/bin

if status is-interactive
    set -g fish_greeting
    fish_vi_key_bindings
    fish_vi_cursor

    if not type -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        cat ~/.config/fish/fish_plugins | fisher install
    end

    fish_config theme choose "Catppuccin Latte"
end

if type -q direnv
    direnv hook fish | source
end
