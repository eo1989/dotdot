# vim:ft=zsh ts=8 sw=4 sts=4 tw=100 fdm=marker et ai:
# shellcheck disable=SC1091

export NVYM=~/.local/share/bob/nightly/bin/nvim \
    EDITOR="${NVYM}" \
    VISUAL=${EDITOR:-"code-insiders"} \
    USE_EDITOR="${EDITOR}"

# DOTFILES="$HOME/.dotdot" \
export NVIM_DIR="${HOME}/.config/nvim" \
    PROJECTS_DIR="${HOME}/Dev" \
    SYNC_DIR="${HOME}/Dropbox"

# @see: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
# if which rg >/dev/null; then
export RIPGREP_CONFIG_PATH=${XDG_CONFIG_HOME}/rg/rgrc
# fi

# By default, zsh considers many chars part of a word (ex: _ & -).
# Narrow that down to allow easier skipping thru words via M-f & M-b
export WORDCHARS='*?_[]~=&;:!#$%^(){}<>'

# macOS currently ships less v.581, which lacks the ability to read lesskey
# source files. Therefore for this to work, the version of less provided by
# homebrew is needed.
export PAGER="$BREW_PREFIX/bin/less"
export MANPAGER='sh -c "col -b | bat -pl man"'

export LESSKEYIN="$XDG_CONFIG_HOME/less/lesskey"
export LESSCOLORIZER='bat --style=numbers --theme="Sublime Snazzy"'
export LESS=" -R"
export LESSOPEN='| $commands[(i)lesspipe.sh] %s LESS_ADVANCED_PREPROCESSOR=1 2>&-'

# export QUANDL="hgwjCyQ2KsYot6Gsh1Vj"
# export ALPHAVANTAGE="04E3CQSU4564LBDN"
# export FINNHUB="brof047rh5r8qo238v4g"
# export FRED="519365e0660f928c1ff9264b38038d85"
# export OPENAI_API_KEY="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"

# export OPENAI_API_KEY="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"
# export OPENAI_API_KEY="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"

# export PATH="$HOME/.julia/bin:$PATH"
export JULIA_PROJECT=@.

# export PATH="/Applications/quarto/bin:$PATH"
#───────────────────────────────────────────────────────────────────────────────
export LS_COLORS="$(vivid generate snazzy)"
# Affects filetype-coloring in eza, fd, and completion menus
# DOCS https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md
# INFO does also accept specific files via glob, e.g. `README.md=4;33`,
grey="38;5;247"
file_colors=".*=$grey:LICENSE*=$grey:*lock*=$grey" # `.*=` affects dotfiles
# export LS_COLORS=$LS_COLORS:+"di=0;34:ln=3,35:or=7,31:$file_colors"

# LS_COLORS=$LS_COLORS:+"di=0;34:ln=3,35:or=7,31:$file_colors" \
# EZA_COLORS=$LS_COLORS:+"gm=1;38;5;208" \
# EZA_COLORS -> git $(modified) w/ same orange as in starship
export TRUECOLOR=1 \
    CLICOLOR=1 \
    CLICOLOR_FORCE=1 \
    HOWDOI_COLORIZE=1 \
    EZA_STRICT=1 \
    EZA_ICONS_AUTO=1 \
    EZA_ICON_SPACING=1 \
    EZA_COLORS="uu=0:gu=0" \
    EZA_COLORS=$LS_COLORS \
    ZLS_COLORS=$LS_COLORS \
    GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01" \
    GREP_OPTIONS="--color=auto" \
    GREP_COLOR='01;35' # matches in bold and magenta (macOS `grep` doesnt support `GREP_COLORS`)

export HOWDOI_SEARCH_ENGINE="google" HORS_ENGINE="stackoverflow"

export GH_NO_UPDATE_NOTIFIER=1 # updates managed via brew

# node
export NODE_REPL_HISTORY=""
# Instead of writing npm config to `.npmrc`, can also be set via shell
# environment variables. Has to be lower-case though. https://docs.npmjs.com/cli/v10/using-npm/config#environment-variables
export npm_config_fund=false            # disable funding nags
export npm_config_update_notifier=false # no need for updating prompts, since done via homebrew

# if [[ -f ~/.config/zsh/zsh_fzf_extra ]]; then
#     . ~/.config/zsh/zsh_fzf_extra
# else
source <(fzf --zsh)
# preview kitty if-then taken from
# https://github.com/junegunn/fzf/commit/d8188fce7b7bea982e7f9050c35e488e49fb8fd0#diff-06572a96a58dc510037d5efa622f9bec8519bc1beab13c9f251e97e657a9d4edR16
export FZF_DEFAULT_OPTS=" \
    --border=sharp \
    --margin=1 \
    --padding=1 \
    --multi \
    --cycle \
    --prompt='❯ ' \
    --pointer='▶ ' \
    --marker='✓ ' \
    --extended \
    --reverse \
    --preview=' \
    if file --mime-type {} | grep -qF 'image'; then \
        kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {} \
    else \
        ([[ -f {} ]] && (bat --color=always || cat {})) \
        || ([[ -d {} ]] && (tree -C {} | less)) \
        || echo {} 2>/dev/null | head -n 30 \
    fi' \
    --preview-window='bottom:65%:hidden:wrap,border-top' \
    --bind='esc:abort,ctrl-space:toggle-preview' \
    --bind='ctrl-c:execute-silent(echo -n {2..} | pbcopy)+abort' \
    --bind='ctrl-e:execute(echo -n {2..} | xargs -o nvim {})+abort' \
    --bind='alt-u:preview-page-up,alt-d:preview-page-down' \
"
# fi

# if exists uv; then
#     eval "$(uv --generate-shell-completion zsh)"
# fi
# if exists pip; then
#     eval "$(pip completion --zsh)"
# fi
# if exists pipx; then
#     eval "$(register-python-argcomplete pipx)"
# fi
# if exists thefuck; then
#     eval "$(thefuck --alias)"
# fi
# if exists gh; then
#     eval "$(gh completion -s zsh)"
# fi
# if exists npm; then
#     eval "$(npm completion)"
# fi
# if exists navi; then
#     eval "$(navi widget zsh)"
# fi
# if exists zoxide; then
#     eval "$(zoxide init zsh)"
# fi
# if exists bob; then
#     eval "$(bob complete zsh)"
# fi
# if [[ "${TERM}" == "xterm-kitty" ]]; then
#     kitty + complete setup zsh | source /dev/stdin
# fi
# source <(fzf --zsh)

. /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
