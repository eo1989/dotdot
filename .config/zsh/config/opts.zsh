# #!/usr/bin/env zsh

#-------------------------------------------------------------------------------
#                                OPTIONS
# DOCS https://zsh.sourceforge.io/Doc/Release/Options.html
# DOCS https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell
#-------------------------------------------------------------------------------

setopt EXTENDED_GLOB

export HISTSIZE=20000
# $VENDOR & $OSTYPE let us check what type of machine your on
local histfile="${ZSH_CACHE_DIR}/.zsh_history"
local icloud="${HOME}/Library/Mobile Documents/com\~apple\~CloudDocs"

# if parent directory doesnt exist, create it
# [[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h

if [[ -d "${histfile}" && "${VENDOR}" == apple ]]; then
    # if using iCloud (or dropbox) on macOS, store it there, so it syncs across multiple macs
    HISTFILE="${icloud}/.zsh_history"

    # -s: true if the file exists & isnt empty
    if ! [[ -s "${HISTFILE}" ]]; then
        # Sometimes (probably  due to  concurrency issues), when the histfile is kept
        # in iCloud, it is empty when zsh starts up. however there should always be a backup file we
        # can copy

        # Add history entries from the largest "$HISTFILE <number>" file.
        # \ escapes/quotes the space behind it.
        # (O): sort descending
        # (OL): Sorty by size, descending

        local -a files=( $HISTFILE(|\ <->)(OL) )

        # -n: true if the string is not empty.
        [[ -n "${files[1]}" ]] &&
            fc -RI "${files[1]}"
    fi
else
    # := assigns the variable if its unset or null and then substitutes its value
    HISTFILE="${ZSH_CACHE_DIR}/.zsh_history"
fi

export SAVEHIST="$HISTSIZE"

setopt CD_SILENT # follow symlinks when they are cd targets
setopt CHASE_LINKS
setopt AUTO_CD # XXX BUG|>https://github.com/marlonrichert/zsh-autocomplete/issues/749
setopt AUTO_LIST
setopt AUTO_MENU
setopt RM_STAR_WAIT
# setopt CORRECT # command auto-correction ... hmmm idk
# setopt COMPLETE_ALIASES
setopt APPEND_HISTORY

setopt HIST_FCNTL_LOCK # modern file-locking mechanisms, for better safety & performance
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
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
setopt INTERACTIVE_COMMENTS

# Marlonrichert/zsh-launchpad
# dont treat non-executables files in your $path as commands. this makes sure they dont show up as
# command completions. Setting this option can impact perf on older sysytems, but shouldnt be
# a problem on modern ones.
setopt HASH_EXECUTABLES_ONLY

setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt LIST_PACKED
# above -> akinsho, below chrisgrieser
setopt GLOB_DOTS    # glob includes dotfiles; think this is set in .zshrc??
setopt PIPE_FAIL    # traceability: exit if pipeline failed
setopt NO_BANG_HIST # dont expand '!'
setopt NO_HUP       # dont kill jobs on shell exit

# Marlonrichert/zsh-launchpad // grieser
# enable ** and *** as shortcuts for **/* and ***/*, respectively
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Recursive-Globbing
setopt GLOB_STAR_SHORT
# sort numbers numerically, not lexicographically
setopt NUMERIC_GLOB_SORT

# colorize 127 error codes
command_not_found_handler() {
    print "\e[1;33mCommand not found: \e[1;31m$1\e[0m"
    return 127
}

# auto escape special characters when pasting URLs
# autoload -U url-quote-magic bracketed-paste-magic
# zle -N self-insert url-quote-magic
# zle -N bracketed-paste bracketed-paste-magic

# vim: ft=zsh ts=8 sw=4 sts=4 tw=100 et ai:
# export JUPYTER="/Users/eo/.local/pipx/venvs/jupyterlab/bin/jupyter"
