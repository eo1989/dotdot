# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# shellcheck disable=SC2001
# shellcheck disable=SC1090
# shellcheck disable=SC1904
# shellcheck disable=SC2155
# shellcheck disable=SC2148
# shellcheck disable=SC2196

# ------------------------------- Homebrew ---------------------------------#
export GPG_TTY=$(tty)
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt"

fpath+=(
    "/usr/local/share/zsh/functions"
    "/usr/local/share/zsh-completions"
    "/usr/local/share/zsh/site-functions"
    "/Users/eo/.zfunc"
    $fpath
)

# ZSH ONLY and most performant way to cehck existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }


# ------------------------------ extra paths -------------------------------#
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-14.0.2.jdk/Contents/Home"
export JAVA_BIN="${JAVA_HOME}/bin"
export GOPATH="${HOME}/go"
export GOROOT='/usr/local/opt/go/libexec' # This is faster?

# NOTE: Testing to see if zsh path() is different thatn exporting path

if exists pyenv; then
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init --path)"
    # eval "$(pyenv init - )"
    eval "$(pyenv init - --no-rehash zsh)"
    eval "$(pyenv virtualenv-init -)"
fi

# TODO: replaced path+=() with path=() to see if everything will be ahead of
# /usr/local/bin/
path+=(
  # "${JAVA_BIN}"
  "${GOPATH}/bin"
  "${GOROOT}/bin"
  "/usr/local/opt/uutils-coreutils/libexec/uubin" # Rust version of coreutils
  "/usr/local/opt/uutils-findutils/libexec/uubin" # Rust version of findutils see if fd/rg are still better than ufind
  "/usr/local/Cellar/gnu-sed/libexec/gnubin"
  "/usr/local/opt/curl/bin"
  "/usr/local/opt/whois/bin"
  "/usr/local/opt/ssh-copy-id/bin"
  # "/usr/local/opt/gnupg/bin" # need to get away from macgpg2 shit for gh to work
  # this doesnt work need to add it above local/bin
  # "${HOME}/.cargo/bin"
  # "/usr/local/opt/coreutils/libexec/gnubin"
)
# /usr/local/bin:/usr/local/sbin:/usr/local/opt
export PATH="${PATH}:/usr/bin:/bin:/Applications/kitty.app/Contents/MacOS/kitty:/usr/sbin:/sbin:/usr/local/Cellar/emacs/27.2/bin/emacs:${HOME}/.emacs.d/bin:/usr/local/opt/luajit-openresty/bin"
# export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt:/usr/bin:/bin:/Applications/kitty.app/Contents/MacOS/kitty:/usr/sbin:/sbin:/usr/local/Cellar/emacs/27.2/bin/emacs:${HOME}/.emacs.d/bin:/usr/local/opt/luajit-openresty/bin"
# export PATH="${PATH}:/usr/local/bin:/usr/local/sbin:/usr/local/opt:/usr/bin:/bin:/Applications/kitty.app/Contents/MacOS/kitty:/usr/sbin:/sbin:/usr/local/Cellar/emacs/27.2/bin/emacs:${HOME}/.emacs.d/bin:/usr/local/opt/luajit-openresty/bin"



source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
export EXA_COLORS="uu=0:gu=0"
export LS_COLORS="$(vivid generate snazzy)"
export LSCOLORS="$(vivid generate snazzy)"
# export EXA_COLORS=${LS_COLORS-LSCOLORS}
export EXA_COLORS=${LS_COLORS:+LSCOLORS}
# . "/usr/local/opt/asdf/libexec/asdf.sh"

# . "${HOME}/.oh-my-zsh/custom/plugins/zsh-poetry/poetry.zsh"

if [[ ! -d ~/.zsh-autopair ]]; then
  git clone https://github.com/hlissner/zsh-autopair ${HOME}/zsh-addons/zsh-autopair
fi

source ${HOME}/zsh-addons/zsh-autopair/autopair.zsh && autopair-init

GRC=$(/usr/local/bin/grc)
if [ $? -eq 0 ]; then
    alias colorify='$GRC -es --colour=auto'
    alias as='colorify as'
    alias configure='colorify ./configure'          # idk about this one. will need to check it out.
    alias curl='colorify curl'
    alias dig='colorify dig'
    alias du='colorify du'
    alias g++='colorify g++'
    alias gcc='colorify gcc'
    alias head='colorify head'
    alias ifconfig='colorify ifconfig'
    alias ip='colorify dig +short myip.opendns.com @resolver1.opendns.com'
    alias localip='ipconfig getifaddr en0'
    alias make='colorify gmake'
    alias mount='colorify mount'
    alias netstat='colorify netstat'
    alias ping='colorify prettyping --nolegend'
    alias ps='colorify ps'
    alias tail='colorify tail'
    alias traceroute='colorify traceroute'
fi

# {{{

if [[ "$TERM" == "xterm-kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
fi


source "${HOME}/zsh-addons/poetry.zsh"
source "${HOME}/zsh-addons/zsh-autocomplete/zsh-autocomplete.plugin.zsh"


#}}}


# This is left empty st brew python and env vars arent friends yet...?
# export BROWSER='/System/Volumes/Data/Applications/Safari.app/Contents/MacOS/Safari'

# export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/man:/usr/local/share/man:/usr/share/man:${MANPATH}"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export MANPAGER='col -bpx | bat -l man -p'
export EDITOR=nvim
export VISUAL=nvim


# By default, zsh considers many chars part of a word (ex: _ & -).
# Narrow that down to allow easier skipping thru words via M-f & M-b
export WORDCHARS='*?[]~&;!%^<>'

# @see: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
if which rg >/dev/null; then
    export RIPGREP_CONFIG_PATH='/Users/eo/.config/rg/rgrc'
fi

# -------------------------- fzf-tab ---------------------------------------#{{{

zstyle ':autocomplete:tab:*' widget-style menu select
zstyle ':completion:*' menu-select

# }}}

# source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh


# ---------------------------------- FZF ------------------------------------- #{{{
# export FZF_BASE="/usr/local/opt/fzf/bin"
# --exact \
# --preview-window='bottom:40%:hidden' \
export FZF_DEFAULT_OPTS="
    --tiebreak=length,begin --ansi --multi --reverse --margin=0,1
    --info=inline --height=75%
    --preview-window='top:40%:hidden'
    --bind='?:toggle-preview'
    --preview='([[ -f {} ]] && (bat --color=always {}
                || cat {})) || ([[ -d {} ]] && (tree -C {} | less))
                echo {} 2>/dev/null | head -200'
    --prompt='❯ ' --pointer='▶' --marker='✓'
    --bind='ctrl-a:select-all'
    --bind='ctrl-c:execute-silent(echo {+} | pbcopy)'
    --bind='ctrl-e:execute(echo {+} | xargs -o ${EDITOR})'
    --bind='ctrl-u:preview-page-up'
    --bind='ctrl-d:preview-page-down'
    --color='bg+:#262626,fg+:#DADADA,hl:#F09479,hl+:#F09479'
    --color='border:#303030,info:#CFCFB0,header:#80A0FF,spinner:#36C692'
    --color='prompt:#87AFFF,pointer:#FF5189,marker:#F09479'"

# --bind='ctrl-v:execute(code {+})'\
FD_OPTIONS="--color=never --follow --hidden --exclude '.git' --exclude 'node_modules'"
export FZF_DEFAULT_COMMAND="fd ${FD_OPTIONS} ."
# export FZF_CTR_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_CTR_T_COMMAND="${FZF_DEFAULT_COMMAND} -t f ${HOME}"
export FZF_CTR_T_OPTS='--preview "bat --color=always --line-range :500 {}"'
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} -t d ${HOME}"
export FZF_ALT_C_OPTS='--preview "tree -C {} | head -100" '
# }}}

# ------------------------------- Zoxide ------------------------------------- #{{{

export _ZO_MAXAGE='1000'
export _ZO_FZF_OPTS='
    --no-sort --height 75% --reverse --margin=0,1 --exit-0 --select-1
    --bind ctrl-f:page-down,ctrl-b:page-up
    --bind pgdn:preview-page-down,pgup:preview-page-up
    --prompt="❯ "
    --color bg+:#262626,fg+:#DADADA,hl:#F09479,hl+:#F09479
    --color border:#303030,info:#CFCFB0,header:#80A0FF,spinner:#36C692
    --color prompt:#87AFFF,pointer:#FF5189,marker:#F09479
    --preview "exa --color=always --group-directories-first --oneline {2..}
'

# }}}

# ---------------------------------- eval ------------------------------------ #{{{

if exists thefuck; then
  eval "$(thefuck --alias)"
fi

if exists zoxide; then
  eval "$(zoxide init zsh --cmd z)"
fi

if exists gh; then
  eval "$(gh completion -s zsh)"
fi

if exists pip; then
  eval "$(pip completion --zsh)"
fi

if exists fnm; then
  eval "$(fnm env)"
fi

if exists navi; then
  eval "$(navi widget zsh)"
fi

if exists mcfly; then
  eval "$(mcfly init zsh)"
  # source <$(mcfly init zsh)
fi

if exists pipx; then
    eval "$(/Users/eo/.pyenv/versions/3.9.0/bin/register-python-argcomplete pipx)"
fi

if [[ -n $KITTY_INSTALLATION_DIR ]]; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi

# }}}

# stolen from viesti/dotfiles
# local _myhosts
# _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
# zstyle ':completion:*' hosts "$_myhosts"

# this allows using neovim remote when nvim is called from inside a running vim instance
# XXX: maybe put into zshenv?
# if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
#   alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
# fi

#------------------------------ OMZ ------------------------------------------- #{{{
# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"

HYPHEN_INSENSITIVE=1
# DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=3

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom/plugins/"

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git dotenv gh macos colorize colored-man-pages git-lfs poetry)

source $ZSH/oh-my-zsh.sh
# }}}
# ---------------------------- Aliases ---------------------------- #{{{
# alias -g fire='/Applications/Firefox.app/Contents/MacOS/firefox &'

alias tail-nvim="tail -f ${*}" # how was this supposed to work?

alias ruby='/usr/local/opt/ruby/bin/ruby'

alias icat='kitty +kitten icat'
alias dotfiles='/usr/local/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'

# alias whois='gwhois'

alias  ls='exa --icons'                             # ls
alias   l='exa -lbF --git --icons'                  # list, size, type, git
alias  ll='exa -lbGF --git --icons'                 # long list
alias llm='exa -lbGF --git --sort=modified --icons' # long list, modified date sort
alias  la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale --icons' # all list
alias  lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --icons' # all + extended list

alias lS='exa -1 --icons' # one column, just names.. idk
alias lt='exa --tree --level=3 --icons' # tree style, try to incorp as-tree?
alias lc='exa --git --icons --color-scale -lFbh -s=size'
# alias -g ls='exa -g -F --icons --group-directories-first --git'
# alias -g lsa='exa -a -T -F --icons --git'
# alias -g lt='exa -T -L 2 -F --icons --git'

# alias -g hh='tldr'

# alias xargs='/usr/local/opt/coreutils/libexec/gnubin/xargs'
alias xargs="gxargs"
# alias jtext='${HOME}/.local/bin/jupytext --set-formats ipynb,py:percent $@.ipynb'
jtext() {
    ${HOME}/.local/bin/jupytext --formats ipynb,py:percent ${*}.ipynb
    # ${HOME}/.local/bin/jupytext --formats ipynb,py ${@}.ipynb
    # ${HOME}/.local/bin/jupytext --sync ${@}.ipynb
    # ${HOME}/.local/bin/jupytext --from {$1}.ipynb --to ${1}.py ${@}.ipynb
}
alias jnb='jupyter lab --ip=0.0.0.0 --port=8080 --allow-root --no-browser'

alias nbp="nbp -t material -u -n -m --cs truecolor"

alias zshrc='nvim ~/.zshrc'
alias reload='exec ${SHELL}'

alias -g bif='brew info'
alias -g bish='HOMEBREW_NO_AUTO_UPDATE=1 brew install'
alias -g bs='brew search'

alias -g shrug="echo \¯\\\_\(\ツ\)\_\/\¯ | pbcopy"

alias diff="delta --line-numbers --navgivate --side-by-side --syntax-theme='Dracula'"

alias yt='yt-dlp --external-downloader aria2c --progress'

# alias ping='colorify /sbin/ping'
alias publicip='curl -s checkip.amazonaws.com'
alias ports='lsof -iTCP -P -sTCP:LISTEN'
alias lanips='ifconfig -a | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"'

alias ncdu='ncdu --color=dark --si'
alias du='du -sh | sort -hr'
alias dust='dust --si'

alias luamake=/Users/eo/lsp/lua-language-server/3rd/luamake/luamake

alias lpath='echo ${PATH} | tr ":" "\n"'
alias lg="git log --color --graph --pretty=format:'%Cred%h%Creset %>(32)%cD -%C(yellow)%d%Creset %<(35,trunc)%s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

alias rm='trash'

alias chktermfont='echo -e "\nnormal flower\n\e[1mboldflower\e[0m\n\e[3mitalic flower\e[0m\n\e[3m\e[1mbold italic flower\e[0m\n\e[4munderline flower\e[0m\n\e[9mstrikethrough flower\e[0m\n\e[4:3mcurly underline flower\e[4:0m\n\e[4:3\e[58:mcurlyunderlinewithcolor flower\e[59m\e[4:0m"'

alias cht='cht.sh'
alias c='clear'
alias cc='clear'
# }}}


## Testing TESTING
# NOTE figure out how to set this up for rust and golang also!
# alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

# ---------------------------------- f(x)s --------------------------------------#{{{

ansi() { echo -e "\e[${1}m${*:2}\e[0m"; }
bold() { ansi 1 "$@"; }
italic() { ansi 3 "$@"; }
underline() { ansi 4 "$@"; }
strikethrough() { ansi 9 "$@"; }
red() { ansi 31 "$@"; }
# EXAMPLE: echo "some $(strikethough hello world) text"

# function _accept-line() {
#   if [[ $BUFFER == "." ]]; then
#     BUFFER=". ~/.zshrc" fi zle .accept-line
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

# o() {
#     fzf | xargs -r -o nvim
# }

bip() {
    local inst=$(brew search | fzf -m)

    if [[ $inst ]]; then
        for prog in command ${inst};
            do brew install "${prog}";
        done;
    fi
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0 --preview\
  'bat --theme="OneHalfDark" --color "always" {}' --preview-window=right:60% ))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
        git diff "$sha"
    elif [[ "$k" == 'ctrl-b' ]]; then
        git stash branch "stash-$sha" "$sha"
        break;
    else
        git stash show -p "$sha"
    fi
  done
}


# Find-in-file -> usage: 'fif <SEARCH_TERM>' or fif "string with spaces" or fif "regex"
fif() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!";
        return 1;
    fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages \
        "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" && \
        echo "opening $file" && open "$file" || return 1;
    # rg --files-with-matches --no-messages "$1" |
    # fzf FZF_PREVIEW_WINDOW="--preview 'rg --ignore-case --pretty --context 10 '$1' {}'"
}

# fjrnl - Search JRNL headlines
fjrnl() {
    local line
    [ -e tags ] &&
    line=$(
        awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
        cut -c1-80 | fzf --nth=1,2
        ) && ${EDITOR:-nvim} $(cut -f3 <<< "$line") -c "set nocst" \
            -c "silent tag $(cut -f2 <<< "$line")"
}

# ALT-I - Paste the selected entry from locate output into the command line
fzf-locate-widget() {
    local selected
    if selected=$(locate / | fzf -q "$LBUFFER"); then
        LBUFFER=$selected
    fi
    zle redisplay
}
zle     -N    fzf-locate-widget
bindkey '\ei' fzf-locate-widget

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

# Install (1 or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]ackage
bip() {
    local inst=$(brew search "$@" | fzf -m)
    if [[ $inst ]]; then
        for prog in $(echo $inst);
            do brew install $prg
        done
    fi
}

bup() {
    local upd=$(brew leaves | fzf -m)

    if [[ $upd ]]; then
        for prog in $(echo $upd);
        do; brew upgrade $prog; done;
    fi
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

# function default_shell() {
#   dscl . -read ~/ UserShell | sed 's/UserShell: //'
# }

spotlight() { mdfind "kMDItemDisplayName == \"$*\" wc"; } # \"$@\"

export HOWDOI_COLORIZE=1
hdi(){ howdoi "$*" -c -n 5; }

# rga-fzf interactivity
rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort \
                --reverse \
                --preview="[[ ! -z {} ]] && rga --pretty --context 6 {q} {}" \
                --phony \
                -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="top:80%"
    )" &&
    echo "opening $file" &&
    open -n "$file" .
}

# ^^^^  from above, changed context from 5 to 9
#       added --reverse and "top" as results should be previewed above search

# fzf --bind '?:preview:cat {}' --preview-window hidden
# palatte of colors
palette() {
    local -a colors
    for i in {000..255}; do
        colors+=("%F{$i}$i%f")
    done
    print -cP colors
}
# }}}

source "${HOME}/do-ls"

# . ${HOME}/Dev/RandomRepos/fzf-tab/fzf-tab.plugin.zsh
# kitty + complete setup zsh | . /dev/stdin


# export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
# export LESSOPEN='| ~/.lessfilter %s'

# export HOMEBREW_FORCE_BREWED_CURL=1 HOMEBREW_BAT=1 HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_COLOR=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_{FORCE_BREWED_CURL,BAT,NO_INSTALL_CLEANUP,COLOR,NO_ANALYTICS,NO_AUTO_UPDATE}=1
# export HOMEBREW_AUTO_UPDATE_SECS=86400 # sec/day
# export HOMEBREW_AUTO_UPDATE_SECS="2592000" # sec/month

export HOMEBREW_AUTO_UPDATE_SECS="1296000" # sec/2wks



# HBREW_GH_IPA=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 # this must be temporary.
# export HOMEBREW_GITHUB_API_TOKEN=$HBREW_GH_IPA

export PATH="${HOME}/.local/bin:${HOME}/.poetry/bin:/usr/local/opt/gnupg/bin:${PATH}"

# export PATH="/Users/eo/.local/bin:${PATH}"

source "$HOME/zsh-addons/pip-fzf/pip_fzf.sh"


HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"

if [ -f "$HB_CNF_HANDLER" ]; then
    source "$HB_CNF_HANDLER";
fi


source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
# export GPG_TTY=$(tty)
# autoload -Uz compinit
# fpath+=~/.zfunc


[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
autoload -Uz compinit
# vim:ft=zsh set fdm=marker tw=120 ts=4 sts=4
