# shellcheck disable=SC1091
#───────────────────────────────────────────────────────────────────────────────

# LOAD HOMEBREW COMPLETIONS
# load various completions of clis installed via homebrew
# needs to be run *before* compinit/zsh-autocomplete
# export FPATH="$ZDOTDIR/completions:$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:$HOME/.zfunc:$FPATH"
export FPATH="${BREW_PREFIX}/share/zsh-completions:/Applications/kitty.app/Contents/Resources/kitty/shell-integration/zsh/completions:/usr/share/zsh/site-functions:/usr/share/zsh/5.9/functions:$HOME/.zfunc:$FPATH"

# ZSH-SYNTAX-HIGHLIGHTING
# DOCS https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/regexp.md
. "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(
    main
    brackets
    regexp
)
# pattern
# line
# cursor
# root
# shellcheck disable=2034  # used in other files
typeset -A ZSH_HIGHLIGHT_REGEXP # actual highlighters defined in bottom of aliases.zsh

# ZSH-AUTOSUGGESTIONS
# https://github.com/zsh-users/zsh-autosuggestions#configuration
# ---
# Fish-like autosuggestions for zsh
# Color to use when highlighting suggestion
# Uses format of `region_highlight`
# More info: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets
(( ! ${+ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE} )) &&
    typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
. "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null

# akinsho's
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
# export ZSH_AUTOSUGGEST_USE_ASYNC=1 # <- already set by default
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)" # ignores long history items, ponly works w/ history strategy tho
export ZSH_AUTOSUGGEST_STRATEGY=(completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
bindkey '^E' autosuggest-accept
# bindkey '^Y' autosuggest-execute # remapped to cmd+s in WezTerm, change it in kitty
# bindkey '^U' autosuggest-accept  # akinsho's // default config, probably
# dont accept zsh-autosuggestions when using Vim's `A`
# export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[@]/vi-add-eol/}")


# ZSH-COMPLETIONS
# also loads compinit stuff, therefore has to be loaded before most plugins // maybe it can be
# loaded after to get the original UX back? this new one sucks.
. "${BREW_PREFIX}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" 2>/dev/null

# ZSH-AUTOPAIR
. "${BREW_PREFIX}/share/zsh-autopair/autopair.zsh" 2>/dev/null

# ZSH-HISTORY-SUBSTRING-SEARCH
. "${BREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh" 2>/dev/null
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1



# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

# bindkey -M viins '^a' beginning-of-line
# bindkey -M viins '^d' push-line-or-edit

# vanilla behavior is to move by characters
# bindkey -M viins '^b' backward-word
# bindkey -M viins '^f' forward-word

# up arrow
# bindkey '\e[A' history-substring-search-up
# bindkey '\eOA' history-substring-search-up

# down arrow
# bindkey '\e[B' history-substring-search-down
# bindkey '\eOB' history-substring-search-down

# history-beginning-search-backward-then-append() {
#     zle history-beginning-search-backward
#     zle vi-add-eol
# }
# zle -N history-beginning-search-backward-then-append
# bindkey -M viins '^x^l' history-beginning-search-backward-then-append

# vim: ft=zsh ts=8 sw=4 sts=4 tw=100 et ai:
