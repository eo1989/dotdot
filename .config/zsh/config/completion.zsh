#-------------------------------------------------------------------------------
# References:
#-------------------------------------------------------------------------------
# Color table - https://jonasjacek.github.io/colors/
# Wincent's dotfiles - https://github.com/wincent/wincent/blob/d6c52ed552/aspects/dotfiles/files/.zshrc
# https://github.com/vincentbernat/zshrc/blob/d66fd6b6ea5b3c899efb7f36141e3c8eb7ce348b/rc/vcs.zsh

# DOCS
# official docs             https://zsh.sourceforge.io/Guide/zshguide06.html
# zstyle                    https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Standard-Styles
# good guide                https://thevaluable.dev/zsh-completion-guide-examples/
# zsh-autocomplete config   https://github.com/marlonrichert/zsh-autocomplete#configuration
# zsh-autocomplete presets  https://github.com/marlonrichert/zsh-autocomplete/blob/main/Functions/Init/.autocomplete__config
#───────────────────────────────────────────────────────────────────────────────

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

zstyle '*:compinit:*' arguments -D -i -u -C -w

zstyle ':completion:*' rehash true

zstyle ':completion:*' group-name ''

# FORMAT / COLOR
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS:-${ZLS_COLORS}}
# zstyle ':autocomplete:*' list-colors ${(s.:.)LS_COLORS:-${ZLS_COLORS}}
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# zstyle ':completion:*' format %F{yellow}%B%U%{$__DOTS[ITALIC_ON]%}%d%{$__DOTS[ITALIC_OFF]%}%b%u%f
# zstyle ':autocomplete:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:descriptions' format $'\e[7;38;5;103m %d \e[0;38;5;103m \e[0m'
zstyle ':completion:*:descriptions' format %F{yellow}%B%U%{$__DOTS[ITALIC_ON]%}%d%{$__DOTS[ITALIC_OFF]%}%b%u%f

# color items in specific group
# zstyle ':completion:*:aliases' list-colors '=*=35'

# 1. option descriptions in gray (`38;5;245` is visible in dark and light mode)
# 2. apply LS_COLORS to files/directories
# 3. selected item (styled via `ma=`)
# zstyle ':completion:*:default' list-colors \
#     "=(#b)*(-- *)=39=38;5;245:+${LS_COLORS}:ma=7;38;5;68"

# hide info message if there are no completions https://github.com/marlonrichert/zsh-autocomplete/discussions/513
zstyle ':completion:*:warnings' format ""

# print help messages in blue (affects for instance `just` recipe-descriptions)
# zstyle ':completion:*:messages' format $'\e[3;34m%d\e[0m'

zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification follow reverse # "follow" makes it follow symlinks
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true

# list newer files last so i see them first
# zstyle ':completion:*' file-sort modification reverse
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:manuals' separate-sections true

# Dont prompt for a huge list, menu it!
# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
# zstyle ':completion:*' menu 'select=0'
zstyle ':completion:*' menu select

# New # -- dont prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# zstyle ':autocomplete:tab:*' insert-unambiguous yes
# zstyle ':autocomplete:tab:*' fzf yes
# zstyle ':autocomplete:*' widget-style menu "select=0"
zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 2 )) )'

#───────────────────────────────────────────────────────────────────────────────
# BINDINGS

# BUG not working: https://github.com/marlonrichert/zsh-autocomplete/issues/749
# bindkey '\t' menu-select   # <Tab> starts completion
# bindkey '^[[Z' menu-select # <S-Tab> starts completion

# bindkey -M menuselect '^I' menu-complete                      # <Tab> next item
# bindkey -M menuselect '^[[Z' reverse-menu-complete            # <S-Tab> prev suggestion
# bindkey -M menuselect              '^I' menu-complete
# bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
# bindkey -M menuselect              '\r' .accept-line            # <CR> select & execute

#───────────────────────────────────────────────────────────────────────────────
# SORT

zstyle ':completion:*' file-sort modification follow reverse # "follow" makes it follow symlinks

# INFO inserting "path-directories" to add "directories in cdpath" to the top <-- Annoying af
# zstyle ':completion:*' group-order \
#     path-directories local-directories directories \
#     all-expansions expansions options \
#     aliases suffix-aliases functions reserved-words builtins commands executables \
#     remotes hosts recent-branches commits

# zstyle ':completion:*' group-order \
#     local-directories directories \
#     all-expansions expansions options \
#     aliases suffix-aliases functions reserved-words builtins commands executables \
#     remotes hosts recent-branches commits

#──────────────────────────────────── eo ────────────────────────────────────
# from zsh-lovers -> more in ./nav.zsh
# If you end up using a directory as argument, this will remove the trailing slash (useful in ln)
zstyle ':completion:*' squeeze-slashes true

# cd will never select the parent directory (e.g.: cd ../<TAB>):

zstyle ':completion:*:cd:*' ignore-parents parent pwd

#────────────────────────────────────────────────────────────────────────────

# IGNORE
# remove the _ignored completer set by zsh-autocomplete, so things ignored by
# `ignored-patterns` take effect (https://stackoverflow.com/a/67510126)
# zstyle ':completion:*' completer \
#     _expand _complete _correct _approximate _complete:-fuzzy _prefix

# zstyle ':completion:*' completer _complete _approximate _prefix _complete:-fuzzy _correct
zstyle ':completion:*' completer _complete _approximate _prefix _complete:-fuzzy _prefix

zstyle ':completion:*' ignored-patterns ".git" ".DS_Store" ".localized" "node_modules" "__pycache__" ".pytest_cache" ".venv" ".ipynb_checkpoints"

zstyle ':autocomplete:*' ignored-input '..##' # zsh-autocomplete

zstyle ':autocomplete:*complete*:*' insert-ambiguous yes

# Make completion:
# (stolen from Wincent)
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' \
    '+m:{[:lower:]}={[:upper:]}' \
    '+m:{[:upper:]}={[:lower:]}' \
    '+m:{_-}={-_}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


# zstyle ':completion:*' matcher-list '+m:{[:lower:]}={[:upper:]}' \
#     '+m:{[:upper:]}={[:lower:]}' \
#     '+m:{_-}={-_}' \
#     'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' use-cache on
zstyle ':completion:*:complete:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache/"
# zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/zcompcache"

# NOTE: Cant say I ever really cared for or used CDR

#-------------------------------------------------------------------------------
#  CDR
#-------------------------------------------------------------------------------
# https://github.com/zsh-users/zsh/blob/master/Functions/Chpwd/cdr

# zstyle ':completion:*:cdr:*' menu selection
# $WINDOWID is an environment variable set by kitty representing the window ID
# of the OS window (NOTE this is not the same as the $KITTY_WINDOW_ID)
# @see: https://github.com/kovidgoyal/kitty/pull/2877
# zstyle ':chpwd:*' recent-dirs-file $ZSH_CACHE_DIR/.chpwd-recent-dirs-${WINDOWID##*/} +
# zstyle ':completion:*' recent-dirs-insert always
# zstyle ':chpwd:*' recent-dirs-default yes

# dont save to dotfiles repo --> it can grow rather large
# export ZSH_COMPDUMP="$ZDOTDIR/.zcompdump"

# vim: ft=zsh ts=8 sw=4 sts=4 tw=100 et ai:
