if [[ $(uname -p) == "arm" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

export BREW_PREFIX="$(brew --prefix)"

# path=(
#     "$BREW_PREFIX/opt/ruby/bin"
#     "$BREW_PREFIX/opt/coreutils/libexec/gnubin"
#     $path
# )

export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"

# export MANPATH="$BREW_PREFIX/opt/coreutils/libexec/gnuman:${MANPATH}"
