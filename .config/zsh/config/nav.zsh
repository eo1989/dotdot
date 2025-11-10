# ------------------------------------------------------------------------------
# Hooks
# ------------------------------------------------------------------------------

# A function which is run automatically at a specific point during shell
# execution. To list all the hooks:
#
#     % add-zsh-hook -L

# `man zshcontrib /Manipulating Hook Functions`
# `man zshmisc /SPECIAL FUNCTIONS/;/Hook Functions`
# autoload -Uz add-zsh-hook
autoload -U add-zsh-hook

#───────────────────────────────────────────────────────────────────────────────
# DOCS
# https://blog.meain.io/2023/navigating-around-in-shell/
# https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories
#───────────────────────────────────────────────────────────────────────────────

# Activate the Python virtual environment built using the `uv` command.
#
# This checks for the `.venv` directory by climbing up the path until it
# finds the directory or reaches the system root directory (`/`).
#
# This is used for the `_python_auto_venv` hook, but can be used from the
# command-line as well.
#
# The activation part cannot be a script as that is executed in a subshell
# and so the `source` part will also be executed in the subshell instead of
# the current shell.
py_venv_activate() {
    local project_root="$PWD"
    while [[ "$project_root" != "/" && ! -e "$project_root/.venv" ]]; do
        project_root="${project_root:h}"
    done
    if [[ -e "$project_root/.venv/bin/activate" ]]; then
        source "$project_root/.venv/bin/activate"
    fi
}

# shell-agnostic hook to activate & deactivate virtualenvs
# TODO: nested virtual environments
_python_auto_venv() {
    if ! typeset -f deactivate &>/dev/null; then
        py_venv_activate
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        # Why '/' ?
        #
        # Take these two directories for example:
        #   1. ~/test         - contains virtual environment
        #   2. ~/test-other   - no virtual environment
        #
        # If we go from the first directory to the second, the environment will not
        # be deactivated because of the glob. By adding a forward slash, we restrict
        # the match and avoid the case where the string is a substring.
        #
        #   `[[ "~/test-other"  != "~/test"*  ]]` -> false
        #   `[[ "~/test-other/" != "~/test/"* ]]` -> true
        if [[ "$PWD/" != "${VIRTUAL_ENV:h}/"* ]]; then
            # If we're changing a directory containing a virtual environment to
            # another directory with a virtual environment, then we should deactivate
            # the first one and activate the current one.
            deactivate
            py_venv_activate
        fi
    fi
}

# virtual_env_activate() {
#     if [[ -n "$VIRTUAL_ENV" ]]; then
#         # check if current folder belong to earlier VIRTUAL_ENV folder
#         parent_dir=$(dirname "$VIRTUAL_ENV")
#         if [[ "$PWD"/ != "$parent_dir"/* ]]; then
#             deactivate
#         fi
#     fi
#
#     if [ -r .python-version ] && [ ! -d ./.venv ]; then
#         uv venv
#     fi
#
#     if [[ -z "$VIRTUAL_ENV" ]]; then
#         # if .venv folder is found then activate it
#         if [ -d ./.venv ] && [ -f ./.venv/bin/activate ]; then
#             source ./.venv/bin/activate
#
#             # if pyproject.toml is found then sync the virtualenv
#             if [[ -f pyproject.toml ]]; then
#                 uv sync --all-groups
#             fi
#         fi
#     fi
# }

# overrides
# --------------------------------
# function cd() {
#     emulate -L zsh
#     builtin cd "$@" || return
#
#     # run the virtualenv activation
#     # virtual_env_activate
#
# }

# --------------------------------

# if ! (( $chpwd_functions[(I)chpwd_cdls] )); then
#     chpwd_functions+=(chpwd_cdls)
# fi

# eval ${CD_LS_COMMAND:-lsd --header -FXSlLag --blocks date,size,name}

