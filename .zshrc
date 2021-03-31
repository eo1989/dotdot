# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export EXA_COLORS="uu=0:gu=0"
export LS_COLORS="$(vivid generate snazzy)"
export LSCOLORS="$(vivid generate snazzy)"
#------------------------------- Homebrew ---------------------------------#
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"


#------------------------------ extra paths -------------------------------#
export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"


# Pyenv & Poetry & Go & Cargo/Rust
export PYENV_ROOT="${HOME}/.pyenv"

export GOPATH="${HOME}/go"
export GOROOT="/usr/local/opt/go/libexec"  # This is faster?

export PATH="${PATH}:/usr/local/Cellar/emacs/27.1/bin/emacs:\
/Applications/kitty.app/Contents/MacOS/kitty:\
${HOME}/.local/bin:${HOME}/.local/sbin:\
${HOME}/.cargo/bin:${HOME}/.stack:\
${GOPATH}/bin:${GOROOT}/bin:\
${PYENV_ROOT}/bin:\
${HOME}/.emacs.d/bin:\
${HOME}/.poetry/bin:\
/usr/local/opt/findutils/libexec/gnubin:\
/usr/local/opt/ssh-copy-id/bin"

# /usr/local/opt/emacs/bin/emacs: <-- No work!
# LLVM -- Julia, & such
# export PATH="/usr/local/opt/llvm/bin:${PATH}"
# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"

# using gnupg & ssh
export GPG_TTY=$(tty)

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi



# This is left empty st brew python and env vars arent friends yet...?
export BROWSER= 

export MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man:${MANPATH}"
# export LANG="en_US.UTF-8"
# export LC_COLLATE="en_US.UTF-8"
# export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ py3 nvim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

export PYTHON3_HOST_PROG="~/.pyenv/versions/py3nvim-perm/bin/python"

#------------------------------------ FZF -------------------------------------#
export FZF_BASE="/usr/local/opt/fzf"
export FZF_DEFAULT_OPTS="\
    --layout=reverse\
    --info=inline\
    --height=40%\
    --multi\
    --preview-window=:hidden\
    --preview='([[ -f {} ]] && (bat --style=numbers,changes --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'\
    --ansi\
    --prompt='~ ' --pointer='▶' --marker='✓'\
    --bind='?:toggle-preview'\
    --bind='ctrl-a:select-all'\
    --bind='ctrl-y:execute-silent(echo {+} | pbcopy)'\
    --bind='ctrl-v:execute(code {+})'\
    --bind='ctrl-e:execute(echo {+} | xargs -o nvim)'\
    --bind='ctrl-u:preview-page-up'\
    --bind='ctrl-d:preview-page-down'"

FD_OPTIONS="--color always --follow --hidden --exclude '.git' --exclude 'node_modules'"
export FZF_DEFAULT_COMMAND="fd ${FD_OPTIONS}"

export FZF_CTR_T_COMMAND="${FZF_DEFAULT_COMMAND}"

export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} -t d"


export BAT_STYLE=full
# export GIT_PAGER=delta

fpath=(/usr/local/share/zsh-completions ~/.zfunc $fpath)

#------------------------------ OMZ -------------------------------------------#
# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"

HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=3

COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom/plugins/"

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git gitfast tig colored-man-pages colorize
    \cargo httpie brew history cask command-not-found rust
    \golang ripgrep poetry tmux mosh rustup fzf-tab)

source $ZSH/oh-my-zsh.sh

#---------------------------- Everything Else ----------------------------#
# User configuration
export EDITOR="/usr/local/bin/nvim"
# export BROWSER="/Applications/Safari.app/Contents/MacOS/Safari"
# alias -g saf="${BROWSER} &"
#------------------------------- alias -----------------------------------#

alias -g calibre="/Applications/calibre.app/Contents/MacOS/calibre &"
alias -g fire="/Applications/Firefox.app/Contents/MacOS/firefox &"
alias -g k="/Applications/kitty.app/Contents/MacOS/kitty --listen-on unix:/tmp/mykitty"

alias -g dotfiles="/usr/local/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}"

alias -g ls="exa -g -F --icons --group-directories-first"
alias -g lsa="exa -a -T -F --icons --git"
alias -g lt="exa -T -L 2 -F --icons --git"

alias -g ranger="/usr/local/bin/ranger"

alias -g hlp="tldr"

alias -g ping="prettyping --nolegend"

alias -g zshrc="nvim ~/.zshrc"
alias -g reload="exec ${SHELL}"

