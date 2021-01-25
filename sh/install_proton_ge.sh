#! /bin/sh

REPO=GloriousEggroll/proton-ge-custom
VER=$(curl -s https://api.github.com/repos/${REPO}/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
FILE=Proton-${VER}.tar.gz
DST_DIR=${HOME}/.steam/root/compatibilitytools.d

URL="https://github.com/${REPO}/releases/latest/download/${FILE}"
DST_FILE="${DST_DIR}/${FILE}"

curl -fLo ${DST_FILE} --create-dirs ${URL}

tar -xf ${DST_FILE} -C ${DST_DIR}

rm ${DST_FILE}

ln -s "~/.local/share/Steam/compatibilitytools.d/Proton-${VER}/dist/" "~/.local/share/lutris/runners/wine/Proton-latest"
