# fzf
if type -q fzf
  fzf_key_bindings
end
if type -q fd
  set -gx FZF_DEFAULT_COMMAND "fd --type f"
  set -gx FZF_CTRL_T_COMMAND "fd"
  set -gx FZF_ALT_C_COMMAND "fd --type d"
end
if type -q tree
  set -gx FZF_ALT_C_OPTS "--preview 'tree -C {} | head -200'"
end
if type -q bat && type -q tree
  set -gx FZF_CTRL_T_OPTS "--preview 'bat --line-range :200 {} 2> /dev/null|| tree -C {} | head -200'"
end

if type -q bat
  set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

eval (dircolors -c)

# neovim
if type -q nvim
  set -gx EDITOR nvim
  set -gx VISUAL nvim
  # set -gx MANPAGER "nvim +Man!"
end

if test -d ~/bin
  set -gx PATH ~/bin $PATH
end
