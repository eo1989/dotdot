# vim:ft=zsh ts=8 sw=4 sts=4 tw=100 fdm=marker et ai:
#
#-------------------------------------------------------------------------------
#                                OPTIONS
# DOCS https://zsh.sourceforge.io/Doc/Release/Options.html
# DOCS https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell
#-------------------------------------------------------------------------------
setopt CD_SILENT # follow symlinks when they are cd targets
setopt CHASE_LINKS
setopt AUTO_CD # XXX BUG|>https://github.com/marlonrichert/zsh-autocomplete/issues/749
setopt RM_STAR_WAIT
setopt CORRECT # command auto-correction ... hmmm idk
setopt COMPLETE_ALIASES
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_NO_STORE      # ignore history command itself for the history
setopt AUTOPARAMSLASH     # tab completing directory appends a slash
setopt SHARE_HISTORY      # Share your history across all your terminal windows
setopt EXTENDED_HISTORY   # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits
# setopt AUTO_PUSHD         # Push the current directory visited on the stack. ZSH_AUTOCOMP already populates, so no need to run
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.
setopt NO_CLOBBER
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt LIST_PACKED
# above -> akinsho, below chrisgrieser
setopt GLOB_DOTS    # glob includes dotfiles; think this is set in .zshrc??
setopt PIPE_FAIL    # tracability: exit if pipeline failed
setopt NO_BANG_HIST # dont expand '!'

# Keep a ton of history.
export HISTSIZE=20000
export SAVEHIST="$HISTSIZE"
export HISTFILE="$ZSH_CACHE_DIR/.zsh_history"

# colorize 127 error codes
command_not_found_handler() {
    print "\e[1;33mCommand not found: \e[1;31m$1\e[0m"
    return 127
}

# auto escape special characters when pasting URLs
# autoload -U url-quote-magic bracketed-paste-magic
# zle -N self-insert url-quote-magic
# zle -N bracketed-paste bracketed-paste-magic
