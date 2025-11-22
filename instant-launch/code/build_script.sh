#!/bin/bash

set -euxo pipefail

build_dir=/build/instant-launch
target_triple=x86_64-unknown-linux-musl

echo "Installing uv..."
export UV_INSTALL_DIR=${build_dir}/.local/bin
bash /code/uv-install.sh

echo "Installing rust toolchain..."
export CARGO_HOME=${build_dir}/.cargo
export RUSTUP_HOME=${build_dir}/.rustup
bash /code/rustup-install.sh -y --target ${target_triple}

echo "Installing rust packages..."
${build_dir}/.cargo/bin/cargo install --target ${target_triple} just nu fd-find ripgrep bat zoxide atuin broot starship

echo "Packaging instant launch dist..."
tar czf /build/dotfiles_il_dist.tgz -C /build/instant-launch/ .
