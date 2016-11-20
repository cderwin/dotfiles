#!/bin/bash

CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

[ -d $CONFIG_HOME ] || mkdir -p $CONFIG_HOME

[ -d $HOME/.vim ] || mkdir -p $HOME/.vim
[ -d $CONFIG_HOME/nvim ] || ln -sf $HOME/.vim $CONFIG_HOME/nvim

[ -f $HOME/.vimrc ] || touch $HOME/.vimrc
[ -d $CONFIG_HOME/nvim/init.vim ] || ln -s $HOME/.vimrc $CONFIG_HOME/nvim/init.vim
