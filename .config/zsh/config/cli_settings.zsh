# shellcheck disable=SC1083,SC1086,SC1090,SC1091,SC1094,SC2148,SC2153,SC2154,SC2034,SC2086,SC2296,SC2206

export PIP_DISABLE_PIP_VERSION_CHECK=1
# export FZF_DEFAULT_OPTS_FILE=/Users/eo/.config/fzf/fzf-config

# if [[ -n "${TERM_PROGRAM+x}" ]]; then
#     export MPLBACKEND=""
# fi
# export MPLBACKEND="module://matplotlib-backend-kitty"

# if [[ "${TERM}" == "xterm-kitty" ]]; then
# else
#     export MPLBACKEND="module://matplotlib.backends.backend_agg"
# fi

export NVYM="${BREW_PREFIX}/bin/nvim"
export EDITOR="${NVYM}"
export VISUAL="${EDITOR:-"code-insiders"}"
export USE_EDITOR="${EDITOR}"

# NOTE: change from dropbox to icloud like "gh repo chrisgrieser/.config"
export NVIM_DIR="${HOME}/.config/nvim" PROJECTS_DIR="${HOME}/Dev" SYNC_DIR="${HOME}/Dropbox"

# @see: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/rg/rgrc"

# By default, zsh considers many chars part of a word (ex: _ & -).
# Narrow that down to allow easier skipping thru words via M-f & M-b
export WORDCHARS="*?_[]~=&;:!#$%^(){}<>"

# export LESSOPEN="| highlight %s -O truecolor -s"
export LESSOPEN='| $commands[(i)lesspipe.sh] LESS_ADVANCED_PREPROCESSOR=1 %s 2>&-'

export LESSKEYIN="$XDG_CONFIG_HOME/less/lesskey"
export LESSCOLORIZER='bat --theme="Dracula"'

# macOS currently ships less v.581, which lacks the ability to read lesskey
# source files. Therefore for this to work, the version of less provided by
# homebrew is needed.

export PAGER="$BREW_PREFIX/bin/less"
export MANPAGER='sh -c "col -b | bat -pl man"'

# export PATH="$HOME/.julia/bin:$PATH"
export JULIA_PROJECT=@.

export GPG_TTY=$TTY

#───────────────────────────────────────────────────────────────────────────────
export VIVID_COLORS="$(vivid generate snazzy)"
export LS_COLORS="${VIVID_COLORS}"
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
    EZA_STRICT=0 \
    EZA_ICONS_AUTO=1 \
    EZA_ICON_SPACING=2 \
    EZA_COLORS="uu=0:gu=0" \
    EZA_COLORS="${LS_COLORS}" \
    ZLS_COLORS="${LS_COLORS}" \
    GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01" \
    GREP_OPTIONS="--color=auto" \
    GREP_COLORS='01;35' # matches in bold and magenta (macOS `grep` doesnt support `GREP_COLORS`)

export HOWDOI_SEARCH_ENGINE="google" HORS_ENGINE="stackoverflow"

export GH_NO_UPDATE_NOTIFIER=1 # updates managed via brew

# node
# export NODE_REPL_HISTORY=""
# Instead of writing npm config to `.npmrc`, can also be set via shell
# environment variables. Has to be lower-case though. https://docs.npmjs.com/cli/v10/using-npm/config#environment-variables
# export npm_config_fund=false            # disable funding nags
# export npm_config_update_notifier=false # no need for updating prompts, since done via homebrew

# if [[ -f ~/.config/zsh/zsh_fzf_extra ]]; then
#     . ~/.config/zsh/zsh_fzf_extra
# else
# preview kitty if-then taken from
# https://github.com/junegunn/fzf/commit/d8188fce7b7bea982e7f9050c35e488e49fb8fd0#diff-06572a96a58dc510037d5efa622f9bec8519bc1beab13c9f251e97e657a9d4edR16

# export FZF_PREVIEW_COLUMNS=$(($(tput cols) / 2))
# export FZF_PREVIEW_LINES=$(tput lines)
# export _KITTEN_ICAT_PLACE="${FZF_PREVIEW_COLUMNS:-64}x${FZF_PREVIEW_LINES}@${FZF_PREVIEW_COLUMNS:-64}x0"
# export PREVIEW_CMD="\
# if test -d {}; then \
#     lsa {};\
# else \
#     if file --mime-type {} | grep -qF image/; then \
#         icat --clear --transfer-mode=memory --stdin=no --place=\${FZF_PREVIEW_COLUMNS:-64}x\${FZF_PREVIEW_LINES:-64}@0x0 {};\
#     else \
#         printf '\x1b_Ga=d,d=A\x1b\\'\
#     fi ;\
#     bat --color=always --style=header,grid --line-range :300 {} ;\
# fi"

# preview_cmd='
# if file --mime-type {} | grep -qF image/; then
#     tput clear & chafa -s ${FZF_PREVIEW_COLUMNS:-64}x${FZF_PREVIEW_LINES:-39} {}
# else
#     tput clear && printf "\\x1b[H\\x1b[2J" && bat
# fi
# '

# export FZF_DEFAULT_OPTS="\
#     --border=sharp \
#     --margin=1 \
#     --padding=1 \
#     --multi \
#     --cycle \
#     --prompt '❯ ' \
#     --pointer '▶ ' \
#     --marker '✓ ' \
#     --extended \
#     --reverse \
#     --bind 'esc:abort,ctrl-space:toggle-preview' \
#     --bind '?:preview:bat {}' \
#     --bind 'ctrl-c:execute-silent(echo -n {2..} | pbcopy)+abort' \
#     --bind 'ctrl-e:execute(echo -n {2..} | xargs -o nvim {})+abort' \
#     --bind 'ctrl-u:preview-page-up,ctrl-d:preview-page-down' \
#     --bind 'enter:execute(less {})' \
#     --preview '(bat --style=header,grid --color=always --line-range :300 {} || eza -Tl2 --color=always {}) 2>/dev/null | head -n200 || less {}' \
#     --bind 'ctrl-/:change-preview-window(right,70%,border-left|down,40%,border-horizontal|hidden|)' \
# "
# --preview-window='bottom:75%:hidden:wrap,border-top'
# --preview="${PREVIEW_CMD}"

# --preview='
# if file --mime-type {} | grep -qF 'image/'; then
#     kitty +kitten icat --transfer-mode=stream --place=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0 {}
# elif [[ {} == *.pdf ]]; then
#     kitty +kitten termpdf {} 2>/dev/null
# else
#     bat --color=always --style=header,grid --line-range :500 {}
#     fi'
#     '

# --preview='
# kitty @ close-window --match title:\"fzf-pdf-preview\" 2>/dev/null
# if file --mime-type {} | grep -qF \"image\"; then
#     kitten icat --clear --transfer-mode=memory --stdin=no --place=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0 {}
# elif [[ \"{}\" == *.pdf ]]; then
#     kitty +kitten pager <(python ~/Dev/scripts/termpdf.py \"{}\")
# else
#     ([[ -f {} ]] && bat --color=always {}) ||
#     ([[ -d {} ]] && tree -C {} | less) ||
#     (echo {} 2>/dev/null | head -n30)
# fi'
# . /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme

# [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
# kitty @ launch kitty --title=\"fzf-pdf-preview\" sh -c '\''python ~/Dev/scripts/termpdf.py/termpdf.py "{}"'\'' &
# echo \"Opened PDF in new window\"

export HWATCH="--no-title --color --no-help-banner --border --with-scrollbar"

# vim: set ft=zsh ts=8 sw=4 sts=4 tw=100 et ai:
