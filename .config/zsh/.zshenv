# shellcheck disable=SC1083,SC1086,SC1090,SC1091,SC1094,SC2148,SC2153,SC2154,SC2034,SC2086,SC2296,SC2206

# ------------------------------------------------------------------------------
#       ENV VARIABLES
# ------------------------------------------------------------------------------
# PATH.
# (N-/): do not register if the directory does not exists
# (Nn[-1]-/)
#
#  N   : NULL_GLOB option (ignore path if the path does not match the glob)
#  n   : Sort the output
#  [-1]: Select the last item in the array
#  -   : follow the symbol links
#  /   : ignore files
#  t   : tail of the path
# CREDIT: @ahmedelgabri
# -------------------------------------------------------------------------------

exists() { (( $+commands[$1])); }

# This gets sourced ahead of .zprofile regardless of whether the shell is interactive or not. Only difference
# to consider is if it's a login or non-login shell.
# [ -f /opt/homebrew/bin/brew ]
# if [[ $(uname -p) == "arm" ]]; then
#     eval "$(/opt/homebrew/bin/brew shellenv)" # M<1-#> Mac
# else
#     eval "$(/usr/local/bin/brew shellenv)" # Intel Mac
# fi

unsetopt GLOBAL_RCS

# `(( ${+*} ))` == if variable is set dont set it anmyore, or use `[[ -z ${*} ]]`
(( ${+LANG} )) || export LANG="en_US.UTF-8"
(( ${+LC_ALL} )) || export LC_ALL="en_US.UTF-8"
(( ${+LC_CTYPE} )) || export LC_CTYPE="en_US.UTF-8"
(( ${+BREW_PREFIX} )) || export BREW_PREFIX="/opt/homebrew"
(( ${+DYLD_FALLBACK_LIBRARY_PATH} )) || export DYLD_FALLBACK_LIBRARY_PATH="${BREW_PREFIX}/lib:${DYLD_FALLBACK_LIBRARY_PATH}"
(( ${+EDITOR} )) || export EDITOR="${BREW_PREFIX/bin/nvim}":-"${BREW_PREFIX}/bin/code-insiders"
(( ${+JUPYTER_CONFIG_DIR} )) || export JUPYTER_CONFIG_DIR="${JUPYTER_CONFIG_DIR:-$HOME}/.jupyter"
(( ${+SHELL} )) || export SHELL="${BREW_PREFIX}/bin/zsh"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
(( ${+ZDOTDIR} )) || export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
(( ${+ZSH_CACHE_DIR} )) || export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"

# setopt no_global_rcs
# typeset -U path PATH fpath FPATH manpath MANPATH
# export -UT INFOPATH infopath # -T creates a "tied" pair

# path=(
#     ~/.local/{bin,share}(N-/)
#     $BREW_PREFIX/opt/{coreutils,findutils,rustup,node}/libexec/gnubin(N-/)
#     $BREW_PREFIX/opt/{llvm,curl,ruby}/bin(N-/)
#     ~/.julia/juliaup(N-/)
#     ~/.{yarn,npm}/bin(N-/)
#     ~/go/bin(N-/)
#     ~/.{go,cargo}/bin(N-/)
#     $BREW_PREFIX/opt/{grep,gnu-{sed,which,tar}}/libexec/gnubin(N-/)
#     $BREW_PREFIX/opt/gnu-getopt/bin(N)
#     $BREW_PREFIX/{bin,sbin}(N-/)
#     /usr/local/{bin,sbin}(N-/)
#     /usr/local/texlive/2024basic/bin(N-/)
#     $path
# )

# /opt/homebrew/opt/grep/libexec/gnubin(N)

# export PYENV_ROOT=~/.pyenv
# [[ -d $PYENV_ROOT/bin ]] && export PATH="${PYENV_ROOT}/bin:$PATH"
# if exists pyenv; then
#   eval "$(pyenv init --path zsh)"
#   eval "$(pyenv init - --no-rehash zsh)"
#   eval "$(pyenv virtualenv-init - zsh)"
# fi

# export PATH=$HOME/.local/bin:/Applications/quarto/bin:$PATH

# vim: ft=zsh sw=4 ts=4 sts=4 et ai:
