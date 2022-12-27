# Handful of useful functions ive found across the interwebs
# - Akinsho/dotfiles
# -jdsimcoe/dotfiles/blob/master/.zshrc

function port () {
  lsof -n -i ":@" | grep LISTEN
}

# helper fx to run a diff against a branch & exclude a file
function gdmin() {
  local branchname=${1:-develop}
  local ignore=${2:-package\-lock.json}
  git diff $branchname -- ":(exclude)"$ignore
}

palette() {
  local -a colors
  for i in {0..255}
  do
    colors+=("%F{$i}$i%f")
  done
  print -cP colors
}

function colours() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}m colour${i}"
    if (( $i % 5 == 0 )); then
      printf "\n"
    else
      printf "\t"
    fi
  done
}

## Use Brewfile, but this as backup.
build-nvim() {
  neovim_dir="$PROJECTS_DIR/eo_contrib/neovim"
  [ ! -d $neovim_dir ] && git clone git@github.com:neovim/neovim.git $neovim_dir
  pushd $neovim_dir
  git checkout master
  git pull upstream master
  [ -d "$neovim_dir/build/" ] && rm -r ./build/  # to clear the cmake cache
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/dev/eo_contrib/neovim"
  make install
  popd || exit
}

fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# ALT-I - Paste the selected entry from locate output into the command line
fzf-locate-widget() {
    local selected
    if selected=$(locate / | fzf -q "$LBUFFER"); then
        LBUFFER=$selected
    fi
    zle redisplay
}
zle     -N    fzf-locate-widget
bindkey '\ei' fzf-locate-widget

# quickly add & remove '.bak' to files
bak() {
    for file in "$@"; do
        if [[ $file =~ \.bak ]]; then
            mv -iv "$file" "$(basename "${file}" .bak)"
        else
            mv -iv "$file" "${file}.bak"
        fi
    done
}

# quickly duplicate things
dup() {
    for file in "$@"; do
        cp -f "$file" "${file}.dup"
    done
}


spotlight() { mdfind "kMDItemDisplayName == \"$*\" wc"; } # \"$@\"

hdi(){ howdoi "$*" -c -n 5; }
