# Enable Powerlevel10k instant prompt. Should stay close to the top of
# ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_US.UTF-8
export MANPATH="/usr/local/man:$MANPATH"

export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
# export PATH="$HOME/.doom.d/directories

export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt:/usr/local:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/kitty.app/Contents/MacOS:/Users/eo/.poetry/bin:$HOME/.local/bin:$PATH"

# export VISUAL="open -a 'vimr.app'"
# export EDITOR="$VISUAL"
export EDITOR="nvim"


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
	eval “$(pyenv virtualenv-init -)”
fi

# poetry must be sourced after pyenv
export PATH="$HOME/.poetry/bin:$PATH"

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme


source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-completions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

fpath=(/usr/local/share/zsh-completions $fpath)

# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"

# ZSH_THEME=powerlevel10k/powerlevel10k

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"


# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/.oh-my-zsh/custom/plugins


############################################################################


## zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export FZF_BASE="/usr/local/opt/fzf"

export FZF_OPTIONS="--follow --exclude-.git --exclude-node_modules"
export FZF_DEFAULT_COMMAND="fd . $HOME -t f -H --follow -E .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d $FD_OPTIONS"
export FZF_DEFAULT_OPTS="--ansi --color dark --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {*} | pbcopy)'"

# Test soon - 06/21/20 try ag & pt also vs fd :]
# # export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"


plugins=(git stack httpie vscode pyenv colored-man-pages golang colorize cargo jump poetry command-not-found virtualenv tmux rust z ripgrep)


source $ZSH/oh-my-zsh.sh




# User configuration
export BAT_THEME='OneHalfDark'
# export BAT_PAGER='less -R'





############################################################################

# if type brew &>/dev/null; then
#    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
# 
#    autoload -Uz compinit
#    compinit
# fi
############################################################################

kitty + complete setup zsh | source /dev/stdin

############################################################################
eval "$(stack --bash-completion-script stack)"
eval "$(thefuck --alias)"



#My Aliases test
alias -g dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias -g zshrc='nvim ~/.zshrc'

alias -g ls="exa -a --icons --group-directories-first --git-ignore"
alias -g lsa="exa -a -T -L 2 --icons --git-ignore"
alias -g ll="exa -a -T -L 2 --icons --git"
alias -g lt="exa -T -L 1 --icons --git-ignore"

alias -g BS="brew search"
alias -g bif="brew info"
alias -g ping="prettyping --no-legend preceding"

alias -g help='tldr'

alias -g yt='youtube-dl --external-downloader aria2c'
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
