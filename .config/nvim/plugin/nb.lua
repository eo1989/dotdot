-- Provides a command to create a blank new python notebook
-- TODO: add julia support
-- NOTE: the metadata is needed for jupytext to understand how to parse the notebook

-- if using a lang different than python, the template will require changing.
local default_nb = [[
  {
    "cells": [
      {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
          ""
        ]
      }
    ],
    "metadata": {
      "kernelspec": {
        "display_name": "Python 3",
        "language": "python",
        "name": "python3",
      },
      "language_info": {
        "codemirror_mode": {
          "name": "ipython"
        },
        "file_extension": ".py",
        "mimetype": "text/x-python",
        "name": "python",
        "nbconvert_exporter": "python",
        "pygments_lexer": "ipython3",
      }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_nb(filename)
  local path = filename .. '.ipynb'
  local file = io.open(path, 'w')
  if file then
    file:write(default_nb)
    file:close()
    vim.cmd('edit ' .. path)
  else
    print("Error: Couldn't open new notebook for writing")
  end
end

vim.api.nvim_create_user_command('NewNotebook', function(opts) new_nb(opts.args) end, {
  nargs = 1,
  complete = 'file',
})

--[[ Test if the command ":NewNotebook folder/notebook_name" will start a new notebook from scratch.]]
