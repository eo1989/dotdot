if not vim.g.vscode then return end
local vscode = require('vscode')
local map = function(...) vim.keymap.set(...) end

vim.notify = vscode.notify
vim.g.clipboard = vim.g.vscode_clipboard

vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undolevels = 10000
vim.opt.virtualedit = 'block'
vim.opt.woldmode = 'longest:full,full'
vim.opt.scrolloff = 5

local function vscode_action(cmd)
  return function() vscode.action(cmd) end
end

map('n', '<leader>qq', '<cmd>Tabclose<CR>')
map('n', '<]space>', "<cmd>put =repeat(nr2char(10), v:count1) <Bar> '[-1<CR>")
map('n', '<[space>', "<cmd>put =repeat(nr2char(10), v:count1) <Bar> ']+1<CR>")
map('n', '<localleader>l', '<cmd>nohlsearch<CR>')
map('n', '<tab>', vscode_action('workbench.action.nextEditor'))
map('n', '<S-tab>', vscode_action('workbench.action.previousEditor'))
map({ 'n', 'x' }, '<C-h>', vscode_action('workbench.action.navigateLeft'))
map({ 'n', 'x' }, '<C-j>', vscode_action('workbench.action.navigateDown'))
map({ 'n', 'x' }, '<C-k>', vscode_action('workbench.action.navigateUp'))
map({ 'n', 'x' }, '<C-l>', vscode_action('workbench.action.navigateRight'))
map('n', '[d', vscode_action('workbench.action.marker.prev'))
map('n', ']d', vscode_action('workbench.action.marker.next'))
map('n', '<leader>fo', vscode_action('workbench.action.showAllEditors'))
map('n', '<leader>ff', vscode_action('workbench.action.quickOpen'))
map('n', '<leader>ca', vscode_action('editor.action.quickFix'))
map('n', '<leader>rn', vscode_action('editor.action.rename'))
map('n', '<leader>rf', vscode_action('editor.action.formatDocument'))
map('v', '<leader>rf', vscode_action('editor.action.formatSelection'))
map('n', 'gr', vscode_action('editor.action.goToReferences'))
map({ 'n', 'v' }, '<leader>and', vscode_action('notifications.clearAll'))
map({ 'n', 'x', 'i' }, '<D-d>', function()
  vscode.with_insert(function() vscode_action('editor.action.addSelectionToNextFindMatch') end)
end)

-- Plugins
-- map('n', '<localleader>gs', vscode_action('magit.status'))

map({ 'n', 'x' }, 'j', 'v:count == 0 ? "gj", "j"', { expr = true, silent = true })
map({ 'n', 'x' }, 'k', 'v:count == 0 ? "gk", "k"', { expr = true, silent = true })

map('n', '<leader>nf', vscode_action('workbench.action.files.newUntitledFile'), { desc = 'New file' })
map('n', '<leader>ff', vscode_action('workbench.action.quickOpen'), { desc = 'Open file finder' })
map('n', '<leader>fs', vscode_action('workbench.action.findInFiles'), { desc = 'Search in files' })
map('n', '[h', vscode_action('workbench.action.editor.previousChange'), { desc = 'Previous Change' })
map('n', ']h', vscode_action('workbench.action.editor.nextChange'), { desc = 'Next Change' })

local manageEditorSize = function(...)
  local count = select(1, ...)
  local to = select(2, ...)
  for i = 1, (count and count > 0 and count or 1) do
    vscode.call(to == 'increase' and 'workbench.action.increaseViewSize' or 'workbench.action.decreaseViewSize')
  end
end

--[[ these keys represent alt left and right ]]
map('n', '¬', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('n', '˙', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })

map('n', '<C-w>>', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('x', '<C-w>>', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('n', '<C-w>+', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('x', '<C-w>+', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('n', '<C-w><', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })
map('x', '<C-w><', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })
map('n', '<C-w>-', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })
map('x', '<C-w>-', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })

--[[
-- following is from github.com/echasnovski/nvim/blob/master/plugin/13_vscode.lua
-- gh repo clone echasnovski/nvim
--]]

-- unsure if these will be needed since 'gc' is already mapped in vscode to comment things out
map({ 'n', 'x', 'o' }, 'gc', '<Plug>VSCodeCommentary')
map('n', 'gcc', '<Plug>VSCodeCommentaryLine')

map('n', ']b', '<Cmd>Tabnext<CR>')
map('n', '[b', '<Cmd>Tabprev<CR>')

-- workaround for executing visual selection in VSCode (example: in python interactive window)
local vscode_execute_line_or_selection = function(cur_mode, vscode_command)
  local visual_mode
  if cur_mode == 'normal' then
    -- visually select current line
    vim.cmd('normal! V')
    visual_mode = 'v'
  else
    -- guess is that this is probably needed because visual selection is 'reset' before function is
    -- called
    vim.cmd('normal! gv')
    visual_mode = vim.fn.visualmode()
  end

  if visual_mode == 'V' then
    vim.fn.VSCodeNotifyRange(vscode_command, vim.fn.line('v'), vim.fn.line('.'), 1)
  else
    local start_pos, end_pos = vim.fn.getpos([['<]]), vim.fn.getpos([['>]])
    -- `getpos()` returns `{bufnum, lnum, col, off}`, only 2 and 3 are needed
    vim.fn.VSCodeNotifyRangePos(vscode_command, start_pos[2], end_pos[3], start_pos[3], end_pos[3] + 1, 1)
  end

  -- Wait some time because otherwise following commands, when working
  -- remotely, seem to be executed before sending range to remote computer
  -- which upon delivery will execute the wrong range (usually a single line
  -- after desired selection)
  -- vim.loop.sleep(100)

  -- Escape to normal mode and move past selection (depending on submode)
  local finish_cmd = 'normal! \27' .. (visual_mode == 'v' and '`>l' or "'>j")
  vim.cmd(finish_cmd)
end

-- 'Send to Jupyter'
local map_send = function(mode, lhs, cur_mode, vscode_command)
  local rhs = string.format([[:<C-u>lua vscode_execute_line_or_selection('%s', '%s')<CR>]], cur_mode, vscode_command)
  map(mode, lhs, rhs, { silent = true })
end

map_send('n', '<leader>j', 'normal', 'jupyter.execSelectionInteractive')
map_send('x', '<leader>j', 'visual', 'jupyter.execSelectionInteractive')

-- map_send('x', '<leader>r', 'visual', 'r.runSelection')
-- map('n', '<leader>r', [[:<C-u>call VSCodeCall('r.runSelection')<CR>]])
