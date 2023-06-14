fish_add_path ~/.npm-packages/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin

set -gx NPM_PACKAGES "$HOME/.npm-packages"

if status --is-interactive
    set -g fish_greeting

    if not type -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end
end

if type -q direnv
    direnv hook fish | source
end
