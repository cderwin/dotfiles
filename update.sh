#!/usr/local/bin/bash

FILES=$(cat .manifest)
if git diff-index --quiet HEAD; then
    echo "Copying $fname"
    for fname in $FILES; do
        cp ~/.$fname $fname
    done
else
    echo "There are uncommitted changes in your dotfiles"
fi
