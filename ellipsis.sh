#!/usr/bin/env bash

pkg.link() {
    fs.link_rfiles "$PKG_PATH/bin" "$ELLIPSIS_PATH/bin"
}

pkg.unlink() {
    for file in "$PKG_PATH/bin"/*; do
        rm "$ELLIPSIS_PATH/bin/$(basename $file)"
    done
}