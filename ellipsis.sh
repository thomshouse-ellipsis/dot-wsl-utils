#!/usr/bin/env bash

pkg.install() {
    # Check for eligible .rc files
    for rcfile in .bashrc .zshrc .localrc; do
        # For each file, check to see if it exists, is not symlinked, and does not source ellipsis init
        if [[ -f "$HOME/$rcfile" && ! -L "$HOME/$rcfile" && ! $(grep -Fxq "pwd [|].*mnt//.//Users/.*&&cd" "$HOME/$rcfile") ]]; then
            # Ask to add the init script to each valid file
            # Add to the script if selected
            echo -e '\n# Redirect from WSL default directory since linux fs is faster' >> "$HOME/$rcfile"
            echo -e 'pwd | grep -e "^/mnt/./Users/[^/]+?$" >/dev/null 2>&1 && cd' >> "$HOME/$rcfile"
            echo -e 'echo "$OLDPWD" | grep -e "^/mnt/./Users/[^/]+?$" >/dev/null 2>&1 && cd\n' >> "$HOME/$rcfile"
        fi
    done
}

pkg.link() {
    fs.link_rfiles "$PKG_PATH/bin" "$ELLIPSIS_PATH/bin"
}

pkg.unlink() {
    for file in "$PKG_PATH/bin"/*; do
        rm "$ELLIPSIS_PATH/bin/$(basename $file)"
    done
}