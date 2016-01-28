#!/bin/bash
# Source the other important files (and add to this as the repo grows)
# We want the functionality included by these files here
source $HOME/.alias
source $HOME/.functions
source $HOME/.exports
source $HOME/.path
source $HOME/.bash_prompt

# We want to import this and be able to override it
source $HOME/.profile

# This files commands go here

# Initialize rbenv
[ -d $HOME/.rbenv ] && eval "$(rbenv init -)"

# Initialize ansible
[ -d $HOME/.ansible ] && source $HOME/.ansible/hacking/env-setup > /dev/null 2>&1

# Initialize autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Enable completion for non-system bash
[ -f $HOME/.git-completion.bash ] && source $HOME/.git-completion.bash

# Local configs should override everything
source $HOME/.localrc
