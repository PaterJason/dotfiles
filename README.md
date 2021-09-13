# Dotfiles
This is a dotfiles repository

## Shorcuts
[Neovim config](stow/nvim/.config/nvim)

## Install packages
In the `pkglists` directory:
```sh
cat * | yay -S --needed -
```

## Symlink dotfiles
In the `stow` directory:
```sh
stow *
```

## Global config
Copy `etc` files into `/etc/`
