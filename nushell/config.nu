# config.nu
#
# Installed by:
# version = "0.108.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.buffer_editor = "nvim"

use std "path add"
path add /opt/homebrew/bin
path add ~/.local/bin

def l [] { ls | grid -s " " }
alias ll = ls -l

alias g = git
alias gs = git status
alias gd = git diff
alias push = git push
alias pull = git pull

def gradlew --wrapped [...args] {
    mut search_dir = (pwd)
    loop {
        let search_path = $search_dir | path join "gradlew"
        if ($search_path | path exists) {
            run-external $search_path ...$args
            break
        }
    }
}

def --env --wrapped hatchw [...args] {
    mut search_dir = (pwd)
    loop {
        let search_path = $search_dir | path join "hatchw"
        if ($search_path | path exists) {
            run-external $search_path ...$args
            break
        }
    }
}

def notebook [--detach(-d)] {
    if $detach {
        job spawn { uv --directory ~/sandbox/notebooks2 run marimo edit }
        return
    }
    uv --directory ~/sandbox/notebooks2 run marimo edit
}

def __detect_project [name?: string] {
    if $name != null {
        if ($name | str contains "/") {
            let parts = $name | split row "/"
            if ($parts | length) > 2 {
                error
            }

            return { "org": $parts.0, "repo": $parts.1 }
        } else {
            return { "org": "tbd", "repo": $name }
        }
    }

    let git_output = (git remote get-url origin | complete)
    if $git_output.exit_code == 0 {
        ($git_output.stdout | parse "git@{host}:{org}/{repo}" | select org repo).0
    } else {
        { org: "tbd", repo: (pwd | path basename) }
    }
}

def --env "project open" [name?: string] {
    mut fzf_args = []
    if $name != null {
        $fzf_args = [--query $name]
    }
    let project = (ls ~/projects | each {|dir| $dir.name | path relative-to ~/projects } | to text | fzf ...$fzf_args)
    cd $"~/projects/($project)"
}

def "project github" [name?: string] {
    let project = __detect_project $name
    ^open $"https://github.palantir.build/($project.org)/($project.repo)"
}

def "project circle" [name?: string] {
    let project = __detect_project $name
    ^open $"https://app.circle.palantir.build/pipelines/github/($project.org)/($project.repo)"
}

def "project apollo" [name: string group: string = "com.palantir.tbdml"] {
    ^open $'https://apollo.palantircloud.com/workspace/apollo/space/legacy-33ym/catalog/products/($group)/($name)'
}

alias pgh = project github
alias pci = project circle
alias po = project open
alias nb = notebook

source ~/.zoxide.nu
