# vim:ft=zsh sw=4 ts=4 sts=4 et ai
# shellcheck disable=SC1090,SC1094,SC2148,SC2153,SC2034,SC2086,SC2296
#
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
#
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath # -T creates a "tied" pair
unsetopt GLOBAL_RCS
setopt noglobalrcs

exists() { (( $+commands[$1])); }

# This gets sourced ahead of .zprofile regardless of whether the shell is interactive or not. Only difference
# to consider is if it's a login or non-login shell.
# [ -f /opt/homebrew/bin/brew ]
# if [[ $(uname -p) == "arm" ]]; then
#     eval "$(/opt/homebrew/bin/brew shellenv)" # M<1-#> Mac
# else
#     eval "$(/usr/local/bin/brew shellenv)" # Intel Mac
# fi

# (( ${+*} )) = if variable is set dont set it anmyore, or use [[ -z ${*} ]]
(( ${+LANG} )) || export LANG="en_US.UTF-8"
(( ${+LC_ALL} )) || export LC_ALL=${LANG}
(( ${+LC_CTYPE} )) || export LC_CTYPE=${LANG}
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="$HOME/.config"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="$HOME/.cache"
(( ${+BREW_PREFIX} )) || export BREW_PREFIX="/opt/homebrew"
(( ${+ZDOTDIR} )) || export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
(( ${+ZSH_CACHE_DIR} )) || export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
(( ${+SHELL} )) || export SHELL="$BREW_PREFIX/bin/zsh"
(( ${+INFOPATH} )) || export INFOPATH="$BREW_PREFIX/share/info:${INFOPATH:-}"
(( ${+MANPATH} )) || export MANPATH=":${MANPATH#:}"
(( ${+EDITOR} )) || export EDITOR="$HOME/.local/share/bob/nightly/bin/nvim"
(( ${+JUPYTER_CONFIG_DIR} )) || export JUPYTER_CONFIG_DIR="${JUPYTER_CONFIG_DIR:-$XDG_CACHE_HOME/jupyter}"


path=(
    $HOME/.local/{bin,share}(N-/)
    /Applications/quarto/bin(N-/)
    $BREW_PREFIX/opt/{coreutils,findutils}/libexec/gnubin(N-/)
    $BREW_PREFIX/opt/{curl,ruby}/bin(N-/)
	$BREW_PREFIX/{s,}bin(N-/)
    $path
)

# $BREW_PREFIX/opt/curl/bin(N-/)
# $BREW_PREFIX/opt/findutils/libexec/gnubin(N-/)
# $BREW_PREFIX/sbin(N-/)

export PYENV_ROOT=~/.pyenv

[[ -d $PYENV_ROOT/bin ]] && export PATH="${PYENV_ROOT}/bin:$PATH"

if exists pyenv; then
  eval "$(pyenv init --path zsh)"
  eval "$(pyenv init - --no-rehash zsh)"
  eval "$(pyenv virtualenv-init - zsh)"
fi

path+=(
    /usr/local/{bin,sbin}(N-/)   # may need to set GLOBAL_RCS due to the stupid path-helper
	~/.{npm,yarn}/bin(N-/)
)
