# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt:/usr/local:/usr/bin:/bin:/$HOME/bin:/usr/sbin:/sbin:$PATH"
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"

# ZSH_THEME="random"
    
# ZSH_THEME_RANDOM_CANDIDATES=( "muse" "robbyrussell" "agnoster" "takashiyoshida" "refined" "pygmalion-virtualenv" "nanotech" "awesomepanda" "lambda")

 HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=1

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
 DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# ZSH_CUSTOM=/path/to/new-custom-folder

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git
  pyenv virtualenv pylint 
  fd fzf jump colored-man-pages
  colorize z jump cargo httpie
  stack extract command-not-found
  tmux rust golang ripgrep)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR="nvim"

#Go
export GOPATH="$HOME/go"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$GOPATH/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PATH:$PYENV_ROOT/bin"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

#py3 nvim
export PYTHON3_HOST_PROG="$HOME/.pyenv/versions/3.8.2/envs/py3nvim-perm/bin/python3.8"

# export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="/Applications/kitty.app/Contents/MacOS:$PATH"


#random paths
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"


export FZF_BASE="/usr/local/opt/fzf"

FD_OPTIONS="--color=always --follow --hidden --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd -t f $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd -t d $FD_OPTIONS"
export FZF_DEFAULT_OPTS="--ansi"

# source $HOME/.poetry/env

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-completions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

 ## zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

eval "$(stack --bash-completion-script stack)"
eval "$(thefuck --alias)"

export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
# export LS_COLORS="$(vivid generate snazzy)"

export BAT_THEME="OneHalfDark"
export BAT_PAGER="less -R"
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
# fpath=(/usr/local/share/zsh-completions $fpath)


# if type brew &>/dev/null; then
#   FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
#
#   autoload -Uz compinit
#   compinit
# fi


kitty + complete setup zsh | source /dev/stdin

# alias zshconfig="mate ~/.zshrc"
# alias -g julia="/Applications/Julia-1.4.app/Contents/Resources/julia/bin/julia"


alias -g config='/usr/local/bin/git --git-dir=/Users/eo/.dotfiles/ --work-tree=/Users/eo'
alias -g zshrc="nvim ~/.zshrc"
alias -g reload=". ~/.zshrc"

alias -g ls="exa --all --color=always --icons --group-directories-first"
alias -g lsa="exa --all -T -L 2 --color=always --icons --group-directories-first"
alias -g lt="exa -F -T -L 2 --icons --git-ignore"

alias -g help="tldr"

alias -g ping="prettyping --nolegend"

alias -g bif="brew info"
alias -g bish="brew install"
alias -g BS="brew search"

alias -g yt="youtube-dl --external-downloader aria2c"

alias -g ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias -g localip="ipconfig getifaddr en0"



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