export CD_LS_COMMAND='${BREW_PREFIX}/bin/eza -lhG --git-repos-no-status'
_chpwd_cdls_pyvenv() {
    if [[ -o interactive ]]; then
        emulate -L zsh
        # eval ${CD_LS_COMMAND:-eza -lhG --git-repos-no-status}
        eval "${CD_LS_COMMAND:-'eza -lhG --git-repos-no-status'}"
        _python_auto_venv
    fi
}
add-zsh-hook -Uz chpwd _chpwd_cdls_pyvenv

# CONFIG
# export CDPATH="$HOME/Dev:$HOME/"

#───────────────────────────────────────────────────────────────────────────────

# OPTIONS
# setopt CD_SILENT
# setopt AUTO_CD     # BUG -> https://github.com/marlonrichert/zsh-autocomplete/issues/749
# setopt CHASE_LINKS # follow symlinks when they are cd target

# POST-DIRECTORY-CHANGE-HOOK
# (use `cd -q` to suppress this hook)
# function chpwd {
#     _magic_dashboard
#     _auto_venv
# }

#─────────────────────────────────────── eo ────────────────────────────────────
# zsh-lovers
# Another method for quick change directories. Add this to your ~/.zshrc, then just enter “cd
# ..../dir”
function rationalise-dot() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot


#───────────────────────────────────────────────────────────────────────────────
# SHORTHANDS

# INFO leading space to ignore it in history due to HIST_IGNORE_SPACE
alias -- -='cd -'
alias ..=" cd .."
alias ...=" cd ../.."
alias ....=" cd ../../.."
alias ..g=' cd "$(git rev-parse --show-toplevel)"' # goto git root

#───────────────────────────────────────────────────────────────────────────────
# RECENT DIRS
# - the list from `dirs` is already populated by zsh-autocomplete, so we do not
#   need to use `AUTO_PUSHD` etc to populate it
# - the zsh builtin `cdr` completes based on a number as argument, so the
#   completions are not searched, which is why we are using this setup of our own

# function gr {
#     local goto="$*"
#     [[ -z "$*" ]] && goto=$(dirs -p | sed -n '2p') # no arg: goto last (1st line = current)
#     goto="${goto/#\~/$HOME}"
#     cd "$goto" || return 1
# }

# _gr() {
#     [[ $CURRENT -ne 2 ]] && return # only complete first word
#
#     # get existing dirs
#     local -a folders=()
#     while IFS='' read -r dir; do # turn lines into array
#         expanded_dir="${dir/#\~/$HOME}"
#         [[ -d "$expanded_dir" ]] && folders+=("$dir")
#     done < <(dirs -p | sed '1d')
#
#     local expl && _description -V recent-folders expl 'Recent Folders'
#     compadd "${expl[@]}" -Q -- "${folders[@]}"
# }

# compdef _gr gr

#───────────────────────────────────────────────────────────────────────────────

# CYCLE THROUGH DIRECTORIES

# function _grappling_hook {
#     # CONFIG some perma-repos & desktop
#     local some_perma_repos to_open locations_count dir locations
#     some_perma_repos=$(cut -d, -f2 "$HOME/.config/perma-repos.csv" | sed "s|^~|$HOME|" | head -n3)
#     locations="$HOME/Desktop\n$some_perma_repos"
#
#     to_open=$(echo "$locations" | sed -n "1p")
#     locations_count=$(echo "$locations" | wc -l)
#
#     for ((i = 1; i <= locations_count - 1; i++)); do
#         dir=$(echo "$locations" | sed -n "${i}p")
#         [[ "$PWD" == "$dir" ]] && to_open=$(echo "$locations" | sed -n "$((i + 1))p")
#     done
#     cd -q "$to_open" || return 1
#     zle reset-prompt
#
#     # so wezterm knows we are in a new directory
#     [[ "$TERM_PROGRAM" == "WezTerm" ]] && wezterm set-working-directory
# }
# zle -N _grappling_hook
# bindkey "^O" _grappling_hook # bound to cmd+enter via wezterm

# vim: ft=zsh ts=8 sw=4 sts=4 tw=100 et ai:
