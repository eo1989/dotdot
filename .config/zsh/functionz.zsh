# Handful of useful functions ive found across the interwebs
# - Akinsho/dotfiles
# - jdsimcoe/dotfiles/blob/master/.zshrc
# - masa0x80/cheats
# - loganswartz/dotfiles/blob/master/zsh/.aliases

# shellcheck disable=SC3043
# shellcheck disable=SC3010

# logit() { cat <&0 | tee "$(date +'%m-%d-%Y--%H:%M:S').log" }
#
# zsh-lovers rationalize-dot
rationalize-dot() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalize-dot
bindkey . rationalize-dot

# razak17/dotfiles/blob/main/.config/zsh/scripts/utils
ch() {
    sudo chmod -R 777 "$@"
}

cx() {
    sudo chmod +x "$@"
}

zshcomp() {
    for command completion in ${(kv)_comps:#-*(-|-,*)}; do
        printf "%-32s %s\n" $command $completion
    done | sort
}
#### razak finished

logg() {
    "${@}" > >(tee "$(basename "${1}").log")
}

pdf_open() {
    fd -e pdf "${1}" . 2&>1 | fzf | xargs -i open {}
}

# launch programs from commandline w/o messing up your current pty
# usage: "standalone <your full command>"
standalone() {
    "${@}" > /dev/null 2>&1 &
}

weather() {
    if [ "${1}" = "-h" ]; then
        curl "wttr.in/:help"
    else
        curl "wttr.in/?A2Fn${@}"
    fi
}

mediadiff() {
    nvim -d <(mediainfo "$1" ) <(mediainfo "$2")
}

# join a glob with the given delimiter
join() {
    local IFS=$1
    shift
    echo "${*}"
}

explain() {
    open "https://explainshell.com/explain?cmd=${*}";
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

build-nvim() {
    neovim_dir="$PROJECTS_DIR/eo_contrib/neovim"
    [ ! -d $neovim_dir ] && git clone git@github.com:neovim/neovim.git $neovim_dir
    pushd $neovim_dir
    git checkout master
    # git checkout origin/HEAD
    git pull
    [ -d "$neovim_dir/build/" ] && rm -r ./build/  # to clear the cmake cache
    make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/dev/eo_contrib/neovim"
    make install
    popd || exit
}

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

hdi() {
    howdoi "$*" -c -n 9;
}

zd() {
    local dir
    dir=$(zoxide query -l | fzf)
    cd "$dir" || exit
}

# find file, open it fzf -> fd -> nvim -- no args, looks in cwd - rg to
# highlight
# "highlight -O truecolor -l {} 2> /dev/null | \
# vf() {
#     IFS=$'\n' fyles=$($(
#         fzf --preview \
#             "bat --numbers --color=always --theme=\"Sublime Snazzy\" :200 2>/dev/null \
#             rg --colors \'match:bg:yellow\' --ignore-case --pretty --context 6 \'$1\' || \
#             rg --ignore-case --pretty --context 6 \'$1\' {}" \
#             --preview-window=right:60% \
#             --query="$1" \
#             --multi \
#             --select-1 \
#             --exit-0 \
#     )) | [[ -n $fyles ]] && ${EDITOR:-nvim} "${fyles[@]}"
# }

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
#   "1337", "Sublime Snazzy", "Visual Studio Dark+"
# fe() {
#     local files
#     IFS=$'\n' files=$(fzf-tmux --query="$1" \
#         --multi \
#         --select-1 \
#         --exit-0 \
#         --preview-window='right,65%:hidden:wrap,border-left|bottom,70%:hidden:wrap,border-top' \
#         --preview='([[ -f {} ]] && (bat --plain --theme=Dracula --color=always :200 {} || cat {} ))' \
#     ) | [[ -n $files ]] && ${EDITOR:-nvim} "${files[@]}"
# }

# -- Find-in-file --
# - usage: 'fif <SEARCH_TERM>',
#       - fif "string with spaces",
#       - fif "regex"
# fif() {
#     if [ ! "$#" -gt 0 ]; then
#         echo "Need a string to search for!";
#         return 1;
#     fi;
#     local file;
#     file="$(rga \
#         --max-count=1 \
#         --ignore-case \
#         --files-with-matches \
#         --no-messages "$*" | fzf-tmux +m --preview=\"rga --ignore-case --pretty --context=10 \'$*\' {}\"
#     )" \
#         && echo "opening $file" \
#         && open "$file" || return 1;
# }

# rga-fzf interactivity
rgaf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX \'$1\'" \
            fzf --sort --reverse --preview=\"[[ ! -z {} ]] && rga --pretty --context=5 {q} {}\" \
            --phony -q \"$1\" \
            --bind \"change:reload:$RG_PREFIX {q}\" \
            --preview-window=\"down,70%:wrap,border-up\" \
    )" && \
        # Might help to convert to text and open said txt file instead, or
        # as an option
        echo "opening $file" && \
        open "$file" || exit
}

envs() {
        # ps eww -o command | tg ' ' '\n'
    printenv | fzf
}

# alias histstats="history | gawk '{CMD[\$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | grep -v './' | gcolumn -c3 -s ' ' -t | sort -nr | n1 | head -n10"
# create PR
# gh pr create --title "<title>"
# title: git log --oneline --pretty=%s | fzf +m -1 --query "$(git issue-id)"
# if this fails/no output see if running a simple fetch causes this error:

# $curl https://mankier.com
# curl: (35) Cant communicate securely w/ peer: no common encryption algo(s).
# if so, try specifying a cipher in the curl cmd: curl --cipher
# ecdhe_ecdsa_aes_128_sha etc etc
# explain() {
#         if [[ $\# -eq 0 ]]; then
#                 while read -p "Command: " cmd; do
#                         curl -Gs "https://www.mankier.com/api/v2/explain/?cols="
#                         "$(tput cols)"
#                         --data-urlencode "q=${cmd}"
#                 done;
#         echo "Bye!"
#         elif [[ $# -eq 1 ]]; then
#                 curl -Gs "https://www.mankier.com/api/v2/explain/?cols=" "$(tput cols)" --data-urlencode "q=${1}"
#         else
#                 echo "Usage"
#                 echo "explain interactive mode."
#                 echo "explain 'cmd -o | ...'  one quoted command to explain it."
#         fi
# }
# EXAMPLE: echo "some $(strikethough hello world) text"

# cheat() {
#   if [ "$2" ]; then
#     curl "https://cheat.sh/$1/$2"
#   else
#     curl "https://cheat.sh/$1"
#   fi
# }

# syn() {
#         curl -s "https://api.dictionaryapi.dev/api/v2/entries/en/${1}" | jq '.[].meanings[].definitions[].synonyms[]'
# }

# port() {
#         lsof -n -i ":{@}" | grep LISTEN
# }

# helper fx to run a diff against a branch & exclude a file
# gdmin() {
#     local branchname=${1:-develop}
#     local ignore=${2:-package\-lock.json}
#     git diff $branchname -- ":(exclude)"${ignore}
# }

# The two color functions below dont seem to work very well.
# palette() {
#     local -a colors
#     for i in {0..255}; do
#         colors+=("%F{$i}${i}%f")
#     done;
#     print -cP colors
# }

# colors() {
#         for i in {0..255}; do
#                 printf "colour${i}"
#                 if ((i % 5 == 0)); then
#                         printf "\n"
#                 else
#                         printf "\t"
#                 fi;
#         done;
# }
# -------------------------------------------------------------------

# from solidiquis/dotfiles
# h() {
#     history | grep $1
# }

# 16col() {
#     for i in {30..37}; do
#         printf "$i \u2B62 \e[${i}m\u25C6\e[0m\n"
#     done
# }

# 256col() {
#     for i in {0..255}; do
#         printf "\e[1;38;5;${i}m${i}\e[0m "
#     done
#
#     printf "\n"
# }


# quickly duplicate things
# dup() {
#         for file in "$@"; do
#                 cp -f "$file" "${file}.dup"
#         done
# }

# spotlight() { mdfind "kMDItemDisplayName == \"${@}\" wc"; } # \"$@\"

# alias hdi='howdoi -c -n 9 $@'
# alias h='function hdi() { howdoi "$*" -c -n 9; }; hdi'
# alias hor='function hors() { hors "$*" -a -l -e "stackoverflow"; }; hors'

#### all these from alex-cory/fasthacks/blob/master/dotfiles/bash/.bashrc
# mostused() {
#         var="$(history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr | head)"
#         echo "$var"
# }

# TODO:convert this to use fd or rg
# cpf() {  find . -maxdepth 1 -type f -name "$@" -exec cp -n {} "${@: -1}" \;}

# NOTE: Find last modified
# fm() {
#         ignore="-not -iwholename '*.git*'"
#         if [ -z "${1+xxx}" ]; then
#                 # if no arg is set
#                 # find the single most recently edited file
#                 cmd="find . $ignore -type f -print0 | xargs -0 stat -f \"%m %N\" | sort -rn | head -1 | cut -f2- -d\" \""
#         elif [ "$1" == '-m' ]; then
#                 # recursively find last modified file in current dir unless specifying a path
#                 cmd="find . $ignore -type f -print0 | xargs -0 gstat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head"
#         else
#                 cmd="find $1 `$ignore` -type f -print0 | xargs -0 stat -f \"%m %N\" | sort -rn | head -1 | cut -f2- -d\" \""
#         fi;
#         eval $cmd
# }

# NOTE: This function already exists using the {$+commands[xyz]} syntax, but nice to have nontheless
# exists() { which $1 &> /dev/null }

######## junegunn/fzf/wiki/Examples#Transmission
# pick_torrent() {
#         LBUFFER="transmission-remote -t ${$({
#                 for torrent in ${(f)"$(transmission-remote -l)"}; do
#                         torrent_name=$torrent[73,-1]
#                         [[ $torrent_name != (Name|) ]]
#                         && echo ${${${(s. .)torrent}[1]}%\*}
#                         $torrent_name
#                 done
#         } | fzf)%% * } -"
# zle -N pick_torrent
# bindkey '^o' pick_torrent

########## cuberhaus/dotfiles/blob/master/.config/zsh/functions
# NOTE: Normalize `open` across WSL, macOS, windows # needed to make the `o` function (below) cross-platform
# if [ ! $(uname -s) = 'Darwin' ]; then
#         if grep -q Microsoft /proc/version; then
#                 # WSL
#                 alias open='explorer.exe';
#         else
#                 alias open='xdg-open';
#         fi;
# fi
# `o` with no args opens the current dir, otherwise opens the given localtion
# o(){
#         if [ $# -eq 0 ]; then
#         # </dev/null &>/dev/null -> completely silence a process
#                 open . & </dev/null &>/dev/null
#         else
#                 open "$@" & </dev/null &>/dev/null
#         fi;
# }

########################### see env variables

# fshow - git commit browser
# fshow() {
#         git log --graph --color=always \
#                 --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"
#                         "$@" |
#                                 fzf --ansi
#                                     --no-sort
#                                     --reverse
#                                     --tiebreak=index
#                                     --bind=ctrl-s:toggle-sort
#                                             --bind "ctrl-m:execute:(grep -o '[a-f0-9]\{7\}'
#                                             | head -1
#                                             | xargs -I % sh -c 'git show --color=always %
#                                             | less -R'
#                                     ) << 'FZF-EOF' {} FZF-EOF"
# }

# grr() {
#     git fetch origin "$1" && git reset --hard origin/"$1"
# }

# ggc() {
#     git checkout "$(git branch --all | fzf | tr -d ' ' )"
# }

# Another function which is not based on grep or locate
# cdf() {
#     local file
#     local dir
#     file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir" || exit
# }
# TODO: The one above and below "CDF" and "CDG" can be combined if I ever bothered using either of them at all.
# cdg() {
#     local file
#     local dir
#     file=$(fd -H -g .git | fzf) && dir=$(dirname "$file") && cd "$dir" || return
# }


# fman() {
#     man -k . | fzf -q "$1" --prompt='man> ' --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | bat -l man -p --color always' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
# }
  # man -k . | fzf -q "$1" --prompt='man> ' --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | bat -l man -p --color always' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man

# export MANPAGER="sh -c 'col -bx | bat --style=grid,filename -l man --paging auto'"
# unset MANPAGER

# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
# fstash() {
#     local out q k sha
#     while out=$(
#         git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
#             fzf --ansi --no-sort --query="$q" --print-query \
#                 --expect=ctrl-d,ctrl-b
#     ); do
#         mapfile -t out <<<"$out"
#         q="${out[0]}"
#         k="${out[1]}"
#         sha="${out[-1]}"
#         sha="${sha%% *}"
#         [[ -z $sha ]] && continue
#         if [[ $k == 'ctrl-d' ]]; then
#             git diff "$sha"
#         elif [[ $k == 'ctrl-b' ]]; then
#             git stash branch "stash-$sha" "$sha"
#             break
#         else
#             git stash show -p "$sha"
#         fi
#     done
# }

# fjrnl - Search JRNL headlines
# fjrnl() {
#     local line
#     [ -e tags ] &&
#         line=$(
#             awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
#                 cut -c1-80 | fzf --nth=1,2
#         ) && ${EDITOR:-nvim} "$(cut -f3 <<< "${line}")" -c "set nocst" \
#         -c "silent tag $(cut -f2 <<<"$line")"
# }

# -- fbr --
# - checkout git branch (including remote branches),
# - sorted by most recent commit,
# - limit 30 last branches
# fbr() {
#     local branches branch
#     branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") && \
#         branch=$(echo "$branches" | \
#             fzf-tmux -d $((2 + $(wc -l <<<"$branches"))) +m) && \
#         git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")" \
# }

# vmod() {
#     ${EDITOR:-nvim} "$(git status -s | fzf -m)"
# }

# vim: ft=zsh ts=4 sw=4 sts=4 tw=100 fdm=marker
