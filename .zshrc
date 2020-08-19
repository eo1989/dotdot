# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local:/usr/bin:/usr/sbin:/usr/share:$PATH"
# /usr/local/opt:
# 
#  
#random paths
export PATH="/usr/local/opt/ruby/bin:/usr/local/opt/curl/bin:/usr/local/Cellar/global/6.6.4_1/libexec/bin:$PATH"
export PATH="/Applications/kitty.app/Contents/MacOS:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/gnu-getopt/bin:/usr/local/opt/findutils/libexec/gnubin:$PATH"

export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"

# haskell & Doom
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"


#Go
export GOPATH="$HOME/go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"


# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export PATH="$HOME/.poetry/bin:$PATH"


# If you come from bash you might hve to change your $PATH.
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme



export MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man:$MANPATH"
export LANG="en_US.UTF-8"
# export LS_COLORS="$(vivid generate snazzy)"

export BAT_THEME="OneHalfDark"
export CHEAT_USE_FZF="true"
export GTAGSLABEL=pygments 


# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"

HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=2

COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom/plugins"

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# removed fast-syntax-highlighting from plugins list
plugins=(git pyenv pylint fd jump colored-man-pages
    colorize z jump cargo httpie stack extract
    command-not-found tmux rust golang ripgrep)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR="nvim"

fpath=(/usr/local/share/zsh-completions ~/.zfunc $fpath)

autoload -Uz compinit && compinit -u
autoload -Uz promptinit && promptinit -u
autoload -Uz bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"
eval "$(thefuck --alias)"
        # if type brew &>/dev/null; then
        #     fpath="$(brew --prefix)/share/zsh/site-functions:$fpath"
        #      autoload -Uz compinit
        #      compinit
        # fi

kitty + complete setup zsh | source /dev/stdin


#py3 nvim
export PYTHON3_HOST_PROG="$HOME/.pyenv/versions/3.8.2/envs/py3nvim-perm/bin/python3.8"
 
export FZF_BASE="/usr/local/opt/fzf"
export FZF_DEFAULT_OPTS="
    --layout=reverse
    --info=inline
    --height=40%
    --multi
    --preview-window=:hidden
    --preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
     --ansi
    --prompt='~ ' --pointer='▶' --marker='✓'
    --bind='?:toggle-preview' 
    --bind='ctrl-a:select-all'
    --bind='ctrl-y:execute-silent(echo {+} | pbcopy)'
    --bind='ctrl-v:execute(code {+})'
    --bind='ctrl-e:execute(echo {+} | xargs -o nvim)'
    --bind='ctrl-u:preview-page-up' 
    --bind 'ctrl-d:preview-page-down'"
 
FD_OPTIONS="--color auto --follow --hidden --exclude '.git' --exclude 'node_modules'"
export FZF_DEFAULT_COMMAND="fd $FD_OPTIONS"
# export FZF_PREVIEW_OPTS="bat --style=full --wrap=auto --color=always {} || cat {} || tree -C {}"
export FZF_CTR_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_CTRL_T_OPTS="fd "$FD_OPTIONS" --preview-window=right:60% --preview-window=noborder --preview='${FZF_PREVIEW_OPTS} 2> /dev/null'"

export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND -t d"
# export FZF_ALT_C_OPTS="fd -t d $FD_OPTIONS"


# alias -g julia="/Applications/Julia-1.4.app/Contents/Resources/julia/bin/julia"
# alias -g config='git --git-dir=/Users/eo/.dotfiles/ --work-tree=/Users/eo'

# alias -g preview="fzf --preview 'bat --color \"always\" {}'"

alias -g dotfiles="/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

alias -g j="jump"
alias -g ls="exa --all --color=auto --icons --group-directories-first"
alias -g lsa="exa -T -F --color=auto --icons --group-directories-first"
alias -g lt="exa -F -T -L 2 --icons --git-ignore"

alias -g help="tldr"

alias -g ping="prettyping --nolegend"

alias -g Z='| fzf'

alias -g zshrc="nvim ~/.zshrc"
alias -g reload="exec $SHELL"

alias -g bif="brew info"
alias -g bish="brew install"
alias -g BS="brew search"

alias -g diff="diff-so-fancy"

alias -g yt="youtube-dl --external-downloader aria2c"

alias -g ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias -g localip="ipconfig getifaddr en0"
# alias -g dotfiles=

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Temp - See how it works out
GITSTATUS_LOG_LEVEL=DEBUG

if [[ ! -d ~/.oh-my-zsh/custom/plugins/autopair.zsh ]]; then
    git clone https://github.com/hlissner/zsh-autopair ~/.zsh-autopair
fi

source ~/.zsh-autopair/autopair.zsh
autopair-init

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-completions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

 ## zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# attempt #1 08/18/20
# Find-in-file -> usage: 'fif <SEARCH_TERM>'
# 08/19/20 -> it works!
fif() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!";
        return 1;
    fi

    rg --files-with-matches --no-messages "$1" | fzf
$FZF_PREVIEW_WINDOW="--preview 'rg --ignore-case --pretty --context 10 '$1' {}'"
}
