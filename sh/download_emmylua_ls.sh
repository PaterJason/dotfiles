#! /bin/sh

gh release download --pattern 'emmylua_ls-linux-x64.tar.gz' --repo 'EmmyLuaLs/emmylua-analyzer-rust' -O - | tar -xzvf - -C ~/.local/bin/
emmylua_ls --version
