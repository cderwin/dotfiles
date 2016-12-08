#!/bin/bash

mkdir -p $HOME/.ssh/cfg
ssh_keygen -t ed25519 -N "" -q -f ~/.ssh/id_ed25519
