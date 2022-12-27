#!/bin/sh

# tm with no sessions open it will create a session called "new".
# tm irc it will attach to the irc session (if it exists), else it will create it.
# tm with one session open, it will attach to that session.
# tm with more than one session open it will let you select the session via fzf.
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# Install (1+) selected apps
# using 'brew search' as input
# mnemonic [B]rew [I]nstall [P]lugin
bip() {
    local inst=$(brew search  | fzf -m)
    if [[ $inst ]]; then
        for prg in $(echo $inst);
        do brew install $prg; done;
    fi
}

# Upgrade (1+) selected apps
# using 'brew leaves' as input
# mnemonic [B]rew [U]pgrade [P]lugin
bup() {
    local upd=$(brew leaves | fzf -m)

    if [[ $upd ]]; then
        for prog in $(echo $upd); do
          brew upgrade $prog
        done
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

fman() {
    man -k . | fzf -q "$1" --prompt='man> ' --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | bat -l man -p --color always' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
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
        "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '$*' {}")" && \
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
        ) && ${EDITOR:-nvim} '$(cut -f3 <<< "$line")' -c "set nocst" \
            -c "silent tag $(cut -f2 <<< "$line")"
}

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

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
    --bind "ctrl-m:execute:
  (grep -o '[a-f0-9]\{7\}' | head -1 |
  xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
  {}
  FZF-EOF"
}

grr() {
  git fetch origin "$1" && git reset --hard origin/"$1"
}

ggc() {
  git checkout "$(git branch --all | fzf | tr -d ' ')"
}

# Another function which is not based on grep or locate
cdf() {
  local file
  local dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir" || exit
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")"
}

vmod(){
  ${EDITOR:-nvim} "$(git status -s | fzf -m)"
}

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
    tmux switch-client -t "$session"
}

