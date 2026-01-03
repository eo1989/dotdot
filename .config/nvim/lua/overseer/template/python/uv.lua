---@module "overseer"
---@type overseer.TemplateFileDefinition

local consts = require('overseer.constants')
local files = require('overseer.files')
local ovs = require('overseer')
local STATUS = require('overseer.constants').STATUS
local TAG = consts.TAG

-- local condition = {
--     callback = function() return vim.uv.fs_stat('uv.lock') == nil end,
--   },

local inProj = function(opts)
  return files.exists(files.join(opts.dir, 'requirements.txt'))
    or files.exists(files.join(opts.dir, 'pyproject.toml'))
    or files.exists(files.join(opts.dir, 'poetry.toml'))
    or files.exists(files.join(opts.dir, 'uv.lock'))
    or vim.uv.fs_stat('uv.lock') == nil
end

return {
  name = 'uv',
  builder = function()
    ---@type overseer.TaskDefinition
    return {
      cmd = 'uv',
      strategy = {
        'orchestrator',
        tasks = {
          {
            cmd = 'uv run',
            components = {
              {
                'open_output',
                direction = 'dock',
                focus = true,
                on_start = 'never',
                on_complete = 'failure',
              },
              'default',
            },
          },
          {
            cmd = 'uv lock',
            components = {
              {
                'open_output',
                direction = 'dock',
                focus = true,
                on_start = 'never',
                on_complete = 'failure',
              },
              'default',
            },
          },
          {
            cmd = 'uv sync',
            components = {
              {
                'open_output',
                direction = 'dock',
                focus = true,
                on_start = 'never',
                on_complete = 'failure',
              },
              'default',
            },
          },
        },
      },
      components = { 'default', 'unique' },
    }
  end,
  condition = {
    callback = function() return vim.uv.fs_stat('uv.lock') == nil end,
  },
}

-- return {
--   condition = {
--     callback = function(opts) return inProj(opts) or vim.bo.filetype == 'python' end,
--   },
--   generator = function(_, cb)
--     local ret = {}
--     local priority = 60
--     local pr = function()
--       priority = priority + 1
--       return priority
--     end
--
--     table.insert(ret, {
--       name = 'uv',
--       builder = function()
--         ---@type overseer.TaskDefinition
--         return {
--           cmd = 'uv',
--           strategy = {
--             'orchestrator',
--             tasks = {
--               {
--                 cmd = 'uv lock',
--                 components = {
--                   {
--                     'open_output',
--                     direction = 'dock',
--                     focus = true,
--                     on_start = 'never',
--                     on_complete = 'failure',
--                   },
--                   'default',
--                 },
--               },
--               {
--                 cmd = 'uv sync',
--                 components = {
--                   {
--                     'open_output',
--                     direction = 'dock',
--                     focus = true,
--                     on_start = 'never',
--                     on_complete = 'failure',
--                   },
--                   'default',
--                 },
--               },
--             },
--           },
--           components = { 'default' },
--         }
--       end,
--     })
--
--     -- table.insert(ret, {
--     --   name = 'Run main.py',
--     --   builder = function()
--     --     return {
--     --       name = 'Running main.py',
--     --       cmd = 'python main.py',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {
--     --     callback = function() return files.exists('main.py') end,
--     --   },
--     --   priority = 1,
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Run main.pyw',
--     --   builder = function()
--     --     return {
--     --       name = 'Running main.pyw',
--     --       cmd = 'python main.pyw',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {
--     --     callback = function() return files.exists('main.pyw') end,
--     --   },
--     --   priority = 1,
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Profile main.py',
--     --   builder = function()
--     --     return {
--     --       name = 'Profile main.py',
--     --       cmd = 'py-spy record -o profile.svg -- python main.py',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {
--     --     callback = function() return files.exists('main.py') end,
--     --   },
--     --   priority = 1,
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Live Profile main.py',
--     --   builder = function()
--     --     return {
--     --       name = 'Live Profile main.py',
--     --       cmd = 'py-spy top -- python main.py',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {
--     --     callback = function() return files.exists('main.py') end,
--     --   },
--     --   priority = 1,
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Open profile data',
--     --   builder = function()
--     --     return {
--     --       name = 'Open profile data',
--     --       cmd = 'browser profile.svg',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {
--     --     callback = function() return files.exists('main.py') end,
--     --   },
--     --   priority = 1,
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Build Documentation (pdf)',
--     --   builder = function()
--     --     return {
--     --       name = 'Building PDF Docs',
--     --       cmd = 'make latexpdf',
--     --       cwd = 'docs',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {
--     --     callback = function() return files.exists(files.join(opts.dir, 'docs')) end,
--     --   },
--     --   priority = pr(),
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Open Documentation (pdf)',
--     --   builder = function()
--     --     return {
--     --       name = 'Open Docs',
--     --       --
--     --       -- cmd = "open -A /Applications/PDF Expert.app/Contents/MacOS/PDF Expert",
--     --       cmd = vim.fn.expand('~') .. '/Users/eo/.cargo/bin/meowpdf',
--     --       cwd = 'docs',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {
--     --     callback = function() return files.exists(files.join(opts.dir, 'docs')) end,
--     --   },
--     --   priority = pr(),
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Format all',
--     --   builder = function()
--     --     return {
--     --       name = 'Format all files',
--     --       -- cmd = 'ruff format --preview scintilla_control/',
--     --       cmd = 'ruff format --preview',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {},
--     --   priority = pr(),
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Lint all',
--     --   builder = function()
--     --     return {
--     --       name = 'Lint all files',
--     --       -- cmd = 'ruff --preview --watch scintilla_control/',
--     --       cmd = 'ruff --preview --watch',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {},
--     --   priority = pr(),
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Type check all',
--     --   builder = function()
--     --     return {
--     --       name = 'Type check all files',
--     --       -- cmd = 'pyright --watch scintilla_control/',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {},
--     --   priority = pr(),
--     -- })
--     -- table.insert(ret, {
--     --   name = 'Make dependency graph',
--     --   builder = function()
--     --     return {
--     --       name = 'Make dependency graph',
--     --       cmd = 'pydeps scintilla_control/__init__.py',
--     --       components = { 'default', 'unique' },
--     --     }
--     --   end,
--     --   condition = {
--     --     callback = function(opts) return files.exists(files.join(opts.dir, 'docs')) end,
--     --   },
--     --   priority = pr(),
--     -- })
--
--     cb(ret)
--   end,
-- }
