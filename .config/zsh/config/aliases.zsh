# ZSH ONLY and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (($+commands[$1])); }

alias icat='kitten icat'
(($+commands[rga])) && alias rga='rga --rga-adapters="+poppler,pandoc"'
(($+commands[ptpython])) && alias ipython='ptipython --config-file=$HOME/Library/Application\ Support/ptpython/config.py'
(($+commands[ptpython])) && alias ptpython='ptipython --config-file=$HOME/Library/Application\ Support/ptpython/config.py'

taocl() {
    curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
        sed 'cowsay[.]png/d' |
        pandoc -f markdown -t html |
        xmlstarlet fo --html --dropdtd |
        xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
        xmlstarlet unesc | fmt -80 | inconv -t US
}

# NOTE The drawback of this approach is that runic can only be invoked from the shell and not by
# other programs! <- Maybe thats why conform.nvim keeps erroring out?!
# alias runic="julia --project=@runic -e 'using Runic; exit(Runic.main(ARGS))' --"

if exists nvim; then
    alias vim=nvim
    alias vi=nvim
fi

alias q=' exit'
alias reload=' exec zsh'
# alias r=' exec zsh' # this will get confused with r-lang
alias cmd='command'

alias mv='mv -vi'
# alias ln='ln -visf'

alias cp='cp -vi'
# alias rm='rm -I'
alias curl='curl --progress-bar "$@"'
alias tokei='tokei --compact --exclude="*.{txt,json}"'

alias gn='z ~/.config/nvim/'
alias zshrc="${EDITOR} $ZDOTDIR/.zshrc"
alias bif='brew info'
alias bs='brew search'
alias bish='env HOMEBREW_NO_AUTO_UPDATE=1 brew install --build-from-source'

# (( $+commands[ptpython] )) && alias ptipython='ptipython --config-file=~/.config/ptpython/config.py'
(($+commands[jupyter-lab])) && alias jnb='jupyter-lab --ip=0.0.0.0 --port=8080 --allow-root'
(($+commands[nbp])) && alias nbp='nbp --cs=truecolor -t material -unm "$@"'
(($+commands[dig])) && alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
(($+commands[lsof])) && alias ports='lsof -iTCP -P -sTCP:LISTEN'
(($+commands[tac])) || alias tac='tail -r'

alias zip='zip --recurse-paths --symlinks "$@"'

alias brewfile="brew bundle dump --describe --vscode --mas  --global --force"

if exists pigz; then
    alias gzip='pigz "$@"'
    alias gunzip='pigz -d "$@"'
    alias zcat='pigz -dc "$@"'
fi

add_to_path() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# UTF8-encode a string of unicode symbols
escape() {
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
    if [ -t 1 ]; then
        echo "" # newline
    fi
}

# # print a newline unless we we're piping the output to another program
# if [ -t 1 ]; then
#     echo ""; # newline
# fi;
# decode \x{ABCD}-style unicode escape sequences

unidecode() {
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
    if [ -t 1 ]; then
        echo "" # newline
    fi
}

codepoint() {
    perl -e "use utf8; print sprintf('U+%04X', org(\"$@\"))"
    if [ -t 1 ]; then
        echo "" # newline
    fi
}

# romkatv/dotfiles-public/blob/master/.zshrc
# (( $+commands[tree]  )) && alias tree='tree -aC -I .git --gitignore --dirsfirst'
if exists tree; then
    alias tree='tree --si --du -aC'
    alias tr3='tree -aC -I .git --gitignore --dirsfirst'
fi

if exists dust; then
    alias dust='dust -o si "$@"'
fi

if exists gifsicle; then
    gifme() {
        ffmpeg -i "$1" -vf scale=$2:-1:flags=lanczos -f gif - | gifsicle --optimize=3 --delay=3 >$3
    }
fi

if exists gping; then
    alias ping="$BREW_PREFIX"/bin/gping
fi

ic() {
    images=$(fd . "${1:-/Users/eo/Downloads}" -tf -d2 -e png -e jpg -e jpeg -e webm -e gif |
        fzf --cycle --preview='kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}')
    [ -z "$image" ] || pbcopy "$image"
}

alias NULL=" >/dev/null 2>&1"
alias NUL=" 2>/dev/null"
alias NL=" >/dev/null"

# razak17/dotfiles/blob/main/.config/zsh/scripts/utils
# ch() {
#     chmod -R 777 "$@"
# }

cx() {
    chmod +x "$@"
}

# zshcomp() {
#     for command completion in "${(kv)_comps:#-*(-|-,*)}";
#     do
#         printf "%-32s %s\n" $command $completion
#     done | sort
# }

