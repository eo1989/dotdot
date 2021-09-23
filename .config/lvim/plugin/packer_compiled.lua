-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/eo/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/eo/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/eo/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/eo/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/eo/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/FixCursorHold.nvim"
  },
  ["JuliaFormatter.vim"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/JuliaFormatter.vim"
  },
  LuaSnip = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/LuaSnip"
  },
  ["any-jump.vim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/any-jump.vim"
  },
  ["barbar.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20core.bufferline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/barbar.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-latex-symbols"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/cmp-path"
  },
  ["cmp-tabnine"] = {
    config = { "\27LJ\2\no\0\0\5\0\4\0\b6\0\0\0'\2\1\0B\0\2\2\18\3\0\0009\1\2\0005\4\3\0B\1\3\1K\0\1\0\1\0\3\14max_lines\3d\tsort\2\20max_num_results\3\n\nsetup\23cmp_tabnine.config\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/cmp-tabnine"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/cmp_luasnip"
  },
  colorschemes = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/colorschemes"
  },
  ["dial.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vconfig\14user.dial\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/dial.nvim"
  },
  ["diffview.nvim"] = {
    commands = { "DiffViewOpen" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/diffview.nvim"
  },
  ["doom-one.nvim"] = {
    config = { '\27LJ\2\në\1\0\0\2\0\5\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0K\0\1\0"doom_one_telescope_highlights\29doom_one_terminal_colors\29doom_one_italic_comments\6g\bvim\0' },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/doom-one.nvim"
  },
  edge = {
    config = { "\27LJ\2\nT\0\0\2\0\5\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0K\0\1\0\23edge_enable_italic\tneon\15edge_style\6g\bvim\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/edge"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/editorconfig-vim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/friendly-snippets"
  },
  fzf = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18core.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/gitsigns.nvim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\n¿\1\0\0\6\0\r\0\0226\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0005\5\t\0B\0\5\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\n\0'\4\v\0005\5\f\0B\0\5\1K\0\1\0\1\0\1\vsilent\2\17:HopWord<cr>\6S\1\0\1\vsilent\2\18:HopChar2<cr>\6s\6n\20nvim_set_keymap\bapi\bvim\nsetup\bhop\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/hop.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20user.indentline\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["julia-vim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/julia-vim"
  },
  ["lightspeed.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/lightspeed.nvim"
  },
  ["lsp-colors.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/lsp-colors.nvim"
  },
  ["lsp_signature.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vconfig\23user.lsp_signature\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/lsp_signature.nvim"
  },
  ["lua-dev.nvim"] = {
    config = { "\27LJ\2\nÑ\1\0\0\4\0\t\0\0186\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\a\0006\3\3\0009\3\4\0039\3\5\0039\3\6\0039\3\2\3=\3\b\2B\0\2\0026\1\3\0009\1\4\0019\1\5\0019\1\6\1=\0\2\1K\0\1\0\14lspconfig\1\0\0\blsp\blua\tlang\tlvim\nsetup\flua-dev\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17core.lualine\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/lualine.nvim"
  },
  ["luv-vimdocs"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/luv-vimdocs"
  },
  ["magma-nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/magma-nvim"
  },
  ["markdown-preview.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0K\0\1\0\20mkdp_auto_close\20mkdp_auto_start\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/markdown-preview.nvim"
  },
  ["material.nvim"] = {
    config = { "\27LJ\2\n•\2\0\0\2\0\n\0\0296\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0006\0\0\0009\0\1\0+\1\2\0=\1\5\0006\0\0\0009\0\1\0+\1\2\0=\1\6\0006\0\0\0009\0\1\0+\1\2\0=\1\a\0006\0\0\0009\0\1\0+\1\2\0=\1\b\0006\0\0\0009\0\1\0+\1\2\0=\1\t\0K\0\1\0\21material_borders\30material_italic_variables\30material_italic_functions\29material_italic_keywords\28material_italic_strings\29material_italic_comments\nocean\19material_style\6g\bvim\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/material.nvim"
  },
  neogit = {
    commands = { "Neogit" },
    config = { "\27LJ\2\nﬂ\1\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\3=\3\v\0025\3\f\0=\3\r\2B\0\2\1K\0\1\0\17integrations\1\0\1\rdiffview\2\nsigns\thunk\1\3\0\0\5\5\titem\1\3\0\0\6+\6-\fsection\1\0\0\1\3\0\0\bÔÉö\bÔÉó\1\0\2!disable_context_highlighting\1\18disable_signs\1\nsetup\vneogit\frequire\0" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/neogit"
  },
  ["nlsp-settings.nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nlsp-settings.nvim"
  },
  ["nlua.nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nlua.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19core.autopairs\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    config = { "\27LJ\2\n∏\3\0\0\6\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\0025\3\b\0=\3\t\0025\3\15\0005\4\v\0005\5\n\0=\5\f\0045\5\r\0=\5\14\4=\4\16\3=\3\17\2B\0\2\1K\0\1\0\vfilter\bfzf\1\0\0\15extra_opts\1\5\0\0\v--bind\22ctrl-o:toggle-all\r--prompt\a> \15action_for\1\0\0\1\0\4\vctrl-x\nsplit\vctrl-v\vvsplit\vctrl-b\15signtoggle\vctrl-t\ftabedit\rfunc_map\1\0\3\vvsplit\5\16ptogglemode\az,\14stoggleup\5\fpreview\17border_chars\1\n\0\0\b‚îÉ\b‚îÉ\b‚îÅ\b‚îÅ\b‚îè\b‚îì\b‚îó\b‚îõ\b‚ñà\1\0\5\16win_vheight\3\f\17delay_syntax\3P\twrap\2\17auto_preview\2\15win_height\3\14\1\0\1\16auto_enable\2\nsetup\bbqf\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-bqf"
  },
  ["nvim-cmp"] = {
    after = { "nvim-autopairs" },
    loaded = true,
    only_config = true
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n]\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\2\tmode\15foreground\bRGB\2\1\2\0\0\6*\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-comment"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17core.comment\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/nvim-comment"
  },
  ["nvim-ipy"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-ipy"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\1\2\0B\1\1\1K\0\1\0\nsetup\20core.lspinstall\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/nvim-lspinstall"
  },
  ["nvim-luadev"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-luadev"
  },
  ["nvim-luapad"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-luapad"
  },
  ["nvim-luaref"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-luaref"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18core.nvimtree\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "nvim-treesitter-textsubjects", "nvim-treesitter-textobjects" },
    loaded = true,
    only_config = true
  },
  ["nvim-treesitter-textobjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["one-nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/one-nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    commands = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/popup.nvim"
  },
  ["project.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17core.project\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/project.nvim"
  },
  sniprun = {
    commands = { "SnipRun" },
    config = { "\27LJ\2\n≥\3\0\0\5\0\16\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0=\4\14\3=\3\15\2B\0\2\1K\0\1\0\18snipruncolors\26SniprunFloatingWinErr\1\0\3\fctermbg\0067\fctermfg\a1*\afg\f#E06C75\25SniprunFloatingWinOk\1\0\3\fctermbg\0067\fctermfg\a4*\afg\f#51AFEF\26SniprunVirtualTextErr\1\0\4\fctermbg\0067\abg\f#3E4556\fctermfg\0061\afg\f#E06C75\25SniprunVirtualTextOk\1\0\0\1\0\4\fctermbg\0067\abg\f#3E4556\fctermfg\0064\afg\f#51AFEF\fdisplay\1\0\0\1\4\0\0\18VirtualTextOk\19VirtualTextErr\27LongTempFloatingWindow\nsetup\fsniprun\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/sniprun"
  },
  sonokai = {
    config = { "\27LJ\2\nÉ\1\0\0\2\0\a\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0K\0\1\0\tblue\19sonokai_cursor\26sonokai_enable_italic\14andromeda\18sonokai_style\6g\bvim\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/sonokai"
  },
  ["sql.nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/sql.nvim"
  },
  ["symbols-outline.nvim"] = {
    commands = { "SymbolsOutline" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/symbols-outline.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/targets.vim"
  },
  ["telescope-cheat.nvim"] = {
    config = { "\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ncheat\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/telescope-cheat.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19core.telescope\frequire\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/todo-comments.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18core.terminal\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/toggleterm.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\n‰\2\0\0\2\0\v\0!6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0+\1\2\0=\1\5\0006\0\0\0009\0\1\0+\1\2\0=\1\6\0006\0\0\0009\0\1\0+\1\2\0=\1\a\0006\0\0\0009\0\1\0+\1\2\0=\1\b\0006\0\0\0009\0\1\0+\1\2\0=\1\t\0006\0\0\0009\0\1\0+\1\2\0=\1\n\0K\0\1\0\31tokyonight_terminal_colors\31tokyonight_italic_comments\31tokyonight_italic_keywords tokyonight_italic_functions tokyonight_italic_variables(tokyonight_hide_inactive_statusline\nstorm\21tokyonight_style\19tokyonight_dev\6g\bvim\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "Trouble" },
    config = { "\27LJ\2\nV\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\15auto_close\2\17auto_preview\2\nsetup\ftrouble\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/trouble.nvim"
  },
  undotree = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/undotree"
  },
  ["unicode.vim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/unicode.vim"
  },
  ["vim-apathy"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-apathy"
  },
  ["vim-characterize"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-characterize"
  },
  ["vim-devdocs"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-devdocs"
  },
  ["vim-easy-align"] = {
    keys = { { "", "<Plug>(EasyAlign)" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-easy-align"
  },
  ["vim-log-highlighting"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-log-highlighting"
  },
  ["vim-markdown"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-markdown"
  },
  ["vim-matchup"] = {
    after_files = { "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    config = { "\27LJ\2\nñ\1\0\0\2\0\5\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0005\1\4\0=\1\3\0K\0\1\0\1\0\3\vmethod\npopup\14fullwidth\2\14highlight\vNormal!matchup_matchparen_offscreen matchup_matchparen_deferred\6g\bvim\0" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-matchup"
  },
  ["vim-operator-user"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-operator-user"
  },
  ["vim-python-pep8-indent"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-python-pep8-indent"
  },
  ["vim-scriptease"] = {
    commands = { "Messages", "Verbose", "Time", "ScriptNames" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-scriptease"
  },
  ["vim-smoothie"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-smoothie"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-surround"
  },
  ["vim-textobj-comment"] = {
    config = { "\27LJ\2\n©\2\0\0\3\0\5\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\3\0'\2\4\0B\0\2\1K\0\1\0œ\1              xmap ax <Plug>(textobj-comment-a)\n              omap ax <Plug>(textobj-comment-a)\n              xmap ix <Plug>(textobj-comment-i)\n              omap ix <Plug>(textobj-comment-i)\n          \bcmd,textobj_comment_no_default_key_mappings\6g\bvim\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-textobj-comment"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-textobj-user"
  },
  ["vim-tmux-navigator"] = {
    config = { "\27LJ\2\nÑ\3\0\0\3\0\a\0\0176\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\2\0=\1\4\0006\0\0\0009\0\5\0'\2\6\0B\0\2\1K\0\1\0÷\1          nnoremap <c-h> <cmd>TmuxNavigateLeft<cr>\n          nnoremap <c-j> <cmd>TmuxNavigateDown<cr>\n          nnoremap <c-k> <cmd>TmuxNavigateUp<cr>\n          nnoremap <c-l> <cmd>TmuxNavigateRight<cr>\n      \bcmd\"tmux_navigator_save_on_switch'tmux_navigator_disable_when_zoomed\31tmux_navigator_no_mappings\6g\bvim\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vim-wordmotion"] = {
    config = { "\27LJ\2\nn\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0O      nmap dw de\n      nmap cw ce\n      nmap dW dE\n      nmap cW cE\n      \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/vim-wordmotion"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19core.which-key\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/opt/which-key.nvim"
  },
  ["zephyr-nvim"] = {
    loaded = true,
    path = "/Users/eo/.local/share/lunarvim/site/pack/packer/start/zephyr-nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-easy-align
time([[Setup for vim-easy-align]], true)
try_loadstring("\27LJ\2\n⁄\1\0\0\6\0\v\0\0256\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\a\0'\3\4\0'\4\5\0005\5\b\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\t\0'\3\4\0'\4\5\0005\5\n\0B\0\5\1K\0\1\0\1\0\2\fnoremap\1\vsilent\2\6v\1\0\2\fnoremap\1\vsilent\2\6o\1\0\2\fnoremap\1\vsilent\2\22<Plug>(EasyAlign)\aga\6x\20nvim_set_keymap\bapi\bvim\0", "setup", "vim-easy-align")
time([[Setup for vim-easy-align]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18core.nvimtree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-bqf
time([[Config for nvim-bqf]], true)
try_loadstring("\27LJ\2\n∏\3\0\0\6\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\0025\3\b\0=\3\t\0025\3\15\0005\4\v\0005\5\n\0=\5\f\0045\5\r\0=\5\14\4=\4\16\3=\3\17\2B\0\2\1K\0\1\0\vfilter\bfzf\1\0\0\15extra_opts\1\5\0\0\v--bind\22ctrl-o:toggle-all\r--prompt\a> \15action_for\1\0\0\1\0\4\vctrl-x\nsplit\vctrl-v\vvsplit\vctrl-b\15signtoggle\vctrl-t\ftabedit\rfunc_map\1\0\3\vvsplit\5\16ptogglemode\az,\14stoggleup\5\fpreview\17border_chars\1\n\0\0\b‚îÉ\b‚îÉ\b‚îÅ\b‚îÅ\b‚îè\b‚îì\b‚îó\b‚îõ\b‚ñà\1\0\5\16win_vheight\3\f\17delay_syntax\3P\twrap\2\17auto_preview\2\15win_height\3\14\1\0\1\16auto_enable\2\nsetup\bbqf\frequire\0", "config", "nvim-bqf")
time([[Config for nvim-bqf]], false)
-- Config for: edge
time([[Config for edge]], true)
try_loadstring("\27LJ\2\nT\0\0\2\0\5\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0K\0\1\0\23edge_enable_italic\tneon\15edge_style\6g\bvim\0", "config", "edge")
time([[Config for edge]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n]\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\2\tmode\15foreground\bRGB\2\1\2\0\0\6*\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20core.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17core.project\frequire\0", "config", "project.nvim")
time([[Config for project.nvim]], false)
-- Config for: cmp-tabnine
time([[Config for cmp-tabnine]], true)
try_loadstring("\27LJ\2\no\0\0\5\0\4\0\b6\0\0\0'\2\1\0B\0\2\2\18\3\0\0009\1\2\0005\4\3\0B\1\3\1K\0\1\0\1\0\3\14max_lines\3d\tsort\2\20max_num_results\3\n\nsetup\23cmp_tabnine.config\frequire\0", "config", "cmp-tabnine")
time([[Config for cmp-tabnine]], false)
-- Config for: vim-wordmotion
time([[Config for vim-wordmotion]], true)
try_loadstring("\27LJ\2\nn\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0O      nmap dw de\n      nmap cw ce\n      nmap dW dE\n      nmap cW cE\n      \bcmd\bvim\0", "config", "vim-wordmotion")
time([[Config for vim-wordmotion]], false)
-- Config for: sonokai
time([[Config for sonokai]], true)
try_loadstring("\27LJ\2\nÉ\1\0\0\2\0\a\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0K\0\1\0\tblue\19sonokai_cursor\26sonokai_enable_italic\14andromeda\18sonokai_style\6g\bvim\0", "config", "sonokai")
time([[Config for sonokai]], false)
-- Config for: lua-dev.nvim
time([[Config for lua-dev.nvim]], true)
try_loadstring("\27LJ\2\nÑ\1\0\0\4\0\t\0\0186\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\a\0006\3\3\0009\3\4\0039\3\5\0039\3\6\0039\3\2\3=\3\b\2B\0\2\0026\1\3\0009\1\4\0019\1\5\0019\1\6\1=\0\2\1K\0\1\0\14lspconfig\1\0\0\blsp\blua\tlang\tlvim\nsetup\flua-dev\frequire\0", "config", "lua-dev.nvim")
time([[Config for lua-dev.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rcore.cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17core.lualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: doom-one.nvim
time([[Config for doom-one.nvim]], true)
try_loadstring('\27LJ\2\në\1\0\0\2\0\5\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0K\0\1\0"doom_one_telescope_highlights\29doom_one_terminal_colors\29doom_one_italic_comments\6g\bvim\0', "config", "doom-one.nvim")
time([[Config for doom-one.nvim]], false)
-- Config for: telescope-cheat.nvim
time([[Config for telescope-cheat.nvim]], true)
try_loadstring("\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ncheat\19load_extension\14telescope\frequire\0", "config", "telescope-cheat.nvim")
time([[Config for telescope-cheat.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19core.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: material.nvim
time([[Config for material.nvim]], true)
try_loadstring("\27LJ\2\n•\2\0\0\2\0\n\0\0296\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0006\0\0\0009\0\1\0+\1\2\0=\1\5\0006\0\0\0009\0\1\0+\1\2\0=\1\6\0006\0\0\0009\0\1\0+\1\2\0=\1\a\0006\0\0\0009\0\1\0+\1\2\0=\1\b\0006\0\0\0009\0\1\0+\1\2\0=\1\t\0K\0\1\0\21material_borders\30material_italic_variables\30material_italic_functions\29material_italic_keywords\28material_italic_strings\29material_italic_comments\nocean\19material_style\6g\bvim\0", "config", "material.nvim")
time([[Config for material.nvim]], false)
-- Config for: vim-tmux-navigator
time([[Config for vim-tmux-navigator]], true)
try_loadstring("\27LJ\2\nÑ\3\0\0\3\0\a\0\0176\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\2\0=\1\4\0006\0\0\0009\0\5\0'\2\6\0B\0\2\1K\0\1\0÷\1          nnoremap <c-h> <cmd>TmuxNavigateLeft<cr>\n          nnoremap <c-j> <cmd>TmuxNavigateDown<cr>\n          nnoremap <c-k> <cmd>TmuxNavigateUp<cr>\n          nnoremap <c-l> <cmd>TmuxNavigateRight<cr>\n      \bcmd\"tmux_navigator_save_on_switch'tmux_navigator_disable_when_zoomed\31tmux_navigator_no_mappings\6g\bvim\0", "config", "vim-tmux-navigator")
time([[Config for vim-tmux-navigator]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20user.indentline\frequire\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: vim-textobj-comment
time([[Config for vim-textobj-comment]], true)
try_loadstring("\27LJ\2\n©\2\0\0\3\0\5\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\3\0'\2\4\0B\0\2\1K\0\1\0œ\1              xmap ax <Plug>(textobj-comment-a)\n              omap ax <Plug>(textobj-comment-a)\n              xmap ix <Plug>(textobj-comment-i)\n              omap ix <Plug>(textobj-comment-i)\n          \bcmd,textobj_comment_no_default_key_mappings\6g\bvim\0", "config", "vim-textobj-comment")
time([[Config for vim-textobj-comment]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\n‰\2\0\0\2\0\v\0!6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0+\1\2\0=\1\5\0006\0\0\0009\0\1\0+\1\2\0=\1\6\0006\0\0\0009\0\1\0+\1\2\0=\1\a\0006\0\0\0009\0\1\0+\1\2\0=\1\b\0006\0\0\0009\0\1\0+\1\2\0=\1\t\0006\0\0\0009\0\1\0+\1\2\0=\1\n\0K\0\1\0\31tokyonight_terminal_colors\31tokyonight_italic_comments\31tokyonight_italic_keywords tokyonight_italic_functions tokyonight_italic_variables(tokyonight_hide_inactive_statusline\nstorm\21tokyonight_style\19tokyonight_dev\6g\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-treesitter-textsubjects ]]
vim.cmd [[ packadd nvim-treesitter-textobjects ]]
time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Time lua require("packer.load")({'vim-scriptease'}, { cmd = "Time", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SymbolsOutline lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutline", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiffViewOpen lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffViewOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neogit lua require("packer.load")({'neogit'}, { cmd = "Neogit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Trouble lua require("packer.load")({'trouble.nvim'}, { cmd = "Trouble", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ScriptNames lua require("packer.load")({'vim-scriptease'}, { cmd = "ScriptNames", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SnipRun lua require("packer.load")({'sniprun'}, { cmd = "SnipRun", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSHighlightCapturesUnderCursor lua require("packer.load")({'playground'}, { cmd = "TSHighlightCapturesUnderCursor", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Messages lua require("packer.load")({'vim-scriptease'}, { cmd = "Messages", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <Plug>(EasyAlign) <cmd>lua require("packer.load")({'vim-easy-align'}, { keys = "<lt>Plug>(EasyAlign)", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType go ++once lua require("packer.load")({'vim-apathy'}, { ft = "go" }, _G.packer_plugins)]]
vim.cmd [[au FileType yaml ++once lua require("packer.load")({'vim-apathy'}, { ft = "yaml" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim', 'vim-markdown'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType bash ++once lua require("packer.load")({'vim-apathy'}, { ft = "bash" }, _G.packer_plugins)]]
vim.cmd [[au FileType toml ++once lua require("packer.load")({'vim-apathy'}, { ft = "toml" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'vim-apathy'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'vim-apathy', 'vim-python-pep8-indent'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType julia ++once lua require("packer.load")({'vim-apathy', 'JuliaFormatter.vim'}, { ft = "julia" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'nvim-lspinstall'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufWinEnter * ++once lua require("packer.load")({'toggleterm.nvim', 'barbar.nvim', 'which-key.nvim'}, { event = "BufWinEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'hop.nvim', 'lightspeed.nvim', 'lsp-colors.nvim', 'nvim-comment', 'todo-comments.nvim', 'dial.nvim', 'gitsigns.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au CursorMoved * ++once lua require("packer.load")({'vim-matchup'}, { event = "CursorMoved *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'lsp_signature.nvim'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], true)
vim.cmd [[source /Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]]
time([[Sourcing ftdetect script at: /Users/eo/.local/share/lunarvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
