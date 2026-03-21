-- DOCS https://codecompanion.olimorris.dev/
--------------------------------------------------------------------------------

-- https://platform.openai.com/usage
-- https://platform.openai.com/docs/models

local api, uv = vim.api, vim.uv
local model = 'gpt-5-mini'
local reasoning_effort = 'minimal' -- all GPT-5 models reason, "mediu " is too slow

------------------------------------------------------------------------------------------------------

-- local function on_exit(obj)
--   print(obj.code)
--   print(obj.signal)
--   print(obj.stdout)
--   print(obj.stderr)
-- end

------------------------------------------------------------------------------------------------------

local function spinnerNotificationWhileRequest()
  if not package.loaded['snacks'] then return end

  local spinners = require('snacks.util').spinner()
  local updateIntervalMs = 250
  local timer
  local spinner_group = api.nvim_create_augroup('CodeCompanionSpinner', { clear = true })

  local function close_timer()
    if timer then
      timer:stop()
      timer:close()
      timer = nil
    end
  end

  local function start_timer(id)
    close_timer()
    timer = assert(uv.new_timer())
    timer:start(
      0,
      updateIntervalMs,
      vim.schedule_wrap(function()
        local spinner = spinners[math.floor(uv.now() / updateIntervalMs) % #spinners + 1]
        vim.notify('Request running ' .. spinner, vim.log.levels.DEBUG, {
          title = 'CodeCompanion',
          icon = '',
          timeout = false,
          id = id,
        })
      end)
    )
  end

  api.nvim_create_autocmd('User', {
    group = spinner_group,
    desc = 'User: CodeCompanion spinner (start)',
    pattern = 'CodeCompanionRequestStarted',
    callback = function(ctx) start_timer(ctx.data.id) end,
  })
  api.nvim_create_autocmd('User', {
    group = spinner_group,
    desc = 'User: CodeCompanion spinner (stop)',
    pattern = 'CodeCompanionRequestFinished',
    callback = function(ctx)
      close_timer()
      vim.notify('Request finished ✓', nil, {
        title = 'CodeCompanion',
        icon = '',
        timeout = 2000,
        id = ctx.data.id,
      })
    end,
  })
end

local function setupFinishSound()
  local group = api.nvim_create_augroup('CodeCompanionSound', { clear = true })
  api.nvim_create_autocmd('User', {
    group = group,
    desc = 'User: play CodeCompanion completion sound on macOS',
    pattern = 'CodeCompanionRequestFinished',
    callback = function()
      if jit.os ~= 'OSX' or vim.fn.executable('afplay') == 0 then return end
      local sound =
        '/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/head_gestures_double_shake.caf'
      vim.system { 'afplay', sound }
    end,
  })
end

local function resolveOpenAIHTTPEnv()
  local env_candidates = {
    os.getenv('OPENAI_API_KEY'),
    os.getenv('openai_api_key'),
    os.getenv('OPENAI_API_KEY_FILE'),
  }

  for _, value in ipairs(env_candidates) do
    if value and value:match('%S') then return { api_key = value } end
  end

  local apiKeyFile = vim.fn.expand('~/Dev/.env')
  if apiKeyFile ~= '' and uv.fs_stat(apiKeyFile) then return {
    api_key = ('cmd:cat %q'):format(apiKeyFile),
  } end

  return nil
end

return {
  'olimorris/codecompanion.nvim',
  cmd = { 'CodeCompanion', 'CodeCompanionChat' },
  -- init = function() vim.g.whichkeyAddSpec { '<leader>a', group = ' AI' } end,
  config = function(_, opts)
    require('codecompanion').setup(opts)

    spinnerNotificationWhileRequest()

    setupFinishSound()
  end,
  keys = {
    {
      '<leader>ac',
      '<cmd>CodeCompanionChat toggle<CR>',
      desc = ' Chat (toggle)',
      mode = { 'n', 'v' },
      silent = true,
    },
    -- stylua: ignore start
    -- stylua: ignore end
    {
      '<leader><C-a>',
      '<cmd>CodeCompanionActions<CR>',
      desc = ' Chat (toggle)',
      silent = true,
      noremap = true,
      mode = { 'n', 'v' },
    },
    -- stylua: ignore start
      { "<leader>an", "<cmd>CodeCompanionChat<CR>", desc = " Chat (new)" },
      { "<leader>aa", ":CodeCompanion<CR>", mode = "x", desc = " 󰘎 Prompt" },
      -- builtin-prompts https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
      { "<leader>ae", function() require("codecompanion").prompt("explain") end, mode = "x", desc = " Explain" },
      { "<leader>af", function() require("codecompanion").prompt("fix") end, mode = "x", desc = " Fix" },
      -- my own prompts
      { "<leader>as", function() require("codecompanion").prompt("simplify") end, mode = "x", desc = " Simplify" },
    -- { "<leader>ap", function() require("codecompanion").prompt("proofread") end, mode = "x", desc = " Proofread" },
    -- stylua: ignore end
  },
  opts = {
    display = {
      diff = { enabled = true }, -- https://codecompanion.olimorris.dev/configuration/chat-buffer.html#diff

      -- https://codecompanion.olimorris.dev/configuration/chat-buffer.html
      chat = {
        auto_scroll = true,
        intro_message = '',
        fold_context = true, -- BUG not working
        icons = { chat_context = '󰔌' }, -- icon for the fold context
        window = {
          opts = {
            foldlevel = 1,
            foldmethod = 'expr',
            foldexpr = 'v:lua.vim.treesitter.foldexpr()', -- allow folding codeblocks
            statuscolumn = ' ', -- padding
          },
        },
      },
    },
    strategies = {
      inline = { adapter = 'openai' },
      chat = {
        adapter = 'openai',
        keymaps = {
          close = { modes = { n = 'q' }, opts = { nowait = true } },
          stop = { modes = { n = '<C-c>' } },
          clear = { modes = { n = '<C-k>', i = '<D-k>' } },
          next_header = { modes = { n = '<C-j>', i = '<C-j>' } },
          previous_header = { modes = { n = '<C-k>', i = '<C-k>' } },
          fold_code = { modes = { n = 'zz' } },
        },
      },
    },
    adapters = {
      acp = {
        codex = function()
          return require('codecompanion.adapters').extend('codex', {
            defaults = {
              auth_method = 'openai-api-key', -- "codex-api-key"
            },
            env = {
              OPENAI_API_KEY = os.getenv('OPENAI_API_KEY'),
            },
          })
        end,
      },
      -- '$HOME/Library/Mobile Documents/com~apple~CloudDocs/Dotfolder/private dotfiles/openai-api-key.txt'
      http = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = resolveOpenAIHTTPEnv(),
            schema = {
              model = { default = model },
              reasoning_effort = { default = reasoning_effort },
            },
          })
        end,
      },
    },
    prompt_library = {
      -- https://codecompanion.olimorris.dev/extending/prompts.html
      ['Simplify'] = {
        strategy = 'inline',
        opts = {
          modes = { 'v' },
          short_name = 'simplify',
          auto_submit = true,
          stop_context_insertion = true,
          user_prompt = false,
        },
        prompts = {
          {
            role = 'system',
            content = function(ctx)
              return ([[
                I want you to act as a senior %s developer.


                I will send you some code, and I want you to simplify
                the code while not diminishing its readability.


                Keep the indentation level the same, and do not change
                for formatting style.
              ]]):format(ctx.filetype)
            end,
          },
          {
            role = 'user',
            content = function(ctx)
              -- stylua: ignore
              return require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
            end,
            opts = { contains_code = true },
          },
        },
      },
      -- ['Proofread'] = {
      --   strategy = 'inline',
      --   opts = {
      --     modes = { 'v' },
      --     short_name = 'proofread',
      --     auto_submit = true,
      --     stop_context_insertion = true,
      --     user_prompt = false,
      --   },
      --   prompts = {
      --     {
      --       role = 'system',
      --       content = function(_ctx)
      --         return [[
      --           You are an editor for the English language.
      --           I will send you some text, and I want you to improve the
      --           language, without changing the meaning.
      --         ]]
      --       end,
      --     },
      --     {
      --       role = 'user',
      --       content = function(ctx)
      --         -- stylua: ignore
      --         return require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
      --       end,
      --     },
      --   },
      -- },
    },
  },
}

-- vim: set foldlevel=2
