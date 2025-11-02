-- local map = map or vim.keymap.set

-- ~~lhkphuc/dotfiles/blob/master/nvim/lua/plugins/repl.lua~~ not using cell_marker anymore.
--[[
-- In a native script, we mimic a notebook cell by defining a marker
-- Its commonly defined in many editors and programed to use a space and two percent (%) signs after the comment symbol.
-- for python, julia, etc, that would be a line starting with `# %%`
--]]
-- local code_cell = [[# %%]]

---@type LazySpec
return {
  -- {
  --   'klafyvel/nvim-smuggler',
  --   enabled = false,
  --   ft = 'julia',
  --   -- event = { 'BufReadPost', 'BufRead *.jl' },
  --   dependencies = { 'nvim-neotest/nvim-nio' },
  --   keys = {
  --     {
  --       '<localleader>sv',
  --       ':SmuggleVisual<CR>',
  --       desc = 'Smuggle Range jl',
  --       mode = { 'v', 'x' },
  --       ft = 'julia',
  --     },
  --     -- {
  --     --   '<localleader>sg',d
  --     --   ':SmuggleEvalByBlocks<CR>',
  --     --   desc = 'Smuggle Blocks jl',
  --     --   ft = 'julia',
  --     -- },
  --   },
  --   opts = {
  --     {
  --       ui = {
  --         -- mappings = {},
  --         -- result_line_length = nil,
  --         -- result_hl_group = nil,
  --         display_results = false,
  --       },
  --     },
  --   },
  -- },
  'GCBallesteros/Notebooknavigator.nvim',
  {
    'GCBallesteros/jupytext.nvim',
    event = { 'BufReadCmd *.ipynb' },
    priority = 999,
    -- lazy = false,
    -- ft = { 'ipynb' },
    -- lazy = vim.fn.argc(-1) == 0, -- load jupytext early when opening a file from cmdline
    opts = {
      -- style = 'hydrogen',
      custom_language_formatting = {
        julia = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto', -- you can set whatever ft you want here
        },
        python = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto', -- you can set whatever ft you want here
        },
      },
    },
  },
  {
    'jpalardy/vim-slime',
    enabled = true,
    -- event = 'VeryLazy',
    -- lazy = false,
    init = function()
      vim.b['quarto_is_python_chunk'] = false
      Quarto_is_in_python_chunk = function() require('otter.tools.functions').is_otter_language_context('python') end

      vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function! SlimeOverride_EscapeText_quarto(text)
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

      vim.g.slime_target = 'kitty' -- 'neovim' | 'tmux' | 'screen' | etc etc
      vim.g.slime_no_mappings = false
      vim.g.slime_python_ipython = 1

      -- if vim.b[bufnr].filetype == 'julia' then
      --   vim.g.slime_cell_delimiter = '#\\s\\=%%'
      -- elseif vim.b[bufnr].filetype == 'python' then
      vim.g.slime_cell_delimiter = '# %%'
      -- end

      -- vim.g.slime_cell_delimiter = '# %%'

      -- vim.g.slime_cell_delimiter = '#\\s\\=%%'
      -- required true for proper julia repl (kitty/nvim term), but it messes with pt|ipython kek

      vim.g.slime_bracketed_paste = 0
    end,
    config = function()
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = true

      -- required for neovim terminals
      local function mark_terminal()
        vim.g.slime_last_channel = vim.b.terminal_job_id
        local job_id = vim.b.terminal_job_id
        vim.print('job_id: ' .. job_id)
      end

      local function set_terminal()
        vim.b.slime_config = { jobid = vim.g.slime_last_channel }
        vim.fn.call('slime#config', {})
      end

      -- map('n', '<localleader>cm', mark_terminal, { desc = 'mark terminal' })
      -- map('n', '<localleader>cs', set_terminal, { desc = 'set terminal' })
    end,
  },
  --[[ lkhphuc/dotfiles/blob/master/nvim/lua/plugins/repl.lua ]]
  {
    'benlubas/molten-nvim',
    enabled = false,
    build = ':UpdateRemotePlugins',
    event = { 'VeryLazy', 'BufReadPre', 'BufEnter' },
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_height = 25
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MoltenInitPost',
        callback = function()
          -- map('n', '<leader>mx', '<cmd>MoltenDeinit<CR>', { buffer = 0, desc = 'Molten Stop' })
          -- map('n', '<S-CR>', [[:MoltenEvaluateOperator<CR>]], { desc = 'Run' })
          -- map('x', '<S-CR>', [[:MoltenEvaluateVisual<CR>]], { desc = 'Run xSelection' })
          -- map('v', '<S-CR>', [[:<C-u>MoltenEvaluateVisual<CR>gv]], { desc = 'Run vSelection' })
          -- map('n', '<S-CR><S-CR>', 'vib<S-CR>]bj', { remap = true, desc = 'Run cell and move' })
          -- map('n', '<localleader>rn', '<cmd>MoltenHideOutput<CR>', { desc = 'Hide Output' })
          -- map('n', '<localleader>ro', '<cmd>noautocmd MoltenEnterOutput<CR>', { desc = 'Show/Enter Output' })
          -- map('n', '<localleader>ri', '<cmd>MoltenImportOutput<CR>', { desc = 'Import Notebook Output' })
          -- map(
          --   { 'v', 'x', 'o' },
          --   '<localleader>rs',
          --   ":<C-u>MoltenEvaluateVisual<CR>",
          --   { buffer = true, desc = 'molten eval visual' }
          --   -- { desc = 'molten eval visual' }
          -- )
          -- map('x', '<S-CR>', '<cmd>MoltenEvaluateVisual<CR>', { buffer = true, desc = 'Run xSelection' })
          -- map('n', '<S-CR><S-CR>', 'vib<S-CR>]bj', { buffer = true, remap = true, desc = 'Run cell and move' })
          map('n', '<localleader>r', ':MoltenEvaluateOperator<CR>', { buffer = true, desc = 'Run' })
          map({ 'v', 'x' }, '<M-CR>', ':<C-u>MoltenEvaluateVisual<CR>gv', { buffer = true, desc = 'Run vSelection' })
          map('n', '<localleader>ri', ':MoltenImportOutput<CR>', { buffer = true, desc = 'Import Notebook Output' })
        end,
      })
      local imb = function(e)
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernelss()
          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, 'r'):read('a'))['metadata']
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            if venv ~= nil then kernel_name = string.match(venv, '/.+/(.+)') end
          end
          if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(('MoltenInit %s'):format(kernel_name))
          end
          vim.cmd('MoltenImportOutput')
        end)
      end

      --[[ automatically import output chunks from a jupyter notebook ]]
      vim.api.nvim_create_autocmd('BufAdd', {
        pattern = { '*.ipynb' },
        callback = imb,
      })

      --[[ this as well to catch files open like nvim ./foo.ipynb ]]
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.ipynb' },
        callback = function(e)
          if vim.api.nvim_get_vvar('vim_did_enter') ~= 1 then imb(e) end
        end,
      })

      --[[ change config when editing a python file ]]
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*.py',
        callback = function(e)
          if string.match(e.file, '.otter.') then return end
          -- HACK: hacky af
          if require('molten.status').initialized() == 'Molten' then
            vim.fn.MoltenUpdateOption('virt_lines_off_by_1', false)
            vim.fn.MoltenUpdateOption('virt_text_output', false)
          else
            vim.g.molten_virt_lines_off_by_1 = false
            vim.g.molten_virt_text_output = false
          end
        end,
      })

      --[[ Undo said config changes when going back to q/md files ]]
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.qmd', '*.md', '*.ipynb' },
        callback = function(e)
          if string.match(e.file, '.otter.') then return end
          -- HACK: hacky af
          if require('molten.status').initialized() == 'Molten' then
            vim.fn.MoltenUpdateOption('virt_lines_off_by_1', true)
            vim.fn.MoltenUpdateOption('virt_text_output', true)
          else
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_output = true
          end
        end,
      })

      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.ipynb' },
        callback = function()
          if require('molten.status').initialized() == 'Molten' then vim.cmd('MoltenExportOutput') end
        end,
      })
    end,
    config = function()
      local init = function()
        local quarto_cfg = require('quarto.config').config
        quarto_cfg.codeRunner.default_method = 'molten'
        vim.cmd([[MoltenInit]])
      end
      local deinit = function()
        local quarto_cfg = require('quarto.config').config
        quarto_cfg.codeRunner.default_method = 'slime'
        vim.cmd([[MoltenDeinit]])
      end
      map('n', '<localleader>mi', init, { silent = true, desc = 'Initialize Molten' })
      map('n', '<localleader>md', deinit, { silent = true, desc = 'Stop Molten' })
      map('n', '<localleader>mp', ':MoltenImagePopup', { silent = true, desc = 'Molten Image popup' })
      map('n', '<localleader>mh', ':MoltenHideOutput<CR>', { silent = true, desc = 'Hide Output' })
      map('n', '<localleader>mb', ':MoltenOpenInBrowser<CR>', { silent = true, desc = 'Molten Open in browser' })
      map('n', '<localleader>ms', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = 'Show/Enter Output' })
    end,
  },
}
