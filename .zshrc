# shellcheck disable=SC1090-SC1100,SC1094,SC2034,SC2153,SC2086,SC2296
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f ${BREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme ] && . ${BREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme


# ZSH ONLY and most performant way to cehck existence of an executable
# https://www.topcug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

export LC_ALL="en_US.UTF-8"
export NVYM="/Users/eo/Dev/eo_contrib/neovim/bin/nvim"
export EDITOR=${NVYM}
export VISUAL=${NVYM}
export USE_EDITOR=${EDITOR}
export PAGER="$BREW_PREFIX/bin/less"
export MANPAGER='sh -c "col -b | bat -pl man"'
export LESSKEY="${HOME}/.config/less/lesskey"

export PIP_DISABLE_PIP_VERSION_CHECK=1
export MPLBACKEND="module://matplotlib-backend-kitty"

# check vivid.sh
LS_COLORS="$(~/.cargo/bin/vivid generate snazzy)"
export LS_COLORS

export EZA_COLORS="$LS_COLORS"
export ZLS_COLORS="$LS_COLORS"
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

if [[ -n $KITTY_INSTALLATION_DIR ]]; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi

fpath+=(~/.zfunc $fpath)
[ -f $BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ] && source $BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# By default, zsh considers many chars part of a word (ex: _ & -).
# Narrow that down to allow easier skipping thru words via M-f & M-b
export WORDCHARS='*?_[]~=&;:!#$%^(){}<>'

# "www.github.com/romkatv/dotfiles-public/blob/master/.zshrc"
# NOTE: leave this here because the do-ls script complains, need to fix that stuff, also -G (--grid) is the default
# (( $+commands[eza] )) && alias exa='eza -Ga --color=always --icons --color-scale --group-directories-first --time-style=\"+%m+%d+%Y\"'
# (( $+commands[eza] )) && alias exa='eza -a --color=always --icons --color-scale-mode=gradient --color-scale=all --group-directories-first --time-style=\"+%m+%d+%Y\"'
# (( $+commands[rsync] )) && alias rsync='rsync -rz --info=FLIST,COPY,DEL,REMOVE,SKIP,SYMSAFE,MISC,NAME,PROGRESS,STATS'

if exists bat; then
    bathelp() {
        if [ $# -gt 0 ]; then
            printf "poor use of global --help alias detected brah!\nUse \\--help instead, optionally adding | bathelp manually"
            return
        fi
        bat -l=help --style=plain
    }
    alias -g -- -h="-h 2>&1 | bathelp"
    alias -g -- --help="--help 2>&1 | bathelp"
fi

zstyle ':omz:update' mode reminder

# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"
HYPHEN_INSENSITIVE=1
# DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=3

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom/plugins/"

plugins=()

source "${ZSH}/oh-my-zsh.sh"

if exists nvim; then
    alias vim=nvim
    alias vi=nvim
fi

[ -f ${HOME}/zsh-addons/poetry.zsh ] && . ${HOME}/zsh-addons/poetry.zsh

[ -f ${HOME}/scripts/do-ls ] &&  . ${HOME}/scripts/do-ls

[ -f ${BREW_PREFIX}/share/zsh-autopair/autopair.zsh ] && . ${BREW_PREFIX}/share/zsh-autopair/autopair.zsh
[ -f ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && . ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && . ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ${BREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh ] && . ${BREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

# [ -f ${BREW_PREFIX}/share/forgit/forgit.plugin.zsh ] && . ${BREW_PREFIX}/share/forgit/forgit.plugin.zsh

if exists pipx; then
    eval "$(register-python-argcomplete pipx)"
fi

if exists pip; then
    eval "$(pip completion --zsh)"
fi

if exists thefuck; then
    eval "$(thefuck --alias)"
fi

if exists gh; then
    eval "$(gh completion -s zsh)"
fi

if exists npm; then
    eval "$(npm completion)"
fi

if exists navi; then
    eval "$(navi widget zsh)"
fi

if [[ "${TERM}" == "xterm-kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
fi

sources=("aliases.zsh" "functionz.zsh" ".fzfrc")

for file in ${sources[@]}; do
    source "${HOME}/.config/zsh/${file}"
done
unset file
unset sources


eval "$(fzf --zsh)"
# export FZF_DEFAULT_OPTS_FILE="${HOME}/.config/zsh/.fzfrc"

alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Unneeded anymore as kitten is now an exposed program in the cli
# alias icat='kitty +kitten icat "$@"'

# NOTE figure out how to set this up for other tools (lua/rocks?)!
alias -g brew='env PATH="${PATH//$HOME/.pyenv/shims:/}" brew'
alias gn='z ~/.config/nvim/'
alias zshrc="${EDITOR} ~/.zshrc"
alias reload='exec "${SHELL}"'
alias bif='brew info'
alias bs='brew search'
alias bish='env HOMEBREW_NO_AUTO_UPDATE=1 brew install --build-from-source'

if exists pigz; then
    alias gzip=pigz
    alias gunzip="pigz -d"
    alias zcat="pigz -dc"
fi

if exists zoxide; then
    eval "$(zoxide init zsh)"
fi

zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
# New
zstyle ':completion::complete:*' use-cache 1
# list newer files last so i see them first
zstyle ':completion:*' file-sort modification reverse
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' list-separator '┃'
zstyle '*:compinit' arguments -D -i -u -C -w
# New # -- dont prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Dont prompt for a huge list, menu it!
zstyle ':completion:*:default' menu 'select=0'
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
# New zsh-autocomplete version
zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
# New from hdi, much more comprehensive..?
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# New
# zstyle ':autocomplete:tab:*' menu-complete
# zstyle ':autocomplete:*:*' menu-complete

zstyle ':autocomplete:*' widget-style menu select

# NOTE: "-e" lets you specify a dynamically generated value, $LINES is the number of lines that fit
# on screen.
zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 3 )) )'

# zstyle ':autocomplete:recent-paths:*' list-lines 10


# eval "$(atuin init zsh --disable-up-arrow)"
# bindkey '^r' atuin-search

# typeset -U PATH path FPATH fpath MANPATH manpath
#
setopt NO_CLOBBER
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# vim:ft=zsh:fdm=marker:sw=4:tw=100:ts=4:sts=4
