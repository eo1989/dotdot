local api = vim.api

api.nvim_create_user_command('KittyTab', function(args)
  if args.fargs and #args.fargs > 0 then
    -- Replace this with any other `new_*` api to choose where to launch it
    -- new_window, new_os_window, new_overlay, new_tab are all good
    -- You can also use 'kitty.current_win'
    require('kitty').new_overlay({
      keep_open = true, -- Keep the window open when the launched process exits,
      -- good(necessary) for short running commands
      focus_on_open = false, -- Dont change focus to the new window
    }, args.fargs)
  end
end, { nargs = '*' })

local function kitty_terms()
  if vim.g.flatten_is_nested then return end
  local kutils = require('kitty.utils')
  Terms = require('kitty.terms')

  Terms.setup {
    dont_attach = not not vim.g.kitty_scrollback,
    attach = {
      default_launch_location = 'os-window',
      create_new_tab = 'os-window',
      target_providers = {
        'just',
        'cargo',
      },
      current_win_setup = {},
      on_attach = function(_, K, _)
        K.setup_make()

        -- TODO:
        -- require('rust-tools').config.options.tools.executor = K.rust_tools_executor()
        _G.Term = kutils.staticify(Terms.get_terminal(0), {})
        Term.make_cmd('Make')
      end,
      bracketed_paste = true,
    },
  }

  local map = vim.keymap.set
  map('n', 'mK', function() Term.run() end, { desc = 'Kitty Run' })
  map('n', 'mk', function() Term.make() end, { desc = 'Kitty Make' })
  -- map('n', 'mkk', function() Term.make_last() end, { desc = 'Kitty ReMake' })

  -- TODO: S-CR and C-CR can be used

  map('n', 'mr', function() return Term.send_operator() end, { expr = true, desc = 'Kitty Send' })
  map('x', 'R', function() return Term.send_operator() end, { expr = true, desc = 'Kitty Send' })
  -- map(
  --   'n',
  --   'mrr',
  --   function() return Term.send_operator { type = 'line', range = '$' } end,
  --   { expr = true, desc = 'Kitty Send Line' }
  -- )
  -- map('n', 'yu', function() Term.get_selection() end, { desc = 'Yank selection From Kitty' })
  -- map(
  --   'n',
  --   'yhu',
  --   function() Term.hints { type = 'url', yank = 'register' } end,
  --   { desc = 'Yank hinted url From Kitty' }
  -- )
  -- map(
  --   'n',
  --   'yhf',
  --   function() Term.hints { type = 'path', yank = 'register' } end,
  --   { desc = 'Yank hinted path From Kitty' }
  -- )
  -- map(
  --   'n',
  --   'yhl',
  --   function() Term.hints { type = 'line', yank = 'register' } end,
  --   { desc = 'Yank hinted line From Kitty' }
  -- )
  -- map(
  --   'n',
  --   'the',
  --   function() Term.hints { type = 'linenum', yank = 'register' } end,
  --   { desc = 'Yank hinted linenum From Kitty' }
  -- )
  -- map(
  --   'n',
  --   'yhw',
  --   function() Term.hints { type = 'word', yank = 'register' } end,
  --   { desc = 'Yank hinted word From Kitty' }
  -- )
  -- map(
  --   'n',
  --   '<localleader>ohu',
  --   function() Term.hints { type = 'url', program = true } end,
  --   { desc = 'hinted url From Kitty' }
  -- )
  map(
    'n',
    '<localleader>ohf',
    function() Term.hints { type = 'path', launch = 'nvim' } end,
    { desc = 'hinted file From Kitty in Nvim' }
  )
  -- map(
  --   'n',
  --   '<localleader>ohp',
  --   function() Term.hints { type = 'path', program = true } end,
  --   { desc = 'hinted file From Kitty' }
  -- )
  -- map(
  --   'n',
  --   '<localleader>ohe',
  --   function() Term.hints { type = 'linenum', launch = 'nvim' } end,
  --   { desc = 'hinted linenum From Kitty' }
  -- )
  -- map('n', '<c-;>', '<cmd>Kitty<cr>', { desc = 'Kitty Open' })
  -- map('n', '<localleader>oK', '<cmd>Kitty<cr>', { desc = 'Kitty Open' })
  -- map('n', '<localleader>oKC', function() Term.cmd('cd ' .. vim.fn.getpwd()) end, { desc = 'Kitty CWD' })
  map('n', '<localleader>ok', function() Term.move('this-tab') end, { desc = 'Kitty To This Tab' })
  -- map('n', '<localleader>oKN', function() Term.move('new-tab') end, { desc = 'Kitty To New Tab' })
  -- map('n', '<localleader>oKW', function() Term.move('new-window') end, { desc = 'Kitty To New OSWin' })
  -- map('ca', 'K', ":=require'kitty.current_win'", { desc = 'Kitty Control' })
  -- map('ca', 'T', ':=Term', { desc = 'Kitty Control' })
  -- map('ca', 'KT', ":=require'kitty.terms'", { desc = 'Kitty Control' })
  -- map('ca', 'KK', ":=require'kitty'", { desc = 'Kitty Control' })

  -- TODO:
end

---@type LazySpec
return {
  {
    'indianboy42/kitty.lua',
    event = 'VeryLazy',
    cond = not not vim.env.KITTY_PID and not vim.g.kitty_scrollback and not eo.KITTY_SCROLLBACK,
    -- opts = {},
    keys = {
      {
        '<localleader>ok',
        ":require('kitty').open()<CR>",
        desc = 'kitty open',
      },
    },
    config = function() kitty_terms() end,
  },
  -- {
  --   'mikesmithgh/kitty-scrollback.nvim',
  --   enable = true,
  --   build = ':KittyScrollbackGenerateKittens',
  --   cmd = {
  --     'KittyScrollbackGenerateKittens',
  --     'KittyScrollbackCheckHealth',
  --     'KittyScrollbackGenerateCommandLineEditing',
  --   },
  --   lazy = true,
  --   event = { 'User KittyScrollbackLaunch' },
  --   opts = {
  --     {
  --       callbacks = {
  --         after_paste_window_ready = (function()
  --           local once = true
  --           return function(paste_window_data, kitty_data, opts)
  --             if once then
  --               once = false
  --               vim.keymap.set(
  --                 'n',
  --                 '<esc>',
  --                 '<C-w>k',
  --                 { desc = 'Back to the scrollback', buffer = paste_window_data.paste_window.bufid }
  --               )
  --             end
  --           end
  --         end)(),
  --       },
  --     },
  --   },
  -- },
}

--[[
--  example:
--  require("rust-tools").config.options.tools.executor = require'kitty'.rust_tools_executor()
--]]