alias -g bif="brew info"
alias -g bish="brew install"
alias -g bs="brew search"

alias -g diff="delta --line-numbers --navgivate --side-by-side --syntax-theme='Dracula'"

alias -g yt="youtube-dl --external-downloader aria2c"

alias -g ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias -g localip="ipconfig getifaddr en0"

# alias -g hdi='function hdi(){ howdoi $* -c -n 5; }; hdi'
alias -g ggls="gls --color=auto -HLFS"
alias -g ln="gln"
alias -g xargs="gxargs"
alias -g rm="trash"

alias -g curl='/usr/local/Cellar/curl/7.75.0/bin/curl'
alias -g cht='cht.sh'

source "${HOME}/.zsh-autopair/autopair.zsh" && autopair-init
# autopair-init


#-----------------------------------f(x)s--------------------------------------#
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
        if [[ $file =~ \.bak ]]; then
            mv -iv "$file" "$(basename "${file}" .bak)"
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
# spotlight() { mdfind "kMDItemDisplayName == \"$@\" wc"; }
hdi(){ howdoi "$*" -c -n 5; }

#rga-fzf interactivity
rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="70%:wrap"
    )" &&
    echo "opening $file" &&
    xdg-open "$file"
}


#----------------------------- fuck! ------------------------------------------#
eval "$(thefuck --alias)"

#------------------------ Zoxifde! (trial) ------------------------------------#
eval "$(zoxide init zsh)"

#------------------------ gh completion (trial) -------------------------------#
eval "$(gh completion -s zsh)"

#------------------------------ stack -----------------------------------------#
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"

# ----------------------------- fzf-tab ---------------------------------------#{{{

zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' show-group brief

# zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:complete:*' fzf-bindings \
        "ctrl-v:execute-silent({_FTB_INIT_}code \"$realpath\")" \
        "ctrl-e:execute-silent({_FTB_INIT_}kwrite \"$realpath\")"

zstyle ':completion:*' fzf-search-display true
zstyle ':completion:*:descriptions' format '[%d]'
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':fzf-tab:complete:cd:*' fzf-preview "exa -1 --color=auto $realpath"
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ':completion:*:ls:*' fzf-completion-opts --preview='head {1}'

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  "[[ $group == \"[process ID]\" ]] && ps --pid=$word -o cmd --no-headers -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
# {{{ some fzf-tab-completion/zsh-completion opts
# disable sort when completing options of any command
# zstyle ':completion:complete:*:options' sort true
# lets test this git checkout completion snippet out first.
# zstyle ":completion:*:git-checkout:*" sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview "ps --pid=${word} -o cmd --no-headers -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:kill:*' popup-pad 0 3
# zstyle ":fzf-tab:*" fzf-flags '--color=bg+:23'
# zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview [[ $group == "[process ID]" ]] && "ps --pid=$'word -o cmd --no-headers -w -w'"
# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
# zstyle ':fzf-tab:*' fzf-command fzf
# zstyle ':completion::*:git::git,add,*' fzf-completion-opts --preview='git -c color.status=always status --short'
# zstyle ':z4h:fzf-complete' fzf-bindings 'tab:repeat' 'ctrl-a:toggle-all'
# }}}

# autoload menucomplete && menucomplete
# }}}

kitty + complete setup zsh | source /dev/stdin
test -e /Users/eo/.iterm2_shell_integration.zsh && source /Users/eo/.iterm2_shell_integration.zsh || true

[ -f ~/.fzf.zsh ] && source "${HOME}/.fzf.zsh"
source "${HOME}/do-ls"

# source ${HOME}/Dev/RandomRepos/fzf-tab/fzf-tab.plugin.zsh

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# zstyle ':autocomplete:*' add-space executables \
#     aliases functions builtins \
#     reserved-words commands
# zstyle ':completion:*:'  group-order \
#     expansions history-words options \
#     alias functions builtins reserved-words \
#     executables local-directories directories suffix-aliases


zstyle ':autocomplete:*' default-context ''
zstyle ':autocomplete:*' min-delay 0.25
zstyle ':autocomplete:*' min-input 1
# zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':autocomplete:tab:*' fzf-completion yes
# source "${HOME}/Dev/RandomRepos/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

source /usr/local/share/zsh-completions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

## zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source "${HOME}/.config/broot/launcher/bash/br"
EMAIL_UNAME="EOrlowski6@gmail.com"
PWORD="adidas1989"
export PY_BARCHART_UNAME=$EMAIL_UNAME
export PY_BARCHART_PWORD=$PWORD
