# Dotfiles
This is a dotfiles repository

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
