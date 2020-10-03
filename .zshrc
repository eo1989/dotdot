# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#------------------------------- Homebrew ---------------------------------#
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local:/usr/bin:/usr/sbin:/usr/share:$PATH"


#------------------------------ extra paths -------------------------------#
export PATH="/usr/local/Cellar/global/6.6.4_1/libexec/bin:$PATH"
export PATH="/Applications/kitty.app/Contents/MacOS:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/gnu-getopt/bin:/usr/local/opt/findutils/libexec/gnubin:$HOME/Library/Python/3.8/bin:$PATH"


#-------------------- Find OpenJDK ahead of sys java ----------------------# 
export PATH="/usr/local/opt/emacs-plus@28/Emacs.app:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

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


export EXA_COLORS="uu=0:gu=0"
# If you come from bash you might hve to change your $PATH.
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme



export MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man:$HOME/Library/Python/3.8/man/man1:$MANPATH"
export LANG="en_US.UTF-8"
export LS_COLORS="$(vivid generate snazzy)"

# export BAT_THEME="OneHalfDark"
export CHEAT_USE_FZF="true"
export GTAGSLABEL="pygments" 
# export $ZSH_THEME="dracula"

# export DRACULA_DISPLAY_TIME=0
# export DRACULA_DISPLAY_CONTEXT=1
# export DRACULA_ARROW_ICON="|>" 
# source ~/.oh-my-zsh/themes/dracula.zsh-theme

#py3 nvim
export PYTHON3_HOST_PROG="$HOME/.pyenv/versions/3.8.2/envs/py3nvim-perm/bin/python3.8"


#---------------------------------- FZF --------------------------------#
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


#---------------------------- OMZ -----------------------------------#
# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"

HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=2

COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins/"

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git pyenv pylint fd fzf jump tig colored-man-pages
    colorize jump cargo httpie stack extract
    command-not-found rust golang ripgrep
    poetry virtualenv tmux tmuxinator compleat cp mosh 
    copydir copyfile copybuffer lein dash fzf-tab
    )

source $ZSH/oh-my-zsh.sh



#---------------------------- Everything Else ----------------------------#
# User configuration
export EDITOR="nvim"

#------------------------------- alias -----------------------------------#

# alias -g julia="/Applications/Julia-1.4.app/Contents/Resources/julia/bin/julia"
# alias -g config='git --git-dir=/Users/eo/.dotfiles/ --work-tree=/Users/eo'

# alias -g preview="fzf --preview 'bat --color \"always\" {}'"
alias -g dotfiles="/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

alias -g j="jump"
alias -g ls="exa -T -L 1 -F --icons --group-directories-first"

alias -g lsa="exa --all -T -F --long --icons --git"
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


#------------------------------ Pyenv -----------------------------------#
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Temp - See how it works out
GITSTATUS_LOG_LEVEL=DEBUG

# if [[ ! -d ~/.oh-my-zsh/custom/plugins/autopair.zsh ]]; then
#     git clone https://github.com/hlissner/zsh-autopair ~/.zsh-autopair
# 

source ~/.zsh-autopair/autopair.zsh
autopair-init


fpath=(/usr/local/share/zsh-completions ~/.zfunc $fpath)

autoload -Uz +X compinit && compinit -u
autoload -Uz bashcompinit && bashcompinit -u

kitty + complete setup zsh | source /dev/stdin

source ~/.bash_completion.d/compleat_setup
source /usr/local/share/zsh-completions
source /Users/eo/Dev/RandomRepos/fzf-tab/fzf-tab.plugin.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

## zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#--------------------------------f(x)s-----------------------------------#
# Find-in-file -> usage: 'fif <SEARCH_TERM>'
fif() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!";
        return 1;
    fi

    rg --files-with-matches --no-messages "$1" | fzf
$FZF_PREVIEW_WINDOW="--preview 'rg --ignore-case --pretty --context 10 '$1' {}'"
}
source ~/.fzf.zsh 


#--------------------------- Haskell/GHC -------------------------------#
GHC_PATH="stack path | grep compiler-bin | sed -e 's/compiler-bin: //'"
export PATH="$PATH:$GHC_PATH"

#----------------------------- Poetry --------------------------------- #
export PATH="$HOME/.poetry/bin:$PATH"


#----------------------------- fuck! -----------------------------------#
eval $(thefuck --alias)

#------------------------ Zoxide! (trial) ------------------------------#
eval "$(zoxide init zsh)"

#------------------------ gh completion (trial) ------------------------------#
eval "$(gh completion -s zsh)"

#------------------------- fzf-tab-completion --------------------------#
# source /Users/eo/Dev/RandomRepos/fzf-tab-completion/zsh/fzf-zsh-completion.sh
# # bindkey '^I' fzf_completion

# zstyle ':completion:*' fzf-search-display true

# # trial for file preview w/ ls using bat?
# zstyle ':completion::*:ls::*' fzf-completion-opts --preview='bat {1}'
