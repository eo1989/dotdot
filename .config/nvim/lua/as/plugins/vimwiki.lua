local M = {}

function M.setup()
  local fn = vim.fn
  local sync_dir = fn.expand '$SYNC_DIR'
  local has_sync = fn.isdirectory(sync_dir) > 0
  local home = vim.env.HOME

  vim.g.wiki_path = has_sync and sync_dir .. '/wiki' or home .. '/wiki'
  vim.g.vimwiki_auto_chdir = 1
  vim.g.vimwiki_tags_header = 'Wiki tags'
  vim.g.vimwiki_auto_header = 1
  vim.g.vimwiki_hl_headers = 1 --too colourful
  vim.g.vimwiki_conceal_pre = 1
  vim.g.vimwiki_hl_cb_checked = 1
  vim.g.vimwiki_list = { vim.g.wiki, vim.g.learnings_wiki, vim.g.system_wiki }

  vim.g.vimwiki_global_ext = 0
  vim.g.vimwiki_folding = 'expr'
end

function M.config()
  as.command('CloseVimWikis', function()
    local bufs = vim.fn.getbufinfo { buflisted = true }
    for _, buf in ipairs(bufs) do
      if vim.bo[buf.bufnr].filetype == 'vimwiki' then
        vim.api.nvim_buf_delete(buf.bufnr, { force = true })
      end
    end
  end)

  require('which-key').register({
    w = {
      name = '+wiki',
      [','] = {
        name = '+diary',
        i = 'generate diary links',
        m = "edit tomorrow's diary entry",
        t = 'edit diary entry (tab)',
        y = "edit yesterday's diary entry",
        w = "edit today's diary entry",
      },
      q = { '<Cmd>CloseVimWikis<CR>', 'close all wikis' },
      w = 'open vimwiki index',
      s = 'vimwiki UI select',
      t = 'open vimwiki index in a tab',
      i = 'open vimwiki diary',
    },
  }, {
    prefix = '<leader>',
  })
end

return M
