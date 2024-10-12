# shellcheck disable=SC1090,SC1094,SC2148,SC2153
# shellcheck disable=SC2034,SC2086,SC2296
# -------------------------------------------------------------------------------
#       ENV VARIABLES
# -------------------------------------------------------------------------------
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
# --------------------------------------------------------------------------------

exists() { (($+commands[$1])); }

# source "/usr/local/share/powerlevel10k/powerlevel10k.zsh-theme"
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'

export SHELL="/usr/local/bin/zsh"
export BREW_PREFIX="/usr/local"

export GOPATH="${HOME}/go"
export GOROOT="$BREW_PREFIX/opt/go/libexec"

export PATH="${BREW_PREFIX}/bin:${BREW_PREFIX}/sbin:$PATH"

path+=(
    "$HOME/.cargo/bin"
    "$GOPATH/bin"
    "$GOROOT"
    "$HOME/.local/share/nvim/mason/bin"
)

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init --path zsh)"
eval "$(pyenv init - --no-rehash zsh)" # SLOW AS SHIT
eval "$(pyenv virtualenv-init - zsh)"

export CLICOLOR=1
export CLICOLOR_FORCE=1
export HOWDOI_COLORIZE=1

# if exists "$(lesspipe.sh)"; then
#     export LESSOPEN="| /usr/bin/env $commnads[(i)lesspipe(|.sh)] %s 2>&-"
#     export LESSOPEN="| /usr/bin/env $commnads[(i)lesspipe(|.sh)] %s LESS_ADVANCED_PREPROCESSOR=1 2>&-"
#     export LESSOPEN="| /usr/local/bin/lesspipe.sh %s LESS_ADVANCED_PREPROCESSOR=1 2>&-"
#     export LESSOPEN="| /home/eo/.config/zsh/lessfilter-fzf %s LESS_ADVANCED_PREPROCESSOR=1 2>&-"
#     export LESSOPEN='| LESSQUIET=1 lesspipe.sh %s'
# fi
export LESSOPEN='| $commands[(i)lesspipe.sh] %s LESS_ADVANCED_PREPROCESSOR=1 2>&-'

export NVIM_DIR="${HOME}/.config/nvim"
export DOTFILES="${HOME}/.dotfiles"
export PROJECTS_DIR="${HOME}/Dev"
export SYNC_DIR="${HOME}/Dropbox"

# export PYENV_ROOT="${HOME}/.pyenv"

export CPPFLAGS="-I${BREW_PREFIX}/include"
export LDFLAGS="-L${BREW_PREFIX}/lib"

# export IEXCLOUD="pk_265a6ccb26184897ae897bef3333e9f5"
export QUANDL="hgwjCyQ2KsYot6Gsh1Vj"
export ALPHAVANTAGE="04E3CQSU4564LBDN"
export FINNHUB="brof047rh5r8qo238v4g"
export FRED="519365e0660f928c1ff9264b38038d85"
# export OPENAI_API_KEY="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"
# export OPENAI_API_KEY="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"

if [[ -n $KITTY_INSTALLATION_DIR ]]; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi

export GPG_TTY=$TTY

export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_BAT=1
export HOMEBREW_BAT_CONFIG_PATH="$HOME/.config/bat/config"
export HOMEBREW_BAT_THEME="Sublime Snazzy"
# export HOMEBREW_BAT_THEME="Sublime Snazzy"
# export HOMEBREW_BAT_THEME="Visual Studio Dark+" # 1337, Nord, Coldest-Dark, OneHalfDark, Dracula, ansi,
# export HOMEBREW_NO_ANALYTICS=1

export APPLE_SSH_ADD_BEHAVIOR=openssh
# export HOMEBREW_GITHUB_API_TOKEN=
# move these to env files so they can be gitignored!

# @see: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
if exists rg; then
    export RIPGREP_CONFIG_PATH="$HOME/.config/rg/rgrc"
fi

case $(uname) in
    Darwin)
        if which luarocks >/dev/null; then
            eval "$(luarocks --lua-version=5.1 path)"
        fi
        alias brewfile="brew bundle dump --describe --global --force"
        export BROWSER='open'
        ;;
esac

export LC_ALL=en_US.UTF-8
export NVYM="/Users/eo/Dev/eo_contrib/neovim/bin/nvim"
export EDITOR=${NVYM}
export VISUAL=${NVYM}
export USE_EDITOR=${EDITOR}

# export PIP_DISABLE_PIP_VERSION_CHECK=1
# export MPLBACKEND='module://matplotlib-backend-kitty'
# export PAGER_PATH="${HOME}/.local/bin/kitty +kitten pager --allow-remote %s"

