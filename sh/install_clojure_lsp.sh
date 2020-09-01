#! /bin/sh

REPO=snoe/clojure-lsp
FILE=clojure-lsp
DST_DIR=${HOME}/bin

URL="https://github.com/${REPO}/releases/latest/download/${FILE}"
DST_FILE="${DST_DIR}/${FILE}"

curl -fLo ${DST_FILE} --create-dirs ${URL}
chmod 755 ${DST_FILE}
