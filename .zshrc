# vim:ft=zsh foldmethod=marker
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  . "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------- Homebrew ---------------------------------#
# export GPG_TTY=$(tty)
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt"

fpath+=(
    "/usr/local/share/zsh/functions"
    "/usr/local/share/zsh-completions"
    "/usr/local/share/zsh/site-functions"
    "/Users/eo/.zfunc"
    $fpath
)

# ------------------------------ extra paths -------------------------------#
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-14.0.2.jdk/Contents/Home"
export JAVA_BIN="${JAVA_HOME}/bin"
export GOPATH="${HOME}/go"
export GOROOT='/usr/local/opt/go/libexec' # This is faster?

# NOTE: Testing to see if zsh path() is different thatn exporting path

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

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
  # "/usr/local/opt/gnupg/bin" # need to get away from macgpg2 shit for gh to work
  # this doesnt work need to add it above local/bin
  # "${HOME}/.cargo/bin"
  # "/usr/local/opt/coreutils/libexec/gnubin"
)
# /usr/local/bin:/usr/local/sbin:/usr/local/opt
export PATH="${PATH}:/usr/bin:/bin:/Applications/kitty.app/Contents/MacOS/kitty:/usr/sbin:/sbin:/usr/local/Cellar/emacs/27.2/bin/emacs:${HOME}/.emacs.d/bin:/usr/local/opt/luajit-openresty/bin"
# export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt:/usr/bin:/bin:/Applications/kitty.app/Contents/MacOS/kitty:/usr/sbin:/sbin:/usr/local/Cellar/emacs/27.2/bin/emacs:${HOME}/.emacs.d/bin:/usr/local/opt/luajit-openresty/bin"
# export PATH="${PATH}:/usr/local/bin:/usr/local/sbin:/usr/local/opt:/usr/bin:/bin:/Applications/kitty.app/Contents/MacOS/kitty:/usr/sbin:/sbin:/usr/local/Cellar/emacs/27.2/bin/emacs:${HOME}/.emacs.d/bin:/usr/local/opt/luajit-openresty/bin"


eval "$(pyenv init --path)"
eval "$(pyenv init - )"
eval "$(pyenv virtualenv-init -)"

. "/usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme"
export EXA_COLORS="uu=0:gu=0"
export LS_COLORS="$(vivid generate snazzy)"
export LSCOLORS="$(vivid generate snazzy)"
# export EXA_COLORS=${LS_COLORS-LSCOLORS}
export EXA_COLORS=${LS_COLORS:-LSCOLORS}
# . "/usr/local/opt/asdf/libexec/asdf.sh"

# . "${HOME}/.oh-my-zsh/custom/plugins/zsh-poetry/poetry.zsh"

if [[ ! -d ~/.zsh-autopair ]]; then
  git clone https://github.com/hlissner/zsh-autopair ~/zsh-addons/zsh-autopair
fi

source ~/zsh-addons/zsh-autopair/autopair.zsh && autopair-init

# {{{
# zstyle ':autocomplete:*' default-context ''
# zstyle ':autocomplete:tab:*' widget-style menu-select # menu-select, complete-word
# zstyle ':autocomplete:*' min-delay 0.06
# zstyle ':autocomplete:*' list-lines 12
# zstyle ':autocomplete:history-search:*' list-lines 8
# zstyle ':autocomplete:*' min-input 1
# zstyle ':autocomplete:*' ignored-input ''
# zstyle ':autocomplete:*' fzf-completion yes
# zstyle ':autocomplete:*' recent-dirs zoxide
# zstyle ':autocomplete:*' recent-dirs cdr

# zstyle ':autocomplete:*' insert-unambiguous no
# no:  Tab inserts the top completion.
# yes: Tab first inserts a substring common to all listed completions, if any.

# zstyle ':autocomplete:*' add-space \
#     executables aliases functions builtins reserved-words commands

# zstyle ':autocomplete:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ${(s.:.)LSCOLORS}

# if [[ xterm-kitty == xterm-kitty ]]; then
kitty + complete setup zsh | . /dev/stdin
# fi

# zstyle ':completion:*' list-colors ''

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
# zstyle ':completion:*' menu select

