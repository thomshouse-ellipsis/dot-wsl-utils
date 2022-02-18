#!/usr/bin/env bash

pkg.install() {
    # Check for eligible .rc files
    for rcfile in .bashrc .zshrc .localrc; do
        # For each file, check to see if it exists, is not symlinked, and does not source ellipsis init
        if [[ -f "$HOME/$rcfile" && ! -L "$HOME/$rcfile" && ! $(grep -E "pwd [|].*mnt/.+/Users/.*&& cd" "$HOME/$rcfile") ]]; then
            # Ask to add the init script to each valid file
            # Add to the script if selected
            echo -e '\n# Redirect from WSL default directory since linux fs is faster' >> "$HOME/$rcfile"
            echo -e 'pwd | grep -E "^/mnt/./Users/[^/]+?$" >/dev/null 2>&1 && cd' >> "$HOME/$rcfile"
            echo -e 'echo "$OLDPWD" | grep -E "^/mnt/./Users/[^/]+?$" >/dev/null 2>&1 && cd\n' >> "$HOME/$rcfile"
        fi
    done

    # Remove old links
    pkg.unlink

    # Initialize package
    pkg.init
}

pkg.init() {
    # Add ellipsis bin to $PATH if it isn't there
    if [ ! "$(command -v wudo)" ]; then
        export PATH=$PKG_PATH/bin:$PATH
    fi
}

pkg.link() {
    : # Package does not contain linkable files
}

pkg.unlink() {
    for file in "$PKG_PATH/bin"/*; do
        if [[ -f "$ELLIPSIS_PATH/bin/$(basename $file)" && -L "$ELLIPSIS_PATH/bin/$(basename $file)" ]]; then
            rm "$ELLIPSIS_PATH/bin/$(basename $file)"
        fi
    done
}
