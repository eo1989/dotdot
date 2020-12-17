# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#------------------------------- Homebrew ---------------------------------#
export PATH="/usr/bin:/bin:/usr/sbin:${PATH}"
export PATH="/usr/local/bin:${PATH}"

#------------------------------ extra paths -------------------------------#
# export PATH="/usr/local/Cellar/global/6.6.4_1/libexec/bin:${PATH}"
export PATH="/Applications/kitty.app/Contents/MacOS/kitty:${PATH}"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/gnu-getopt/bin:/usr/local/opt/findutils/libexec/gnubin:${PATH}"

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.emacs.d/bin:${PATH}"
export PATH="/usr/local/opt/emacs-plus@28/Emacs.app:${PATH}"
export PATH="/usr/local/opt/openjdk/bin:${PATH}"
export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
# export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH="/usr/local/opt/llvm/bin:${PATH}"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"


#Go
export GOPATH="${HOME}/go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"

# Rust
export PATH="${HOME}/.cargo/bin:${PATH}"


# Pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


export LS_COLORS="$(vivid generate snazzy)"

# export BAT_THEME="Sublime Snazzy"
export EXA_COLORS="uu=0:gu=0"
# If you come from bash you might hve to change your $PATH.
#
# source p10k as the theme for zsh
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme



export MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man:${MANPATH}"
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# export $ZSH_THEME="dracula"

# export DRACULA_DISPLAY_TIME=0
# export DRACULA_DISPLAY_CONTEXT=1
# export DRACULA_ARROW_ICON="|>" 
# source ~/.oh-my-zsh/themes/dracula.zsh-theme

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ py3 nvim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

export PYTHON3_HOST_PROG="~/.pyenv/versions/py3nvim-perm/bin/python3"

#---------------------------------- FZF --------------------------------#
export FZF_BASE="/usr/local/opt/fzf"
export FZF_DEFAULT_OPTS="
    --layout=reverse
    --info=inline
    --height=40%
    --multi
    --preview-window=:hidden
    --preview='([[ -f {} ]] && (bat --style=numbers,changes --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
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

export FZF_CTR_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND -t d"


fpath=(/usr/local/share/zsh-completions ~/.zfunc $fpath)

autoload -Uz +X compinit && compinit -u
# autoload -Uz bashcompinit && bashcompinit -u

kitty + complete setup zsh | source /dev/stdin

source /usr/local/share/zsh-completions
source ${HOME}/Dev/RandomRepos/fzf-tab/fzf-tab.plugin.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

## zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

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
plugins=(git pyenv fd fzf jump tig colored-man-pages colorize
    \jump cargo httpie stack brew cask command-not-found rust
    \golang ripgrep poetry virtualenv tmux tmuxinator cp mosh
    \lein gnu-utils rustup fzf-tab)

source $ZSH/oh-my-zsh.sh



#---------------------------- Everything Else ----------------------------#
# User configuration
export EDITOR="nvim"

#------------------------------- alias -----------------------------------#

# alias -g julia="/Applications/Julia-1.4.app/Contents/Resources/julia/bin/julia"
# alias -g config='git --git-dir=/Users/eo/.dotfiles/ --work-tree=/Users/eo'

# alias -g preview="fzf --preview 'bat --color \"always\" {}'"

# alias -g k="/Applications/kitty.app/Contents/MacOS/kitty --listen-on unix:/tmp/mykitty"

alias -g dotfiles="/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

alias -g j="jump"

alias -g ls="exa -T -L 1 -F --icons --group-directories-first"
alias -g lsa="exa --all -T -F --icons --git"
alias -g lt="exa -T -L 2 -F --icons"

alias -g ranger="/usr/local/bin/ranger"

alias -g halp="tldr"

alias -g ping="prettyping --nolegend"

alias -g Z='| fzf'

alias -g zshrc="nvim ~/.zshrc"
alias -g reload="exec $SHELL"

alias -g bif="brew info"
alias -g bish="brew install"
alias -g bs="brew search"

alias -g diff="delta --line-numbers --side-by-side"

alias -g yt="youtube-dl --external-downloader aria2c"

alias -g ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias -g localip="ipconfig getifaddr en0"

alias -g hdi='function hdi(){ howdoi $* -c -n 5; }; hdi'
alias -g ggls="gls --color=auto -HLFS"

alias -g rm="trash"

# Temp - See how it works out
GITSTATUS_LOG_LEVEL=DEBUG

# if [[ ! -d ~/.oh-my-zsh/custom/plugins/autopair.zsh ]]; then
#     git clone https://github.com/hlissner/zsh-autopair ~/.zsh-autopair

source ~/.zsh-autopair/autopair.zsh
autopair-init


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

# quickly add & remove '.bak' to files
bak() {
    for file in "$@"; do
        if [[ $file =~ "\.bak" ]]; then
            mv -iv "$file" "$(basename ${file} .bak)"
        else
            mv -iv "$file" "${file}.bak"
        fi
    done
}

# quickly duplicate things
dup() {
    for file in "$@"; do
        cp -f "$file" "${file}.dup"
    done
}

# rename files // may not need this one as "rename" is a program via brew
name() {
    local newname="$1"
    vared -c -p "rename to: " newname
    command mv "$1" "$newname"
}


#--------------------------- Haskell/GHC -------------------------------#
GHC_PATH="stack path | grep compiler-bin | sed -e 's/compiler-bin: //'"
export PATH="$PATH:$GHC_PATH"

#----------------------------- Poetry --------------------------------- #
export PATH="$HOME/.poetry/bin:$PATH"


#----------------------------- fuck! -----------------------------------#
eval "$(thefuck --alias)" #$(thefuck --alias)

#------------------------ Zoxifde! (trial) ------------------------------#
eval "$(zoxide init zsh)"

#------------------------ gh completion (trial) ------------------------------#
eval "$(gh completion -s zsh)"

# ----------------------------- fzf-tab ---------------------------------------#
zstyle ':completion:*' fzf-search-display true
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort true
# lets test this git checkout completion snippet out first.
# zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0 

zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:complete:_zlua:*' query-string input
# zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
# zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
# zstyle ':fzf-tab:complete:kill:*' popup-pad 0 3
# zstyle ":fzf-tab:*" fzf-flags '--color=bg+:23'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview [[ $group == "[process ID]" ]] && ps --pid=$'word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' show-group full




# zstyle ':z4h:fzf-complete' fzf-bindings 'tab:repeat' 'ctrl-a:toggle-all'


# ------------------------- fzf-tab-completion ------------------------- #
# source /Users/eo/Dev/RandomRepos/fzf-tab-completion/zsh/fzf-zsh-completion.sh

# trial for file preview w/ ls using bat?
# zstyle ':completion:*:ls:*' fzf-completion-opts --preview='head {1}'

bindkey '^I' fzf_completion
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
