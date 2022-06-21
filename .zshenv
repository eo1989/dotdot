# vim:ft=zsh
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
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
export DOTFILES=${HOME}/dotdot
export PROJECTS_DIR=${HOME}/dev
export SYNC_DIR=${HOME}/Notes

export IEXCLOUD=pk_265a6ccb26184897ae897bef3333e9f5
export QUANDL=hgwjCyQ2KsYot6Gsh1Vj
export ALPHAVANTAGE=04E3CQSU4564LBDN
export FINNHUB=brof047rh5r8qo238v4g
export FRED=519365e0660f928c1ff9264b38038d85
# if which rg >/dev/null; then
#   export RIPGREP_CONFIG_PATH=${HOME}/.config/rg/rgrc
# fi

# try using +commands -> exists from zshrc
if which yarn >/dev/null; then
  path+=("$(yarn global bin)")
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# add LUA_PATH to the environment ensuring the lua version is set since
# luarocks from homebrew uses lua 5.4 by default; therefore, adding the
# wrong path.
#### TODO:
#### FUCK: THIS DOESNT WORK
case $(uname) in
  Darwin)
    if which luarocks >/dev/null; then
      eval "$(luarocks --lua-version=5.1 path)"
    fi
    ;;
esac

# if [ -d "${HOME}/bin" ]; then
#   path+=("$HOME/bin")
# fi

export LC_ALL=en_US.UTF-8
