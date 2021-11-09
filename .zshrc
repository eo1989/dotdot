export GPG_TTY=$(tty)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
#------------------------------- Homebrew ---------------------------------#
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt"

#------------------------------ extra paths -------------------------------#
export GOPATH="${HOME}/go"
export GOROOT="/usr/local/opt/go/libexec"  # This is faster?

export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.local/sbin:\
/usr/local/opt/coreutils/libexec/gnubin:\
/usr/bin:/bin:/usr/sbin:/sbin:\
${HOME}/.cargo/bin:\
${GOPATH}/bin:${GOROOT}/bin:\
/Applications/kitty.app/Contents/MacOS/kitty:\
${HOME}/.poetry/bin:\
/usr/local/Cellar/emacs/27.2/bin/emacs:\
${HOME}/.emacs.d/bin:\
/usr/local/opt/luajit-openresty/bin"

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="$PYENV_ROOT/bin:${PATH}"
eval "$(pyenv init --path)"
eval "$(pyenv init - )"
eval "$(pyenv virtualenv-init -)"

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# if command -v pyenv 1>/dev/null 2>&1; then
#    eval "$(pyenv init -)"
# fi

# This is left empty st brew python and env vars arent friends yet...?
export BROWSER=

export MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man:${MANPATH}"
export LC_ALL="en_US.UTF-8"

source "${HOME}/Dev/RandomRepos/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
# sourced autocomplete before OMZ to see how it works with fzf-tab/color completion
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ py3 nvim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
export PYTHON3_HOST_PROG="~/.pyenv/versions/pynvim/bin/python"
#------------------------------------ FZF -------------------------------------#
export FZF_BASE="/usr/local/opt/fzf"
export FZF_DEFAULT_OPTS="\
    --layout=reverse\
    --ansi\
    --info=inline\
    --height=30%\
    --multi\
    --preview-window='right:60%:hidden'\
    --preview='([[ -f {} ]] && (bat --style=full --color=always {} \
                || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) \
                || echo {} 2> /dev/null | head -200'\
    --prompt='~ ' --pointer='▶' --marker='✓'\
    --bind='?:toggle-preview'\
    --bind='ctrl-a:select-all'\
    --bind='ctrl-c:execute-silent(echo {+} | pbcopy)'\
    --bind='ctrl-e:execute(echo {+} | xargs -o ${EDITOR})'\
    --bind='ctrl-u:preview-page-up'\
    --bind='ctrl-d:preview-page-down'"

# --bind='ctrl-v:execute(code {+})'\
FD_OPTIONS="--color always --follow --hidden --exclude '.git' --exclude 'node_modules'"
export FZF_DEFAULT_COMMAND="fd ${FD_OPTIONS} ."

export FZF_CTR_T_COMMAND="${FZF_DEFAULT_COMMAND}"

export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} -t d ${HOME}"


export BAT_STYLE=full

fpath=(/usr/local/share/zsh-completions ~/.zfunc $fpath)
#------------------------------ OMZ -------------------------------------------#
# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"

HYPHEN_INSENSITIVE="true"
# DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=3

COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="mm-dd-yyyy"

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom/plugins/"

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git gitfast tig colored-man-pages colorize
        \brew command-not-found git-lfs 
        \poetry tmux fzf-tab)

source $ZSH/oh-my-zsh.sh

source "${HOME}/.oh-my-zsh/custom/plugins/zsh-poetry/poetry.zsh"
source "${HOME}/.zsh-autopair/autopair.zsh" && autopair-init

#---------------------------- Everything Else ----------------------------#
# User configuration
export EDITOR="/usr/local/bin/nvim"
# export BROWSER="/Applications/Safari.app/Contents/MacOS/Safari"
# alias -g saf="${BROWSER} &"
#------------------------------- alias -----------------------------------#

# alias -g calibre="/Applications/calibre.app/Contents/MacOS/calibre &"
alias -g fire='/Applications/Firefox.app/Contents/MacOS/firefox &'
# alias -g k="/Applications/kitty.app/Contents/MacOS/kitty --listen-on unix:/tmp/mykitty"

alias -g curl='/usr/local/opt/curl/bin/curl'

alias -g dotfiles='/usr/local/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'

alias -g ls='exa -g -F --icons --group-directories-first --git'
alias -g lsa='exa -a -T -F --icons --git'
alias -g lt='exa -T -L 2 -F --icons --git'

alias -g hh='tldr'

alias -g ping='prettyping --nolegend'

alias -g zshrc='nvim ~/.zshrc'
alias -g reload='exec ${SHELL}'

alias -g bif='brew info'
alias -g bish='HOMEBREW_NO_AUTO_UPDATE=1 brew install'
alias -g bs='brew search'


alias -g diff="delta --line-numbers --navgivate --side-by-side --syntax-theme='Dracula'"

alias -g yt='youtube-dl --external-downloader aria2c'

alias -g ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias -g localip='ipconfig getifaddr en0'

alias -g nvim='lvim'
alias -g lc='exa --git --icons --color-scale -lFbh -s=size'
alias -g ncdu='ncdu --color=dark --si'
alias -g lpath='echo ${PATH} | tr ":" "\n"'
alias publicip='curl -s checkip.amazonaws.com'
alias -g lg="git log --color --graph --pretty=format:'%Cred%h%Creset %>(32)%cD -%C(yellow)%d%Creset %<(35,trunc)%s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

# alias -g hdi='function hdi(){ howdoi $* -c -n 5; }; hdi'

# alias -g xargs="gxargs"
# alias -g map="gxargs -n1"
alias -g map='xargs -n1'

alias -g rm='trash'
alias chktermfont='echo -e "\nnormal flower\n\e[1mboldflower\e[0m\n\e[3mitalic flower\e[0m\n\e[3m\e[1mbold italic flower\e[0m\n\e[4munderline flower\e[0m\n\e[9mstrikethrough flower\e[0m\n\e[4:3mcurly underline flower\e[4:0m\n\e[4:3\e[58:mcurlyunderlinewithcolor flower\e[59m\e[4:0m"
'
alias -g cht='cht.sh'
alias -g c='clear'
alias -g cc='clear'

# by default, run-help is aliased to man. Turn it off so that you can access the fx def of run-help 
# (by default aliases take precedence over fx's). if you re-source this file, then the alias might 
# already be removed, so you need to suppress any error that this may throw.
unalias run-help 2>/dev/null || true

# now autoload run-help & several extensions to it which prodive 
# more precise help for certain external commands
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo
autoload -Uz run-help-svk
autoload -Uz run-help-svn

alias help=run-help


#-----------------------------------f(x)s--------------------------------------#
# function _accept-line() {
#   if [[ $BUFFER == "." ]]; then
#     BUFFER="source ~/.zshrc"
#   fi
#   zle .accept-line
# }
# zle -N accept-line _accept-line

# or this...? 
function _accept-line() {
  emulate -LR zsh
  if [[ $BUFFER == "." ]]; then
    BUFFER="exec zsh"
  fi
  zle .accept-line
}

zle -N accept-line _accept-line



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

spotlight() { mdfind "kMDItemDisplayName == \"$@\" wc"; }

hdi(){ howdoi "$*" -c -n 5; }

#rga-fzf interactivity
rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort\ 
                --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --phony\
                -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="40%:hidden:40%:wrap"
    )" &&
    echo "opening $file" &&
    xdg-open "$file"
}

# palatte of colors
palette() {
    local -a colors
    for i in {000..255}; do
        colors+=("%F{$i}$i%f")
    done
    print -cP $colors
}

# princ COLOR_CODE
printc() {
    local color="%F{$1}"
    echo -E ${(qqqq)${(%)color}}
}



eval "$(thefuck --alias)"
eval "$(zoxide init zsh)"
eval "$(gh completion -s zsh)"
eval "$(pip completion --zsh)"
kitty + complete setup zsh | source /dev/stdin

# ----------------------------- fzf-tab ---------------------------------------#{{{

zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ":fzf-tab:*" fzf-flags '--color=bg+:23'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' show-group brief
# zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:*' print-query alt-enter

zstyle ':fzf-tab:complete:*' fzf-bindings \
        "ctrl-v:execute-silent({_FTB_INIT_}code \"$realpath\")" \
        "ctrl-e:execute-silent({_FTB_INIT_}kwrite \"$realpath\")"

zstyle ':completion:*' fzf-search-display true
zstyle ':completion:*:descriptions' format '[%d]'
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

zstyle ':fzf-tab:complete:_zoxide:*' query-string input
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ':completion:*:ls:*' fzf-completion-opts --preview="([[ -f {} ]] && (bat --style=full --color=always {} || cat {})) \
                || ([[ -d {} ]] && (tree -C {} | less)) \
                || echo {} 2> /dev/null | head {2}"
                # 'head {2}'

zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'

export LESSOPEN='|~/.lessfilter %s'

zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
#   [[ $group == "[process ID]" ]] && "ps --pid=$'word -o cmd --no-headers -w -w'"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:30%:wrap
zstyle ':fzf-tab:complete:(kill|ps):*' popup-pad 0 3

# {{{ some fzf-tab-completion/zsh-completion opts
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort true
# lets test this git checkout completion snippet out first.
# zstyle ':completion:*:git:git,add,*' fzf-completion-opts --preview='git -c color.status=always status --short'
# zstyle ":completion:*:git-checkout:*" sort false

# it is an example. you can change it
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'|

zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'

zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'

zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'

zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

# }}}

# }}}


[ -f ~/.fzf.zsh ] && source "${HOME}/.fzf.zsh"
# [ -f "/usr/local/opt/fzf/shell/completion.zsh" ] && source "/usr/local/opt/fzf/shell/completion.zsh"
# [ -f "/usr/local/opt/fzf/shell/key-bindings.zsh" ] && source "/usr/local/opt/fzf/shell/key-bindings.zsh"

source "${HOME}/do-ls"

# source ${HOME}/Dev/RandomRepos/fzf-tab/fzf-tab.plugin.zsh

zstyle ':autocomplete:*' add-space group-order executables aliases options commands builtins expansions
# zstyle ':completion:*:'  add-space group-order expansions history-words options alias functions builtins reserved-words
zstyle ':autocomplete:*' add-space group-order expansions history-words options alias functions builtins reserved-words

zstyle ':autocomplete:*' default-context ''
zstyle ':autocomplete:*' min-delay 0.25
zstyle ':autocomplete:*' min-input 2
# zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':autocomplete:tab:*' fzf-completion yes


source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

ZSH_AUTOSUGGESTION_USE_ASYNC=1
ZSH_AUTOSUGGESTION_BUFFER_MAX_SIZE=20

## zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

autoload -Uz bashcompinit && bashcompinit -u
eval "$(/Users/eo/.pyenv/versions/3.9.0/bin/register-python-argcomplete pipx)"

alias luamake=/Users/eo/lsp/lua-language-server/3rd/luamake/luamake

# export EXA_COLORS="uu=0:gu=0"
export LS_COLORS="$(vivid generate snazzy)"
export LSCOLORS="$(vivid generate snazzy)"



# alias -g cpv='rsync -pogr --progress'


# bashls explainshell endpoint 
export EXPLAINSHELL_ENDPOINT="http://localhost:5000"
eval "$(fnm env)"
export HOMEBREW_BAT=1
 
