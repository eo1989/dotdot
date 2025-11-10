# shellcheck disable=SC1083,SC1086,SC1090,SC1094,SC2148,SC2153,SC2154,SC2034,SC2086,SC2296,SC2206

export GPG_TTY=$(tty)


export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export VSCODE_SUGGEST=1

typeset -gU path cdpath fpath manpath

# source "${0:A:h}/theme.zsh"
source $ZDOTDIR/theme.zsh

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

# if [[ "$OSTYPE" = "darwin"* ]]; then
ulimit -c unlimited
# fi

export DOTDOT="${HOME}/.dotdot/"
# alias dotdot='/opt/homebrew/bin/git --git-dir="${HOME}/.dotdot/" --work-tree="${HOME}"'
alias dotdot='/opt/homebrew/bin/git --git-dir="${DOTDOT}" --work-tree="${HOME}"'



if [[ "${TERM}" == "xterm-kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
    alias icat='kitten icat'
    alias ssh='kitten ssh'
fi

if exists lesspipe.sh; then
    # LESSOPEN="|lesspipe.sh %s"
    LESSOPEN='| $commands[(i)lesspipe.sh] LESS_ADVANCED_PREPROCESSOR=1 %s 2>&-'
    export LESSOPEN
else
    # source <(lesspipe.sh)
    lesspipe.sh | source /dev/stdin
fi
# export LESS='-R -F -X'

_comp_options+=(globdots) # Include hidden files.

export GOPATH="$HOME/go"
export CARGO_HOME="$HOME/.cargo"

# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PNPM_HOME="/Users/eo/Library/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac



# -z => check if string is empty or not defined
# -n => check if a string is defined and not empty
# -f => check if a file exists
# -d => check if a directory exists

# if [ -d ~/.config/zsh ]; then
if [[ -n "$ZDOTDIR" ]]; then
    setopt +o nomatch
    files=(
        ~/.config/zsh/config/*
        # aliases
        # dashboard
        # homebrew
        # opts
        # zsh_plugins
        # cli_settings
        # completion
        # nav
        # term_utils
        # docs_man
        # git_gh
    )
    setopt -o nomatch
    for filename in "${files[@]}"; do
        if [[ "$filename" =~ ^.+\.z?sh$ && -r $filename ]]; then
            source "$filename"
        fi
    done
    unset filename
fi



# ------------------------------------------------------------------------------
#       ENV VARIABLES
# ------------------------------------------------------------------------------
# PATH.
# (N-/): do not register if the directory does not exists
# (Nn[-1]-/)
#
#  N    : NULL_GLOB option (ignore path if the path does not match the glob)
#  n    : Sort the output
#  [-1] : Select the last item in the array
#  -    : follow the symbol links
#  /    : ignore files
#  t    : tail of the path
# CREDIT: @ahmedelgabri
# -------------------------------------------------------------------------------

# ~/go/bin(N-/)
# ~/.{go,cargo}/bin(N-/)

path=(
    "$BREW_PREFIX"/lib/ruby/gems/*/bin(N-/)
    "$BREW_PREFIX"/opt/{coreutils,findutils,rustup}/libexec/gnubin(N-/)
    "$BREW_PREFIX"/opt/{llvm,curl,ruby,node,sqlite,openjdk}/bin(N-/)
    "$PYENV_ROOT/bin"(N-/)
    "$HOME/.julia/juliaup"(N-/)
    "$HOME/.{yarn,npm}/bin"(N-/)
    "$HOME/.luarocks/bin"(N-/)
    "$PNPM_HOME"/*(N-/)
    "$GOPATH/bin"(N-/)
    "$CARGO_HOME/bin"(N-/)
    "$BREW_PREFIX"/opt/{grep,gnu-{sed,which,tar}}/libexec/gnubin(N-/)
    "$BREW_PREFIX"/opt/gnu-getopt/bin(N-/)
    "$BREW_PREFIX"/{bin,sbin}(N-/)
    /usr/local/{bin,sbin}(N-/)
    /usr/{bin,sbin}(N-/)
    /{bin,sbin}(N-/)
    /usr/local/texlive/2024basic/bin(N-/)
    "$XDG_CONFIG_HOME"/bin(N-/)
    "$XDG_CONFIG_HOME"/fzf/bin(N-/)
    $path
)

eval "$(pyenv init - --path --no-rehash zsh)"
eval "$(pyenv virtualenv-init - zsh)"

# if exists pyenv; then
# eval "$(pyenv init - --path --no-rehash zsh)"
# fi
# if exists luarocks; then
#     eval "$(luarocks --lua-version=5.1 path)"
# fi

path=(
    ~/.local/{bin,share}(N-/)
    $path
)

. "${HOME}/.config/fzf/fzf-config.zsh"


# fpath+=~/.zfunc
# autoload -Uz compinit
# compinit
# zstyle ':completion:*' menu select

# vim: ft=zsh ts=8 sts=4 sw=4 et ai commentstring=#\ %s

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH
