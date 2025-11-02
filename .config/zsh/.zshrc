# shellcheck disable=SC1083,SC1086,SC1090,SC1094,SC2148,SC2153,SC2154,SC2034,SC2086,SC2296,SC2206

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# [[ "ZSH_THEME" == (p10k|powerlevel10k)* ]] || return 1
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export VSCODE_SUGGEST=1


# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

# if [[ "$OSTYPE" = "darwin"* ]]; then
ulimit -c unlimited
# fi

export DOTDOT="${HOME}/.dotdot/"
alias dotdot='/opt/homebrew/bin/git --git-dir="${HOME}/.dotdot/" --work-tree="${HOME}"'

if exists luarocks; then
    eval "$(luarocks --lua-version=5.1 path)"
fi


if [[ "${TERM}" == "xterm-kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
fi

if exists lesspipe.sh; then
    # LESSOPEN="|lesspipe.sh %s"
    LESSOPEN='| $commands[(i)lesspipe.sh] LESS_ADVANCED_PREPROCESSOR=1 %s 2>&-'
    export LESSOPEN
else
    # source <(lesspipe.sh)
    lesspipe.sh | source /dev/stdin
fi
export LESS='-R -F -X'

_comp_options+=(globdots) # Include hidden files.


# -z => check if string is empty or not defined
# -n => check if a string is defined and not empty
# -f => check if a file exists
# -d => check if a directory exists


# if [ -d ~/.config/zsh ]; then
if [[ -n "$ZDOTDIR" ]]; then
    setopt +o nomatch
    files=(
        ~/.config/zsh/config/*
        # aliases
        # dashboard
        # homebrew
        # opts
        # zsh_plugins
        # cli_settings
        # completion
        # nav
        # term_utils
        # docs_man
        # git_gh
    )
    setopt -o nomatch
    for filename in "${files[@]}"; do
        if [[ "$filename" =~ ^.+\.z?sh$ && -r $filename ]]; then
            source "$filename"
        fi
    done
    unset filename
fi

# [[ "$OSTYPE" =~ "darwin" ]] && CONFIG_FILES+=()
# for filename in "${CONFIG_FILES[@]}"; do
#     # setopt extendedglob globdots
#     source "/Users/eo/.config/zsh/config/${filename}.zsh"
# done

. "${HOME}/.config/fzf/fzf-config.zsh"

if exists uv; then
    eval "$(uv --generate-shell-completion zsh)"
fi

if exists pip; then
    eval "$(pip completion --zsh)"
fi

if exists pipx; then
    eval "$(register-python-argcomplete pipx)"
fi

if exists thefuck; then
    eval "$(thefuck --alias)"
fi

if exists gh; then
    eval "$(gh completion -s zsh)"
fi

# if exists npm; then
#     eval "$(npm completion)"
# fi

if exists navi; then
    eval "$(navi widget zsh)"
    bindkey -r "" _navi_widget
fi

if exists zoxide; then
    source $HOME/.config/zoxide/zoxide-config
    eval "$(zoxide init zsh)"
fi

if exists mdsf; then
    eval "$(mdsf completions zsh)"
fi

# if exists bob; then
#     eval "$(bob complete zsh)"
# fi

# ------------------------------------------------------------------------------
#       ENV VARIABLES
# ------------------------------------------------------------------------------
# PATH.
# (N-/): do not register if the directory does not exists
# (Nn[-1]-/)
#
#  N   : NULL_GLOB option (ignore path if the path does not match the glob)
#  n   : Sort the output
#  [-1]: Select the last item in the array
#  -   : follow the symbol links
#  /   : ignore files
#  t   : tail of the path
# CREDIT: @ahmedelgabri
# -------------------------------------------------------------------------------

path=(
    "${BREW_PREFIX}"/opt/{coreutils,findutils,rustup,node}/libexec/gnubin(N)
    "${BREW_PREFIX}"/opt/{llvm,curl,ruby,node}/bin(N)
    ~/.julia/juliaup(N)
    ~/.{yarn,npm}/bin(N)
    ~/go/bin(N)
    ~/.{go,cargo}/bin(N)
    "${BREW_PREFIX}"/opt/{grep,gnu-{sed,which,tar}}/libexec/gnubin(N)
    "${BREW_PREFIX}"/opt/gnu-getopt/bin(N)
    "${BREW_PREFIX}"/{bin,sbin}(N)
    /usr/local/{bin,sbin}(N)
    /usr/{bin,sbin}(N)
    /usr/local/texlive/2024basic/bin(N)
    "${XDG_CONFIG_HOME}"/bin(N)
    "${XDG_CONFIG_HOME}"/fzf/bin(N)
    $path
)

export PNPM_HOME="/Users/eo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


export PYENV_ROOT=~/.pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH="${PYENV_ROOT}/bin:$PATH"
if exists pyenv; then
    eval "$(pyenv virtualenv-init - zsh)"
    eval "$(pyenv init --path zsh)"
    eval "$(pyenv init - --no-rehash zsh)"
fi

# $HOME/.local/share/bob/nvim-bin/bin(N-/)
path=(
    ~/.local/{bin,share}(N-/)
    $path
)

typeset -gU path cdpath fpath manpath

autoload -Uz compinit && compinit


# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# vim: set ft=zsh ts=8 sts=4 sw=4 et ai:
