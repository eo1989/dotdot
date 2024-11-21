# vim:ft=zsh ts=8 sw=4 sts=4 tw=100 fdm=marker et ai:
# shellcheck disable=SC1091
#───────────────────────────────────────────────────────────────────────────────

# LOAD HOMEBREW COMPLETIONS
# load various completions of clis installed via homebrew
# needs to be run *before* compinit/zsh-autocomplete
# export FPATH="$ZDOTDIR/completions:$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:$HOME/.zfunc:$FPATH"
export FPATH="$BREW_PREFIX/share/zsh-completions:/Applications/kitty.app/Contents/Resources/kitty/shell-integration/zsh/completions:/usr/share/zsh/site-functions:/usr/share/zsh/5.9/functions:$HOME/.zfunc:$FPATH"

# ZSH-SYNTAX-HIGHLIGHTING
# DOCS https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/regexp.md
. "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(
    main
    brackets
    regexp
    pattern
    line
    cursor
    root
)
# shellcheck disable=2034  # used in other files
typeset -A ZSH_HIGHLIGHT_REGEXP # actual highlighters defined in bottom of aliases.zsh

# ZSH-COMPLETIONS
# also loads compinit stuff, therefore has to be loaded before most plugins
. "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# ZSH-AUTOSUGGESTIONS
# https://github.com/zsh-users/zsh-autosuggestions#configuration
. "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# akinsho's
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)" # ignores long history items
export ZSH_AUTOSUGGEST_STRATEGY=(history)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
bindkey '^E' autosuggest-accept
bindkey '^Y' autosuggest-execute # remapped to cmd+s in WezTerm, change it in kitty
# bindkey '^U' autosuggest-accept  # akinsho's // default config, probably
# dont accept zsh-autosuggestions when using Vim's `A`
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[@]/vi-add-eol/}")

# ZSH-AUTOPAIR
. "$BREW_PREFIX/share/zsh-autopair/autopair.zsh"

# ZSH-HISTORY-SUBSTRING-SEARCH
. "$BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
