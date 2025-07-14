if [[ $(uname -p) == "arm" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

export BREW_PREFIX="/opt/homebrew"

# path=(
#     "$BREW_PREFIX/opt/ruby/bin"
#     "$BREW_PREFIX/opt/coreutils/libexec/gnubin"
#     $path
# )

# export PAGER="$BREW_PREFIX/bin/less -R"
# export MANPAGER='sh -c "col -b | bat -pl man"'

# export LESSOPEN='| $commands[(i)lesspipe.sh] LESS_ADVANCED_PREPROCESSOR=1 %s 2>&-'
# export LESSOPEN="|lesspipe.sh %s"
# LESSOPEN="|lesspipe.sh %s"; export LESSOPEN

export DYLD_FALLBACK_LIBRARY_PATH="${BREW_PREFIX}/lib:${DYLD_FALLBACK_LIBRARY_PATH}"

(( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
# (( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
(( ${+ZDOTDIR} )) || export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
(( ${+ZSH_CACHE_DIR} )) || export ZSH_CACHE_DIR="${HOME}/.cache/zsh"

# export MANPATH="$BREW_PREFIX/opt/coreutils/libexec/gnuman:${MANPATH}"
