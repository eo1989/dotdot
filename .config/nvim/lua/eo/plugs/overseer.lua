---@type LazySpec
return {
  {
    'stevearc/overseer.nvim',
    enabled = true,
    event = 'VeryLazy',
    cmd = {
      -- 'Grep',
      -- 'Make',
      -- 'OverseerDebugParser',
      -- 'OverseerInfo',
      'OverseerOpen',
      'OverseerClose',
      'OverseerToggle',
      'OverseerSaveBundle',
      'OverseerLoadBundle',
      'OverseerDeleteBundle',
      'OverseerRunCmd',
      'OverseerRun',
      'OverseerRestartLast',
      'OverseerInfo',
      'OverseerBuild',
      'OverseerQuickAction',
      'OverseerTaskAction',
      'OverseerClearCache',
    },
    keys = {
      -- stylua: ignore start
      -- { '<localleader>oo', '<cmd>OverseerToggle<CR>',         mode = 'n', { desc = 'Toggle Overseer'       } },
      -- { '<localleader>or', '<cmd>OverseerRun<CR>',            mode = 'n', { desc = 'Overseer Run'          } },
      -- { '<localleader>oc', '<cmd>OverseerRunCmd<CR>',         mode = 'n', { desc = 'Overseer Run cmd'      } },
      -- { '<localleader>ol', '<cmd>OverseerLoadBundle<CR>',     mode = 'n', { desc = 'Overseer Load Bundle'  } },
      -- { '<localleader>ob', '<cmd>OverseerToggle! bottom<CR>', mode = 'n', { desc = 'Toggle Overseer (btm)' } },
      -- { '<localleader>od', '<cmd>OverseerQuickAction<CR>',    mode = 'n', { desc = 'Overseer QuickAction'  } },
      -- { '<localleader>os', '<cmd>OverseerTaskAction<CR>',     mode = 'n', { desc = 'Overseer Task Action'  } },
      { '<localleader>or', '<cmd>OverseerRun<CR>',            desc = 'run task'           },
      { '<localleader>or', '<cmd>OverseerRestartLast<CR>',    desc = 'Restart task'       },
      { '<localleader>oo', '<cmd>OverseerToggle<CR>',         desc = 'Task list'          },
      { '<localleader>oc', '<cmd>OverseerBuild<CR>',          desc = 'Task builder'       },
      { '<localleader>od', '<cmd>OverseerQuickAction<CR>',    desc = 'Action recent task' },
      { '<localleader>os', '<cmd>OverseerTaskAction<CR>',     desc = 'Task action'        },
      { '<localleader>ol', '<cmd>OverseerClearCache<CR>',     desc = 'Clear cache'        },
      { '<localleader>ob', '<cmd>OverseerLoadBundle<CR>',     desc = 'Load bundle'        },
      { '<localleader>ob', '<cmd>OverseerSaveBundle<CR>',     desc = 'Save bundle'        },
      { '?N',              '<cmd>OverseerInfo<CR>',           desc = 'Overseer info'      },
      -- stylua: ignore end
    },
    ---@type overseer.Config
    opts = {
      strategy = { 'jobstart', preserve_output = true },
      dap = true,
      task_list = {
        bindings = {
          ['<C-j'] = false,
          ['<C-k'] = false,
          ['<C-h'] = false,
          ['<C-l'] = false,
          ['<C-u'] = 'ScrollOutputUp',
          ['<C-d'] = 'ScrollOutputDown',
        },
        default_detail = 2,
        direction = 'bottom',
        max_height = 25,
        min_height = 15,
      },
      default_template_prompt = 'allow',
      task_launcher = {
        bindings = {
          n = {
            ['<localleader>c'] = 'Cancel',
            ['<ESC>'] = 'Cancel',
          },
        },
      },
      templates = {
        'build.builtin',
        'build.python',
        'build.julia',
        'build.quarto',
      },
      template_dirs = { 'lua.overseer.template.build' },
      log = {
        {
          type = 'echo',
          level = vim.log.levels.WARN,
        },
        {
          type = 'file',
          filename = 'overseer.log',
          level = vim.log.levels.DEBUG,
        },
      },
      component_aliases = {
        default = {
          { 'display_duration', detail_level = 2 },
          'on_output_summarize',
          'on_exit_set_status',
          { 'on_complete_notify', system = 'unfocused' },
          { 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
        },
        unique_replace = { 'unique', replace = false },
        default_neotest = {
          'unique',
          { 'on_complete_notify', system = 'unfocused', on_change = true },
          'default',
        },
      },
      post_setup = {},
    },
    opts_extend = { 'extra_templates', 'overseer.template' },
    ---@param opts OverseerUserConfig
    config = function(_, opts)
      local extra_templates = opts.extra_templates or {}
      opts.extra_templates = nil

      local overseer = require('overseer')
      overseer.setup(opts)

      -- register extra templates
      for _, template in pairs(extra_templates) do
        overseer.register_template(template)
      end

      vim.api.nvim_create_user_command('OverseerRestartLast', function()
        local tasks = overseer.list_tasks { recent_first = true }
        if vim.tbl_isempty(tasks) then
          vim.notify('No tasks found', vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], 'restart')
        end
      end, {})

      opts.templates = vim.tbl_keys(opts.templates)
      for _, cb in pairs(opts.post_setup) do
        cb()
      end
      vim.api.nvim_create_user_command('OverseerDebugParser', 'lua require("overseer").debug_parser()', {})
      vim.api.nvim_create_user_command('OverseerTestOutput', function(param)
        vim.cmd.tabnew()
        vim.bo.bufhidden = 'wipe'
        local TaskView = require('overseer.task_view')
        TaskView.new(0, {
          select = function(self, tasks)
            for _, task in ipairs(tasks) do
              if task.metadata.neotest_group_id then return task end
            end
            self:dispose()
          end,
        })
      end, {})

      -- vim.api.nvim_create_user_command('Grep', function(params)
      --   local args = vim.fn.expandcmd(params.args)
      --   -- Insert args at the '$*' in the grepprg
      --   local cmd, num_subs = vim.o.grepprg:gsub('%$%*', args)
      --   if num_subs == 0 then cmd = cmd .. ' ' .. args end
      --   local cwd
      --   local has_oil, oil = pcall(require, 'oil')
      --   if has_oil then cwd = oil.get_current_dir() end
      --   local task = overseer.new_task {
      --     cmd = cmd,
      --     cwd = cwd,
      --     name = 'grep ' .. args,
      --     components = {
      --       {
      --         'on_output_quickfix',
      --         errorformat = vim.o.grepformat,
      --         open = not params.bang,
      --         open_height = 8,
      --         items_only = true,
      --       },
      --       -- We don't care to keep this around as long as most tasks
      --       { 'on_complete_dispose', timeout = 30, require_view = {} },
      --       'default',
      --     },
      --   }
      --   task:start()
      -- end, { nargs = '*', bang = true, bar = true, complete = 'file' })

      vim.api.nvim_create_user_command('Make', function(params)
        -- Insert args at the '$*' in the makeprg
        local cmd, num_subs = vim.o.makeprg:gsub('%$%*', params.args)
        if num_subs == 0 then cmd = cmd .. ' ' .. params.args end
        local task = require('overseer').new_task {
          cmd = vim.fn.expandcmd(cmd),
          components = {
            { 'on_output_quickfix', open = not params.bang, open_height = 8 },
            'unique',
            'default',
          },
        }
        task:start()
      end, {
        desc = 'Run your makeprg as an Overseer task',
        nargs = '*',
        bang = true,
      })

      -- local wk = require('which-key')
      -- wk.register {
      --   ['<localleader>o'] = {
      --     name = '+Overseer',
      --     r = { '<cmd>OverseerRun<CR>', 'Run' },
      --     c = { '<cmd>OverseerRunCmd<CR>', 'Run cmd' },
      --     l = { '<cmd>OverseerLoadBundle<CR>', 'Load Bundle' },
      --     b = { '<cmd>OverseerToggle! bottom<CR>', 'Toggle (btm)' },
      --     d = { '<cmd>OverseerQuickAction<CR>', 'QuickAction' },
      --     s = { '<cmd>OverseerTaskAction<CR>', 'Task Action' },
      --   },
      -- }
    end,
  },
}