#### razak finished

logg() {
    "${@}" > >(tee "$(basename "${1}").log")
}

pdf_open() {
    fd -e pdf "${1}" . 2 &>1 | fzf | xargs -i open {}
}

# launch programs from commandline w/o messing up your current pty
# usage: "standalone <your full command>"
standalone() {
    "${@}" >/dev/null 2>&1 &
}

weather() {
    if [ "${1}" = "-h" ]; then
        curl "wttr.in/:help"
    else
        curl "wttr.in/?A2Fn${@}"
    fi
}

mediadiff() {
    nvim -d <(mediainfo "$1") <(mediainfo "$2")
}

# join a glob with the given delimiter
join() {
    local IFS=$1
    shift
    echo "${*}"
}

explain() {
    open "https://explainshell.com/explain?cmd=${1}"
}

ansi() { echo -e "\e[${1}m${*:2}\e[0m"; }
bold() { ansi 1 "$@"; }
italic() { ansi 3 "$@"; }
underline() { ansi 4 "$@"; }
strikethrough() { ansi 9 "$@"; }
red() { ansi 31 "$@"; }

speedtest() {
    curl -s "https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py" | python3 -
}

ipinfo() {
    curl "https://ipinfo.io/$1" || curl "icanhazip.com"
}

# NOTE: Unnecessary, thanks to bob-nvim
#
# build-nvim() {
#     neovim_dir="$PROJECTS_DIR/eo_contrib/neovim"
#     [ ! -d $neovim_dir ] && git clone git@github.com:neovim/neovim.git $neovim_dir
#     pushd $neovim_dir
#     git checkout master
#     # git checkout origin/HEAD
#     git pull
#     [ -d "$neovim_dir/build/" ] && rm -r ./build/  # to clear the cmake cache
#     make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/dev/eo_contrib/neovim"
#     make install
#     popd || exit
# }

fancy-ctrl-z() {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# ALT-I - Paste the selected entry from locate output into the command line
# must be a faster, newer method than locate, like... ZoXiDe or fd!
# fzf-locate-widget() {
#     local selected
#     if selected=$(locate / | fzf -q "$LBUFFER"); then
#         LBUFFER=$selected
#     fi;
#     zle redisplay
# }
#
# zle -N fzf-locate-widget
# bindkey '\ei' fzf-locate-widget

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

hdi() { howdoi "$*" -c -n 9; }

zd() {
    local dir
    dir=$(zoxide query -l | fzf)
    cd "$dir" || exit
}

# rga-fzf interactivity
# rgaf() {
#     RG_PREFIX="rga --files-with-matches"
#     local file
#     file="$(
#         FZF_DEFAULT_COMMAND="$RG_PREFIX \'$1\'" \
#             fzf --sort --reverse --preview=\"[[ ! -z {} ]] && rga --pretty --context=5 {q} {}\" \
#             --phony -q \"$1\" \
#             --bind \"change:reload:$RG_PREFIX {q}\" \
#             --preview-window=\"down,70%:wrap,border-up\" \
#     )" && \
#         # Might help to convert to text and open said txt file instead, or
#         # as an option
#         echo "opening $file" && \
#         open "$file" || exit
# }

envs() {
    printenv | fzf
}

if exists hors; then
    alias ho='hors -a -l -n 5 "$*"'
fi

alias cpwd='pwd | tr -d "\n" | pbcopy'

if exists tidy-viewer; then
    alias tv='tidy-viewer -a'
fi

alias gpg-add="echo | gpg -s >/dev/null >&1"

# alias e='eza --all --long --time-style=relative --no-user --total-size --smart-group --no-quotes --sort=newest'
# alias tre='eza --tree --level=7 --no-quotes --icons=always --color=always | less'

if exists eza; then
    alias eza='eza --color=always --icons --color-scale --smart-group --no-quotes --no-user'
    alias ls='eza -Gl'
    alias lsa='eza -lbhF --git -s=newest'
    alias ll='eza -lbhF --git -s=size'
    alias ldot='ll -D .'
    alias lm='eza -lbGF --git -s=modified'
    # alias lx='eza -lbhHUmua@ --time-style="+%d/%m/%Y" --git --no-permissions --no-user --no-filesize'
    alias lx='eza -lbhHUmua@ --time-style=relative --no-permissions --no-filesize'
    alias lt='eza --tree --level=3'
    alias lT='eza --tree --level=7'
fi
if exists lsd; then
    alias lsd='lsd --color=always --icon=always -lagF'
    alias ldt='lsd -Rd --size=short --permission=octal ./*'
    alias lss='lsd -S' # -S  --sizesort          == sort by size
    alias lsm='lsd -t' # -t  --timesort          == sort by time modified
    alias lsx='lsd -X' # -X  --extensionsort     == sort by file extension
    alias lsg='lsd -G' # -G  --gitsort           == sort by git status
fi

alias ppath='echo -e ${PATH//:/\\n}'
alias chkfpath='echo -e ${FPATH//:/\\n}'

alias -g shrug="echo \¯\\\_\(\ツ\)\_\/\¯ | pbcopy"

# TODO: pipe into pv or whatever new cli progress meter app is out there? pueue or px?
alias yt='yt-dlp --external-downloader aria2c --progress "$@"'

alias publicip='curl -s checkip.amazonaws.com'
alias localip="ipconfig getifaddr en0" # --> for for macos, not linux, use below for linux
alias lanips='ifconfig -a | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"'

alias hr='printf $(printf "\e[$(shuf -i 91-97 -n 1);1m%%%ds\e[0m\n" $(tput cols)) | tr " " ='

alias lg="git log --color --graph --pretty=format:'%Cred%h%Creset %>(32)%cD -%C(yellow)%d%Creset %<(35,trunc)%s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

alias rm='trash'

alias chktermfont='echo -e "\nnormal flower\n\e[1mboldflower\e[0m\n\e[3mitalic flower\e[0m\n\e[3m\e[1mbold italic flower\e[0m\n\e[4munderline flower\e[0m\n\e[9mstrikethrough flower\e[0m\n\e[4:3mcurly underline flower\e[4:0m\n\e[4:3\e[58:mcurlyunderlinewithcolor flower\e[59m\e[4:0m"'

alias stfu='osascript -e "set volume output muted true"'

alias volumeup='osascript -e "set volume output volume 95"'
alias volumedown='osascript -e "set volume output volume 15"'

alias spoton="sudo mdutil -a -i on"
alias spotoff="sudo mdutil -a -i off"
sk
#  NOTE: second trial
#  intuitive map func
#  ex: to list all directories that contain a certain file:
#  find . -name .gitattributes | map dirname
alias map="xargs -n1"

alias exportenv='while read -r f; do echo ''; done <<(env) > .env'

# alias hor='function hors() { hors "$*" -a -l -e "stackoverflow"; }; hors'

# function bat {
#     local theme
#     theme="$(defaults read -g AppleInterfaceStyle &>/dev/null && echo "Sublime Snazzy" || echo "Monokai Extended Light")"
#     command bat --theme="$theme" "$@"
# }

function export_mason_path() {
    export PATH="$HOME/.local/share/nvim/mason/bin":$PATH
}

function which {
    builtin which -a "$@" | bat --style="-numbers,grid" --wrap=character --pager="<$(lesspipe.sh | source /dev/stdin)"
}

function take {
    mkdir -p "$1" && cd "$1" || return 1
}

function topen {
    touch "$1" && open "$1"
}

function p() {
    # Desc: Opens files in MacOS quicklook
    # Args: $1 (optional): File to open in quicklook
    # Usage: p [file1] [file2]
    qlmanage -p "${1}" &>/dev/null # or "$1" ??
}

# GLOBAL ALIAS to be used at the end of the buffer, mostly
alias -g RG=' rga'
alias -g G='| rg'
alias -g B='| bat'
alias -g N='| wc -l | tr -d " "' # count lines
alias -g L='| less'
alias -g J='| yq --prettyPrint --output-format=json --colors | less'
alias -g C='| pbcopy ; echo "Copied."'
alias P='pbpaste'
alias ils='timg --grid=3x1 --upscale=i --center --title --frames=1 -bgray -Bdarkgray'

# ZSH_HIGHLIGHT_REGEXP+=(' G(S$| )' 'fg=magenta,bold')
# ZSH_HIGHLIGHT_REGEXP+=(' C$' 'fg=magenta,bold')
# ZSH_HIGHLIGHT_REGEXP+=(' B$' 'fg=magenta,bold')
# ZSH_HIGHLIGHT_REGEXP+=(' N$' 'fg=magenta,bold')
# ZSH_HIGHLIGHT_REGEXP+=(' L$' 'fg=magenta,bold')
# ZSH_HIGHLIGHT_REGEXP+=(' J$' 'fg=magenta,bold')
# ZSH_HIGHLIGHT_REGEXP+=('^P ' 'fg=magenta,bold') # only start of line

# vim: ft=zsh ts=8 sw=4 sts=4 tw=100 et ai:
