local M = {}

M.config = function()
  local status_ok, bqf = pcall(require, "bqf")
  if not status_ok then
    return
  end

  bqf.setup{
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      auto_preview = true,
      should_preview_cb = function(bufnr)
        local ret = true
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(filename)
        -- file size > 10k can't be previewed automatically
        if fsize > 100 * 1024 then
          ret = false
        end
        return ret
      end,
      win_height = 12,
      win_vheight = 14,
      delay_syntax = 30,
      border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
      wrap = true,
    },
    func_map = {
      tab = "st",
      split = "sg",
      vsplit = "sv",

      stoggleup = "K",
      stoggledown = "J",
      stogglevm = "<Space>",

      ptoggleitem = "p",
      ptoggleauto = "P",
      ptogglemode = "z,",

      pscrollup = "<C-b>",
      pscrolldown = "<C-f>",

      prevfile = "gk",
      nextfile = "gj",

      prevhist = "<S-Tab>",
      nexthist = "<Tab>",
      -- vsplit = "",
      -- ptogglemode = "z,",
      -- stoggleup = "",
    },
    filter = {
      fzf = {
        action_for = {
          ["ctrl-t"] = "tabedit",
          ["ctrl-x"] = "split",
          ["ctrl-v"] = "vsplit",
          ["ctrl-s"] = "signtoggle",
        },
        extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
      },
    },
  }
end

return M
