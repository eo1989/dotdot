# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# [[ "ZSH_THEME" == (p10k|powerlevel10k)* ]] || return 1
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# path+=(
#   ~/.local/bin(N-/)
#   ~/.local/share/bob/nightly/bin(N-/)
#   $path
# )

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }


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

if exists npm; then
    eval "$(npm completion)"
fi

if exists navi; then
    eval "$(navi widget zsh)"
fi

if exists zoxide; then
    eval "$(zoxide init zsh)"
fi

if exists bob; then
    eval "$(bob complete zsh)"
fi

if [[ "${TERM}" == "xterm-kitty" ]]; then
    kitty + complete setup zsh | source /dev/stdin
fi

_comp_options+=(globdots) # Include hidden files.

CONFIG_FILES=(
  dashboard
  zsh_plugins
  cli_settings
  opts
  nav
  completion
  term_utils
  aliases
  docs_man
  git_gh
  homebrew
)
# [[ "$OSTYPE" =~ "darwin" ]] && CONFIG_FILES+=()
for filename in "${CONFIG_FILES[@]}"; do
    . "$ZDOTDIR/config/$filename.zsh"
done
# unset filename
# unset CONFIG_FILES

# export PIP_DISABLE_PIP_VERSION_CHECK=1
# export MPLBACKEND="module://matplotlib-backend-kitty"
# LS_COLORS="$(vivid generate snazzy)"
# export LS_COLORS
# [ -f /opt/homebrew/share/zsh-autopair/autopair.zsh ] && . /opt/homebrew/share/zsh-autopair/autopair.zsh
# [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && . /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && . /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# [ -f /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh ] && . /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

alias dotdot='/opt/homebrew/bin/git --git-dir="$HOME/.dotdot/" --work-tree="$HOME"'

# if exists pigz; then
# 	alias gzip=pigz
# 	alias gunzip="pigz -d"
# 	alias zcat="pigz -dc"
# fi

# . /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme


# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
# [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