# export WORDCHARS=${WORDCHARS//\/[&.;]}
# export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
# export ZSH_AUTOSUGGESTION_HIGHLIGHT_STYLE='fg=241'

export HOWDOI_SEARCH_ENGINE="google"
export HORS_ENGINE="stackoverflow"

# export EZA_COLORS="uu=0:gu=0"
LS_COLORS="$(~/.cargo/bin/vivid generate snazzy)"
export LS_COLORS
export EZA_COLORS=$LS_COLORS
export ZLS_COLORS=$LS_COLORS
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

export FZF_DEFAULT_OPTS=" \
--border=sharp
--margin=1
--padding=1
--multi
--cycle
--prompt='❯ '
--pointer='▶ '
--marker='✓ '
--extended,
--reverse,
--preview='([[ -f {} ]] && (bat --color=always || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2>/dev/null | head -n 30'
--preview-window='bottom:65%:hidden:wrap,border-top'
--bind='esc:abort,ctrl-space:toggle-preview'
--bind='ctrl-c:execute-silent(echo -n {2..} | pbcopy)+abort'
--bind='ctrl-e:execute(echo -n {2..} | xargs -o nvim {})+abort'
--bind='alt-u:preview-page-up,alt-d:preview-page-down'
"
# --bind='ctrl-u:preview-page-up,ctrl-d:preview-page-down'
# --bind='ctrl-r:reload(fzf -q {q})' \

# --bind='ctrl-/:change-preview-window()'
# --bind='ctrl-r:reload()'
# --bind=esc:abort \
# --bind='ctrl-space:toggle-preview' \
# --bind='ctrl-c:execute-silent(echo -n {2..} | pbcopy)+abort' \
# --bind='ctrl-e:execute(nvim {+})' \
# --bind='ctrl-u:preview-page-up' \
# --bind='ctrl-d:preview-page-down'"
# --preview-window='right:hidden:wrap' \

# --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=auto {} || cat {}) 2>/dev/null || ([[ -d {} ]] && (tree -C {} | less)) | head -n10' \
# --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2>/dev/null | head -n30' \
# --bined='f3:execute(bat --style=numbers {} || less -f {}),ctrl-space:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} || pbcopy)' \
# --no-mouse \
#   --1 \
#   --reverse \
#   --multi \
#   --inline-info \

# export FZF_CTRL_R_OPTS=" \
# --preview 'echo {}' --preview-window up:3:hidden:wrap \
# --bind 'ctrl-space:toggle-preview' \
# --bind 'ctrl-c:execute-silent(echo -n {2..} | pbcopy)+abort' \
# --color 'header:italic'"

# export FZF_TMUX_OPTS='-p80%,60%'

if [[ "${TERM}" == "xterm-kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
fi

sources=(
    "aliases.zsh"
    "functionz.zsh"
    ".fzfrc"
)

for s in "${sources[@]}"; do
    source ${HOME}/.config/zsh/${s}
done
unset sources
unset s

# [ -f "${HOME}/zsh-addons/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ] && source "${HOME}/zsh-addons/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/grep/share/man"       #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/gawk/share/man"       #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/gnu-which/share/man"  #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/gnu-sed/share/man"    #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/gnu-tar/share/man"    #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/gnu-getopt/share/man" #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/gnu-indent/share/man" #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/gnu-time/share/man"   #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/gnu-units/share/man"  #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/inetutils/share/man"  #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/findutils/share/man"  #:$MANPATH"
# export MANPATH="${MANPATH}:${BREW_PREFIX}/opt/coreutils/share/man"  #:$MANPATH"
# export MANPATH="${MANPATH}:${HOME}/zsh-addons/eza/man"              #:$MANPATH"
# export MANPATH="${MANPATH}:${HOME}/.local/share/man"
# export MANPATH="$MANPATH:$HOME/zsh-addons/ripgrep"              #:$MANPATH"

# :/usr/local/opt/gnu-tar/libexec/gnubin
# /usr/local/opt/whois/bin:/usr/local/opt/gnu-getopt/bin:
# /usr/local/opt/gnu-units/libexec/gnubin:/usr/local/opt/gnu-time/libexec/gnubin:/usr/local/opt/make/libexec/gnubin:
export PATH="${HOME}/dev/eo_contrib/neovim/bin:${HOME}/.local/bin:${HOME}/.cargo/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/gnu-which/libexec/gnubin:/usr/local/opt:${PATH}"
unsetopt GLOBAL_RCS
typeset -U PATH path FPATH fpath MANPATH manpath

# vim:ft=zsh fdm=marker sw=4 tw=120 ts=4 sts=4
