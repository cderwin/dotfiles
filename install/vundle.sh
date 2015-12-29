#!/usr/bin/env bash

if ! which git; then
    echo "Git is not installed; vundle depends on git.  If you believe it is already installed, make sure its executable is installed on the path"
    exit 1
fi

if [ ! -d ~/.vim/bundle ]; then
    echo "Directory \"~/.vim/bundle\" does not exist, creating it."
    mkdir -p ~/.vim/bundle
fi

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Vundle has been installed"
