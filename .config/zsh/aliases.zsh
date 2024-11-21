#!/usr/bin/env zsh
# ZSH ONLY and most performant way to cehck existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (($ + commands[$1])); }

# from wfxr/dotfiles/zsh_aliases
# (( $+commands[ptpython] )) && alias ipython="ptipython --config-file=$HOME/Library/Application\\\ Support/ptpython/config.py"
# if exists ptpython; then
#     alias pipython='ptipython --config-file="~/Library/Application Support/ptpython/config.py"'
# fi

(($ + commands[tac])) || alias tac='tail -r'
# romkatv/dotfiles-public/blob/master/.zshrc
# (( $+commands[tree]  )) && alias tree='tree -aC -I .git --gitignore --dirsfirst'
if exists tree; then
    alias tree='tree --si --du -aC'
    alias tr3='tree -aC -I .git --gitignore --dirsfirst'
fi

if exists dust; then
    alias dust="dust -o si "$@""
fi

if exists gping; then
    alias ping="$BREW_PREFIX/bin/gping"
fi

alias NUL="> /dev/null 2>&1"
alias NL="2> /dev/null"
alias N="> /dev/null"

if exists hors; then
    alias ho="hors -a -l -n 5 "$*""
fi

# sharkdp/bat ideas
# alias cat="bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"
# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
# alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
# ################
# alias -g -- -h='-h 2>&1 | bathelp'
# alias -g -- --help='--help 2>&1 | bathelp'

alias cpwd='pwd | tr -d "\n" | pbcopy'

if exists tidy-viewer; then
    alias tv='tidy-viewer -a'
fi

alias gpg-add="echo | gpg -s >/dev/null >&1"

if exists eza; then
    alias eza='eza --color=always --icons --color-scale-mode=gradient --color-scale'
    alias lS='eza -Gl'
    alias ls='eza -G'
    alias lsa='eza -lbhF --git -s=age'
    alias lsc='eza -lbhF --git -s=size'
    alias ll='eza -lbh --git'
    alias ldot='ll -D .'
    alias lss='ll -s=size'
    alias lm='eza -lbGF --git -s=modified'
    alias lx='eza -lbhHUmua@ --time-style="+%d/%m/%Y" --git --no-permissions --no-user --no-filesize'
    alias lt='eza --tree --level=2'
    alias lT='eza --tree --level=4'
else
    alias lsd='lsd --color=always --icon=always'
    alias lsdf='lsd -lF'
    alias lsdd='lsd -l --header -g'
    alias lSd='lsd -la --header -g'
    # alias ll='lsd -l --header'
    alias ldot='lsd -Rd --size=short --permission=octal ./*'
    alias lss='lsd -S' # -S  --sizesort          == sort by size
    alias lsm='lsd -t' # -t  --timesort          == sort by time modified
    alias lsx='lsd -X' # -X  --extensionsort     == sort by file extension
    alias lsg='lsd -G' # -G  --gitsort           == sort by git status
fi

alias ppath='echo -e ${PATH//:/\\n}'
alias chkfpath='echo -e ${FPATH//:/\\n}'

(($ + commands[jupyter - lab])) && alias jnb='jupyter-lab --ip=0.0.0.0 --port=8080 --allow-root'

(($ + commands[nbp])) && alias nbp="nbp -t material -u -n -m --cs truecolor"

alias -g shrug="echo \¯\\\_\(\ツ\)\_\/\¯ | pbcopy"

# TODO: pipe into pv or whatever new cli progress meter app is out there? pueue or px?
alias yt='yt-dlp --external-downloader aria2c --progress "$@"'

alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias publicip='curl -s checkip.amazonaws.com'
alias localip="ipconfig getifaddr en0" # --> for for macos, not linux, use below for linux
alias ports='lsof -iTCP -P -sTCP:LISTEN'
alias lanips='ifconfig -a | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"'

alias hr='printf $(printf "\e[$(shuf -i 91-97 -n 1);1m%%%ds\e[0m\n" $(tput cols)) | tr " " ='

alias lg="git log --color --graph --pretty=format:'%Cred%h%Creset %>(32)%cD -%C(yellow)%d%Creset %<(35,trunc)%s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

alias rm='trash'

alias chktermfont='echo -e "\nnormal flower\n\e[1mboldflower\e[0m\n\e[3mitalic flower\e[0m\n\e[3m\e[1mbold italic flower\e[0m\n\e[4munderline flower\e[0m\n\e[9mstrikethrough flower\e[0m\n\e[4:3mcurly underline flower\e[4:0m\n\e[4:3\e[58:mcurlyunderlinewithcolor flower\e[59m\e[4:0m"'

# alias notes="z ${SYNC_DIR}/notes/neorg/ && nvim"

alias stfu='osascript -e "set volume output muted true"'

alias volumeup='osascript -e "set volume output volume 95"'
alias volumedown='osascript -e "set volume output volume 15"'

alias spoton="sudo mdutil -a -i on"
alias spotoff="sudo mdutil -a -i off"

#  NOTE: second trial
#  intuitive map func
#  ex: to list all directories that contain a certain file:
#  find . -name .gitattributes | map dirname
alias map="xargs -n1"
alias exportenv='while read -r f; do echo ''; done <<(env) > .env'

# alias hdi='howdoi -c -n 9 $@'
# alias h='function hdi() { howdoi "$*" -c -n 9; }; hdi'
# alias hor='function hors() { hors "$*" -a -l -e "stackoverflow"; }; hors'

# s() {
#   if [[ "$SHELL" =~ "zsh" ]]; then
#       source $HOME/.zshrc
#   elif [[ "$SHELL" =~ "bash" ]]; then
#       # why not bashrc?
#       source $HOME/.bash_profile
#   fi
#}
# alias diff="delta --line-numbers --navigate --side-by-side --syntax-theme='Dracula'" --> this is now in .gitconfig