# zstyle ':completion:*' rehash true

# Allow completion of ..<Tab> to ../ and beyond.
# zstyle ':completion:*' list-colors ${(s.:.)EXA_COLORS}
# zstyle ':autocomplete:*' list-colors ${(s.:.)LS_COLORS} >????

. "${HOME}/zsh-addons/poetry.zsh"
. "${HOME}/zsh-addons/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
# zstyle -e ':completion:*' special-dirs "[[  = (../)#(..) ]] && reply=(..)"

# Up arrow:
# bindkey '\e[A' up-line-or-search
# bindkey '\eOA' up-line-or-search
# up-line-or-search:  Open history menu.
# up-line-or-history: Cycle to previous history line.
#########################
## these will probably interfere... change for now: 01/13/2022
## zsh-history-substring-search key bindings
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

# Down arrow:
# bindkey '\e[B' down-line-or-select
# bindkey '\eOB' down-line-or-select
# down-line-or-select:  Open completion menu.
# down-line-or-history: Cycle to next history line.

# Control-Space:
# bindkey '\0' list-expand
# list-expand:      Reveal hidden completions.
# set-mark-command: Activate text selection.

# Uncomment the following lines to disable live history search:
# zle -A {.,}history-incremental-search-forward
# zle -A {.,}history-incremental-search-backward

# Return key in completion menu & history menu:
# bindkey -M menuselect '\r' .accept-line
# .accept-line: Accept command line.
# accept-line:  Accept selection and exit menu.


# }}}


# This is left empty st brew python and env vars arent friends yet...?
# export BROWSER='/System/Volumes/Data/Applications/Safari.app/Contents/MacOS/Safari'

# export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/man:/usr/local/share/man:/usr/share/man:${MANPATH}"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export MANPAGER='col -bpx | bat -l man -p'
export EDITOR=nvim
export VISUAL=nvim
# export MANPAGER='nvim +Man!'

# export LC_ALL="en_US.UTF-8"

# By default, zsh considers many chars part of a word (ex: _ & -).
# Narrow that down to allow easier skipping thru words via M-f & M-b
export WORDCHARS='*?[]~&;!%^<>'
export RIPGREP_CONFIG_PATH='/Users/eo/.config/rg/rgrc'
# -------------------------- fzf-tab ---------------------------------------#{{{

# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ":fzf-tab:*" fzf-flags '--color=bg+:23'
# zstyle ':fzf-tab:*' switch-group ',' '.'
# zstyle ':fzf-tab:*' show-group brief
# zstyle ':fzf-tab:*' show-group full
# zstyle ':fzf-tab:*' print-query alt-enter

# zstyle ':fzf-tab:complete:*' fzf-bindings \
#         "ctrl-v:execute-silent({_FTB_INIT_}code \"$realpath\")" \
#         "ctrl-e:execute-silent({_FTB_INIT_}kwrite \"$realpath\")"

# zstyle ':completion:*' fzf-search-display true
# zstyle ':completion:*:descriptions' format "[%d]"
# zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'

# zstyle ':fzf-tab:complete:_zoxide:*' query-string input
# zstyle ':fzf-tab:complete:cd:*' fzf-preview "exa -1 --color=always $realpath"
# zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
# zstyle ':completion:*:ls:*' fzf-completion-opts --preview="([[ -f {} ]] && (bat --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) echo {} 2> /dev/null | head {2}"

# zstyle ':fzf-tab:complete:*:*' fzf-preview "less ${(Q)realpath}"

# zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview "echo ${(P)word}"

# zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview "[[ $group == \"[process ID]\" ]] && ps --pid=$word -o cmd --no-headers -w -w"
# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window='down:30%:wrap'
# zstyle ':fzf-tab:complete:(kill|ps):*' popup-pad 0 3

# some fzf-tab-completion/zsh-completion opts disable sort when completing options of any command
# zstyle ':completion:complete:*:options' sort true
# lets test this git checkout completion snippet out first.
# zstyle ':completion:*:git:git,add,*' fzf-completion-opts --preview='git -c color.status=always status --short'

# it is an example. you can change it
# zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview "git diff $word | delta"

# zstyle ':fzf-tab:complete:git-log:*' fzf-preview "git log --color=always $word"

# zstyle ':fzf-tab:complete:git-help:*' fzf-preview "git help $word | bat -plman --color=always"

# zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
# 	"case \"$group\" in
#     		\"commit tag\") git show --color=always $word ;;
#     		*) git show --color=always $word | delta ;;
# 	esac"

# zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
# 	"case \"$group\" in
#     		\"modified file\") git diff $word | delta ;;
#     		\"recent commit object name\") git show --color=always $word | delta ;;
#     		*) git log --color=always $word ;;
# 	esac"

# zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview "run-help $word"
# zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview "man $word"

# zstyle ':autocomplete:*' add-space group-order executables commands options builtins expansions

# zstyle ':autocomplete:*' default-context ''
# zstyle ':autocomplete:*' min-delay 0.1
# zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select

# }}}
# export BAT_STYLE=full

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# .d autocomplete before OMZ to see how it works with fzf-tab/color completion

# ------------------------------------ FZF -------------------------------------#
# export FZF_BASE="/usr/local/opt/fzf/bin"
export FZF_DEFAULT_OPTS=" \
    --tiebreak=length,begin \
    --algo=v2 \
    --exact \
    --layout=reverse \
    --ansi \
    --info=inline \
    --height=40% \
    --multi \
    --preview-window='bottom:40%:hidden' \
    --preview='([[ -f {} ]] && (bat --color=always {} \
                || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) \
                echo {} 2>/dev/null | head -200' \
    --prompt='~ ' --pointer='▶' --marker='✓' \
    --bind='?:toggle-preview' \
    --bind='ctrl-a:select-all' \
    --bind='ctrl-c:execute-silent(echo {+} | pbcopy)' \
    --bind='ctrl-e:execute(echo {+} | xargs -o ${EDITOR})' \
    --bind='ctrl-f:preview-page-up' \
    --bind='ctrl-d:preview-page-down'"

# --bind='ctrl-v:execute(code {+})'\
FD_OPTIONS="--color always --follow --hidden --exclude '.git' --exclude 'node_modules'"
export FZF_DEFAULT_COMMAND="fd ${FD_OPTIONS} ."
export FZF_CTR_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} -t d ${HOME}"


# ZSH ONLY and most performant way to cehck existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

if exists thefuck; then
  eval "$(thefuck --alias)"
fi

if exists zoxide; then
  eval "$(zoxide init zsh)"
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
fi

# by default, run-help is aliased to man. Turn it off so that you can access the fx def of run-help (by
# default aliases take precedence over fx's). if you re-. this file, then the alias might already
# be removed, so you need to suppress any error that this may throw.
# unalias run-help 2>/dev/null || true

# stolen from viesti/dotfiles
# local _myhosts
# _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
# zstyle ':completion:*' hosts "$_myhosts"

# this allows using neovim remote when nvim is called from inside a running vim instance
# TODO: maybe put into zshenv?
# if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
#   alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
# fi

#------------------------------ OMZ -------------------------------------------#
# Path to your oh-my-zsh installation.
export ZSH="/Users/eo/.oh-my-zsh"

HYPHEN_INSENSITIVE=1
# DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=3

# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm-dd-yyyy"

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom/plugins/"

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git dotenv gh macos colorize colored-man-pages git-lfs poetry)

. $ZSH/oh-my-zsh.sh

#---------------------------- Everything Else ----------------------------#

# alias -g fire='/Applications/Firefox.app/Contents/MacOS/firefox &'

alias tail-nvim="tail -f " # how was this supposed to work?


alias icat='kitty +kitten icat'
alias dotfiles='/usr/local/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'

alias whois='gwhois'

alias  ls='exa --icons'                      # ls
alias   l='exa -lbF --git --icons'           # list, size, type, git
alias  ll='exa -lbGF --git --icons'          # long list
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

# alias trail="bat <<<${(F)path}"

alias xargs='/usr/local/opt/coreutils/libexec/gnubin/xargs'
alias jtext='${HOME}/.local/bin/jupytext --set-formats ipynb,py:percent *.ipynb'
alias jnb='jupyter lab --ip=0.0.0.0 --port=8080 --allow-root --no-browser'

alias ping='prettyping --nolegend'

alias zshrc='nvim ~/.zshrc'
alias reload='exec ${SHELL}'

alias -g bif='brew info'
alias -g bish='HOMEBREW_NO_AUTO_UPDATE=1 brew install'
alias -g bs='brew search'

alias -g shrug="echo \¯\\\_\(\ツ\)\_\/\¯ | pbcopy"

alias diff="delta --line-numbers --navgivate --side-by-side --syntax-theme='Dracula'"

alias yt='yt-dlp --external-downloader aria2c --progress'

alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'

alias ncdu='ncdu --color=dark --si'
alias du='du -sh | sort -hr'
alias dust='dust --si'

alias luamake=/Users/eo/lsp/lua-language-server/3rd/luamake/luamake

alias lpath='echo ${PATH} | tr ":" "\n"'
alias publicip='curl -s checkip.amazonaws.com'
alias lg="git log --color --graph --pretty=format:'%Cred%h%Creset %>(32)%cD -%C(yellow)%d%Creset %<(35,trunc)%s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

# alias -g map='xargs -n1'

alias rm='trash'

alias chktermfont='echo -e "\nnormal flower\n\e[1mboldflower\e[0m\n\e[3mitalic flower\e[0m\n\e[3m\e[1mbold italic flower\e[0m\n\e[4munderline flower\e[0m\n\e[9mstrikethrough flower\e[0m\n\e[4:3mcurly underline flower\e[4:0m\n\e[4:3\e[58:mcurlyunderlinewithcolor flower\e[59m\e[4:0m"'

alias cht='cht.sh'
alias c='clear'
alias cc='clear'


## Testing TESTING
# NOTE figure out how to set this up for rust and golang also!
# alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

#-----------------------------------f(x)s--------------------------------------#
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
        for prog in $(echo $inst);
        do brew install "$prog"; done;
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


# Find-in-file -> usage: 'fif <SEARCH_TERM>'
fif() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!";
        return 1;
    fi

    rg --files-with-matches --no-messages "$1" |
    fzf FZF_PREVIEW_WINDOW="--preview 'rg --ignore-case --pretty --context 10 '$1' {}'"
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

function default_shell() {
  dscl . -read ~/ UserShell | sed 's/UserShell: //'
}

spotlight() { mdfind "kMDItemDisplayName == \"$@\" wc"; } # \"$@\"

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
                --preview="[[ ! -z {} ]] && rga --pretty --context 9 {q} {}" \
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


. "${HOME}/do-ls"

# . ${HOME}/Dev/RandomRepos/fzf-tab/fzf-tab.plugin.zsh
# kitty + complete setup zsh | . /dev/stdin


# export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
# export LESSOPEN='| ~/.lessfilter %s'

[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

# export HOMEBREW_FORCE_BREWED_CURL=1 HOMEBREW_BAT=1 HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_COLOR=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_{FORCE_BREWED_CURL,BAT,NO_INSTALL_CLEANUP,COLOR,NO_ANALYTICS,NO_AUTO_UPDATE}="1"
# export HOMEBREW_AUTO_UPDATE_SECS=86400 # sec/day
export HOMEBREW_AUTO_UPDATE_SECS="2592000" # sec/month


eval "$(/Users/eo/.pyenv/versions/3.9.0/bin/register-python-argcomplete pipx)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || . ~/.p10k.zsh

# HBREW_GH_IPA=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 # this must be temporary.
# export HOMEBREW_GITHUB_API_TOKEN=$HBREW_GH_IPA

export PATH="${HOME}.local/bin:${HOME}/.poetry/bin:/usr/local/opt/gnupg/bin:${PATH}"

# export PATH="/Users/eo/.local/bin:${PATH}"

. "${HOME}/zsh-addons/pip-fzf/pip_fzf.sh"
alias ruby='/usr/local/opt/ruby/bin/ruby'
# export PROJECTS_DIR='${HOME}/Dev/Quant/' -- This is set in zshenv
#
HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
if [ -f "$HB_CNF_HANDLER" ]; then
    source "$HB_CNF_HANDLER";
fi
