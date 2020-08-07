# Dotfiles
This is a dotfiles repository

## Install packages
In the `pkglists` directory:
```sh
cat * | sudo pacman -S --needed -
```

## Symlink dotfiles
In the `dot` directory:
```sh
stow *
```

## etc
Copy `etc` files into `/etc/`
