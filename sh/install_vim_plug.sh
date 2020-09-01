#! /bin/sh

REPO=junegunn/vim-plug
FILE=plug.vim
DST_DIR=${HOME}/.local/share/nvim/site/autoload

URL="https://raw.githubusercontent.com/${REPO}/master/${FILE}"
DST_FILE="${DST_DIR}/${FILE}"

curl -fLo ${DST_FILE} --create-dirs ${URL}
