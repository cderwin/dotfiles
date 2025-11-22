set shell := ["bin/nu", "-c"]

default_packages := '["base", "nvim", "zsh", "nushell"]'
dotter := if os() == "macos" { "dotter.macos" } else { "dotter.linux" }
nu_version := "0.108.0"

bootstrap:
    #!/usr/bin/env bash
    set -euxo pipefail
    os="{{ os() }}"
    if [[ "$os" == "linux" ]]; then
        platform_info="unknown-linux-gnu"
    elif [[ "$os" == "macos" ]]; then
        platform_info="apple-darwin"
    else
        echo "$os is unsupported"
        exit 1
    fi
    nushell_dist="nu-{{ nu_version }}-{{ arch() }}-${platform_info}.tar.gz"
    download_url="https://github.com/nushell/nushell/releases/download/{{ nu_version }}/$nushell_dist"
    tmp_dir=$(mktemp -d)
    curl -L $download_url | tar xz -C $tmp_dir
    mv $tmp_dir/nu*/nu* $(pwd)/bin/
    rm -rf $tmp_dir
    
init-local:
    #!bin/nu
    use std-rfc
    if not (".dotter/local.toml" | path exists) {
        "
        includes = []
        packages = {{ default_packages }}
        
        [files]

        [variables]
        " | std-rfc str unindent | save ".dotter/local.toml"
    }

edit-local: init-local
    nvim .dotter/local.toml

install:
    ./{{ dotter }} deploy

lock:
    uv run main.py lock

unlock:
    uv run main.py unlock


# package installations
# helpers to install cli tools to ~/.local/bin

install-all: install-rustup install-nushell install-just install-uv install-utils install-shellrice

install-rustup:
    #! bin/nu
    if not ("~/.rustup" | path exists) {
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    }

    if not ("~/.cargo/bin/cargo-binstall" | path exists) {
        curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    }

install-just: install-rustup
    cargo binstall just

install-nushell: install-rustup
    cargo binstall nu

install-uv:
    if not ("~/.local/bin/uv" | path exists) { curl -LsSf https://astral.sh/uv/install.sh | sh }

install-utils: install-rustup
    cargo binstall fd-find ripgrep bat 

install-shellrice: install-rustup
    cargo binstall zoxide atuin broot starship

# instant launch distribution of binaries
il-dist:
    docker build --platform linux/amd64 instant-launch -t il-dotfiles-builder
    docker run --rm --platform linux/amd64 -v ./build:/build il-dotfiles-builder

