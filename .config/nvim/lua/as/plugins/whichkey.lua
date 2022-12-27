return function()
  -- require('as.highlights').plugin('whichkey', {
  --   theme = {
  --     ['*'] = {
  --       { WhichkeyFloat = { link = 'Todo' } },
  --     },
  --     horizon = { { WhichKeySeparator = { link = 'Todo' } }, },
  --   },
  -- })

  local wk = require('which-key')
  wk.setup({
    plugins = {
      spelling = {
        enabled = false,
        marks = {
          enabled = true,
        },
      },
    },
    window = {
      border = as.style.current.border,
    },
    layout = {
      align = 'center',
    },
  })

  wk.register({
    ['<space><space>'] = 'toggle fold under cursor',
    [']'] = {
      name = '+next',
      ['<space>'] = 'add space below',
    },
    ['['] = {
      name = '+prev',
      ['<space>'] = 'add space above'
    },
    ['g>'] = 'show message history',
    -- ['<M-x><M-c>'] = [[:lua ]],
    ['<leader>'] = {
      -- a = { name = '+projectionist' },
      b = 'buffer management hydra',
      c = { name = '+code-action' },
      d = { name = '+debug/database', h = 'dap hydra' },
      f = { name = '+telescope' },
      h = { name = '+git-action' },
      z = 'window scroll hydra',
      n = {
        name = '+new',
        f = 'create a new file',
        s = 'create new file in a split',
      },
      p = {
        name = '+packer',
        c = 'clean',
        s = 'sync',
        C = 'compile',
      },
      q = {
        name = '+quit',
        w = 'close window (and buffer)',
        q = 'delete buffer',
      },
      g = 'grep word under the cursor',
      l = {
        name = '+list',
        i = 'toggle location list',
        s = 'toggle quickfix',
        l = 'toggle lsp diagnostics',
      },
      e = {
        name = '+edit',
        v = 'open vimrc in a vertical split',
        p = 'open plugins file in a vertical split',
        z = 'open zshrc in a vertical split',
      },
      r = { name = '+lsp-refactor' },
      o = {
        name = '+only',
        n = 'close all other buffers',
      },
      t = {
        name = '+tab',
        c = 'tab close',
        n = 'tab edit current buffer',
      },
      s = {
        name = '+source',
        w = 'swap buffers horizontally',
        o = 'source current buffer',
        v = 'source init.vim',
        s = {{ '<Cmd>SnipRun<CR>', 'Run Snippets' }, { mode = 'x' }},
      },
      y = { name = '+yank' },
      U = 'uppercase all word',
      ['<CR>'] = 'repeat previous macro',
      [','] = 'go to previous buffer',
      ['='] = 'make windows equal size',
      [')'] = 'wrap with parens',
      ['}'] = 'wrap with braces',
      ['"'] = 'wrap with double quotes',
      ["'"] = 'wrap with single quotes',
      ['`'] = 'wrap with back ticks',
      ['['] = 'replace cursor word in file',
      [']'] = 'replace cursor word in line',
    },
    ['<S-M-x>'] = 'show token under the cursor',
    ['<localleader>'] = {
      name = 'local leader',
      -- h = {
      --   name = '+harpoon',
      --   a = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add" },
      --   m = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" },
      --   c = { "<cmd>lua require('harpoon.cmd-ui').toggle_quickcmd_menu()<CR>", "cmdMenu"},
      --   n = {
      --     name = '+jump',
      --     ["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1) <CR>", "Jump 1" },
      --     ["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2) <CR>", "Jump 2" },
      --     ["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3) <CR>", "Jump 3" },
      --     ["4"] = { "<cmd>lua require('harpoon.term').gotoTerminal(1) <CR>", "Terminal" },
      --     ["5"] = { "<cmd>lua require('harpoon.term').sendCommand(1,1) <CR>", "Command 1" },
      --     ["6"] = { "<cmd>lua require('harpoon.term').sendCommand(1,2) <CR>", "Command 2" },
      --   },
      -- },
      i = { name = '+iswap' },
      d = { name = '+dap' },
      g = { name = '+git' },
      G = 'Git hydra',
      n = { name = '+neogen' },
      o = { name = '+neorg' },
      t = { name = '+neotest' },
      -- r = {
      --   name = '+Runner',
      --   s = {{ "<Cmd>lua require('sniprun').run('v')<CR>", "Run Snippets" }, mode = 'v'},
        -- r = {{ "<cmd>lua local  = require('')"}},
        -- p = { "<Plug>(SnipRun)Operator run", mode = 'n'} -- this might break
        -- p = {{ "<Plug>SnipRunOperator<CR>", 'OperatorRun!'}, mode = 'n'} -- this might break
      -- },
      -- m = {
      --   name = '+Magma',
      --   -- l = {{ '<Cmd>MagmaEvaluateLine<CR>', 'Eval line'}, mode = 'v'},
      --   c = 'Reval Cell',
      --   l = 'Evaluate line',
      --   o = 'Show output',
      --   -- i = 'Magma init kernel',
      --   d = 'delete',
      --   -- u = 'Deinitialize kernel',
      --   v = "Evaluate Visual",
      --
      -- },
      w = {
        name = '+window',
        h = 'change two vertically split windows to horizontal splits',
        v = 'change two horizontally split windows to vertical splits',
        x = 'swap current window with the next',
        j = 'resize: downwards',
        k = 'resize: upwards',
      },
      v = {
        name = 'View',
        v = { "<Cmd>split term://vd <cfile><CR>", "VisiData" },
      }, -- #1
      l = 'redraw window',
      z = 'center view port',
      [','] = 'add comma to EOL',
      [';'] = 'add semicolon to EOL',
      ['?'] = 'search for cword in google',
      ['!'] = 'search for cword in google',
      ['['] = 'abolish = sub cword in file',
      [']'] = 'abolish = sub cword on line',
      ['/'] = 'find matching word in buffer',
      ['<tab>'] = 'open commandline bufferlist',
    },
  })
end
--#1 https://github.com/alpha2phi/dotfiles/blob/main/config/nvim/lua/config/whichkey.lua
