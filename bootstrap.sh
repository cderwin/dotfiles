#!/usr/bin/env bash

# bootstrap script for dotfiles
# dependencies: curl, bash
# this script installs just and nushell for the target architecture and writes them to bin/

set -euxo pipefail

install_dir=$(pwd)/bin
mkdir -p $install_dir

echo "Installing just"
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to $install_dir

echo "Invoking just bootstrap recipe"
just --shell bash --highlight bootstrap
