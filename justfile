local:
    if [[ ! -f ".dotter/local.toml" ]]; then \
        echo 'packages = ["base", "nvim", "zsh"]\n' > .dotter/local.toml; \
    fi
