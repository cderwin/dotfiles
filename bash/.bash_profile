#!/bin/bash
# Source the other important files (and add to this as the repo grows)
# We want the functionality included by these files here
source $HOME/.bash/alias
source $HOME/.bash/functions
source $HOME/.bash/exports
source $HOME/.bash/path
source $HOME/.bash/prompt

# This files commands go here

# Initialize nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Initialize rbenv
[ -d $HOME/.rbenv ] && eval "$(rbenv init -)"

# Initialize ansible
[ -d $HOME/.ansible ] && source $HOME/.ansible/hacking/env-setup > /dev/null 2>&1

# Enable completion for non-system bash
[ -f $HOME/.git-completion.bash ] && source $HOME/.git-completion.bash

# Local configs should override everything
source $HOME/.bash/localrc
