# shellcheck disable=SC1083,SC1086,SC1090,SC1091,SC1094,SC2148,SC2153,SC2154,SC2034,SC2086,SC2296,SC2206


# exists() { (( $+commands[$1])); }

unsetopt GLOBAL_RCS

# export ZDOTDIR=${XDG_CONFIG_HOME:=~/.config}/zsh

# `(( ${+*} ))` == if variable is set dont set it anmyore, or use `[[ -z ${*} ]]`
(( ${+LANG} )) || export LANG="en_US.UTF-8"
(( ${+LC_ALL} )) || export LC_ALL="en_US.UTF-8"
(( ${+LC_CTYPE} )) || export LC_CTYPE="en_US.UTF-8"
(( ${+BREW_PREFIX} )) || export BREW_PREFIX="/opt/homebrew"
# (( ${+DYLD_FALLBACK_LIBRARY_PATH} )) || export DYLD_FALLBACK_LIBRARY_PATH="${BREW_PREFIX}/lib:${DYLD_FALLBACK_LIBRARY_PATH}"
(( ${+EDITOR} )) || export EDITOR="${BREW_PREFIX}/bin/nvim:-${BREW_PREFIX}/bin/code-insiders"
(( ${+JUPYTER} )) || export JUPYTER="${HOME}/.local/pipx/venvs/jupyterlab/bin/jupyter"
(( ${+JUPYTER_CONFIG_DIR} )) || export JUPYTER_CONFIG_DIR="${JUPYTER_CONFIG_DIR:-$HOME}/.jupyter"
(( ${+SHELL} )) || export SHELL="${BREW_PREFIX}/bin/zsh"
(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
(( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
(( ${+ZDOTDIR} )) || export ZDOTDIR="${XDG_CONFIG_HOME:=$HOME/.config}/zsh"
(( ${+ZSH_CACHE_DIR} )) || export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"

# for julia
(( ${+JULIA_PROJECT} )) || export JULIA_PROJECT=@.
(( ${+JULIA_CONDAPKG_BACKEND} )) || export JULIA_CONDAPKG_BACKEND="Null"
(( ${+JULIA_PYTHONCALL_EXE} )) || export JULIA_PYTHONCALL_EXE="/Users/eo/.pyenv/shims/python"


# ${X:=Y} specifies a default value Y to use for parameter X, if X has not been
# set or is null. This will actually create X, if necessary, and assign the
# value to it.
# To set a default value that is returned *without* setting X, use ${X:-Y}
# instead.
# As in other shells, ~ expands to $HOME _at the beginning of a value only._


# Prevent /etc/zshrc_Apple_Terminal from running some unnecessary code.
export SHELL_SESSIONS_DISABLE=1

# vim: ft=zsh sw=4 ts=4 sts=4 et ai:
