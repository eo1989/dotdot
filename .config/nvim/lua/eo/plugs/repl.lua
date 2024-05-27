return {
  {
    'GCBallesteros/jupytext.nvim',
    -- event = 'VeryLazy',
    lazy = false,
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto', -- you can set whatever ft you want here
        },
        r = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto', -- you can set whatever ft you want here
        },
      },
    },
    -- opts = {
    --   style = 'markdown',
    --   output_extension = 'md',
    --   force_ft = 'markdown',
    -- },
  },
  {
    'jpalardy/vim-slime',
    -- event = 'VeryLazy',
    lazy = false,
    init = function()
      vim.b['quarto_is_python_chunk'] = false
      Quarto_is_in_python_chunk = function() require('otter.tools.functions').is_otter_language_context('python') end

      vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
        call v:lua.Quarto_is_in_python_chunk()
        if exists('g:slime_python_ipython') && len(split(a:text, "\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
          return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
        else
          if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
            return [a:text, "\n"]
          else
            return [a:text]
          end
        end
      endfunction
      ]])

      vim.g.slime_target = 'neovim'
      vim.g.slime_python_ipython = 1

      -- vim.b.slime_cell_delimiter = '# %%'
    end,
    config = function()
      local function mark_terminal() vim.g.slime_last_channel = vim.b.terminal_job_id end

      local function set_terminal() vim.b.slime_config = { jobid = vim.g.slime_last_channel } end

      map('n', '<localleader>cm', mark_terminal, { desc = 'mark terminal' })
      map('n', '<localleader>cs', set_terminal, { desc = 'set terminal' })
      -- require('which-key').register {
      --   ['<localleader>cm'] = { mark_terminal, '[m]ark terminal' },
      --   ['<localleader>cs'] = { set_terminal, '[s]et terminal' },
      -- }
    end,
  },
  {
    'benlubas/molten-nvim',
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_height = 20
      vim.g.molten_auto_open_output = true
    end,
    keys = {
      { '<leader>mi', ':MoltenInit<CR>', desc = '[m]olten [i]nit' },
      { '<leader>mv', ':<C-u>MoltenEvaluateVisual<CR>', mode = 'v', desc = 'molten eval visual' },
      { '<leader>mr', ':<C-u>MoltenReevaluateCell<CR>', desc = 'molten re-eval cell' },
    },
  },
}
