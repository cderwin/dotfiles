#!/bin/bash
# Source the other important files (and add to this as the repo grows)
# We want the functionality included by these files here
source $HOME/.alias
source $HOME/.functions
source $HOME/.exports
source $HOME/.path

# We want to import this and be able to override it
source $HOME/.profile

# This files commands go here

# Initialize rbenv
eval "$(rbenv init -)"

# Enable completion for non-system bash
source $HOME/.git-completion.bash

# Local configs should override everything
source $HOME/.localrc
