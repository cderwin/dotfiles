My dotfiles
======

## How to Install

Pretty simple.  Just `make install`.  The only dependency is the [Gnu Stow](https://www.gnu.org/software/stow/) tool for symlink management.

## Dependencies

In general, the following tools are assumed to be installed:
```bash
shells:
- nushell*
- zsh^

shell ehancements:
- zoxide*
- atuin*
- broot*
- starship*

unix-rs tools:
- fzf^
- fd*
- rg*
- bat*

tools:
- nvim^
- git^

language tools:
- uv*
- rustup*
- just*
```

Tools marked with * have a corresponding `install-$tool` just target, and these can be installed in bulk via `just install-all`.
Tools marked with ^ are expected to isntall via package manager (brew, apt, etc.).
