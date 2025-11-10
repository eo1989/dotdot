local function strsplit(s, delim)
  local result = {}
  for match in (s .. delim):gmatch('(.-)' .. delim) do
    table.insert(result, match)
  end
  return result
end

local function get_qmd_resource()
  local f = assert(io.popen('quarto --paths', 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return strsplit(s, '\n')[2]
end

local resources = get_qmd_resource()
local lua_libs = vim.api.nvim_get_runtime_file('', true) -- and vim.env.VIMRUNTIME .. '/lua' or vim.env.VIMRUNTIME

table.insert(lua_libs, resources .. '/lua-types')
table.insert(lua_libs, vim.fn.expand('$VIMRUNTIME/lua'))

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
table.insert(runtime_path, '?.lua')
table.insert(runtime_path, '?/init.lua')

local lua_plugs = {}

if resources == nil then
  vim.notify_once('quarto not found, lua libs not loaded')
else
  table.insert(runtime_path, resources .. '?/init.lua')
  table.insert(runtime_path, resources .. 'lua-plugin/plugin.lua')
end

local function get_quarto_resource_path()
  local function strsplt(s, delim)
    local result = {}
    for match in (s .. delim):gmatch('(.-)' .. delim) do
      table.insert(result, match)
    end
    return result
  end

  local f = assert(io.popen('quarto --paths', 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return strsplt(s, '\n')[2]
end
local lua_lib_files = vim.api.nvim_get_runtime_file('', true)
local lua_plugin_paths = {}
local resource_path = get_quarto_resource_path()
if resource_path == nil then
  vim.notify_once('quarto not found, lua libs not loaded')
else
  table.insert(lua_lib_files, resource_path .. '/lua-types')
  table.insert(lua_plugin_paths, resource_path .. '/lua-plugin/plugin.lua')
end

---@type vim.lsp.Config
return {
  ---@param client vim.lsp.Client
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml' },
    'selene.toml',
    'selene.yml',
    '.git',
  },
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false --|> conform stylua
    client.server_capabilities.documentRangeFormattingProvider = false --|> conform stylua
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      codeLens = { enable = true },
      misc = {},
      hover = { expandAlias = false },
      type = { castNumberToInteger = false },
      hint = vim.fn.has('nvim-0.10') > 0 and {
        enable = true,
        await = true,
        setType = false,
        -- paramType = true,
        paramName = 'Disable', -- 'Disable' | 'Literal'
        semicolon = 'Disable',
        arrayIndex = 'Disable', -- show hints ('auto') only when table is >3 items, or tbl is mixed; 'Disable'
      },
      format = { enable = false },
      diagnostics = {
        disable = { 'unused-local', 'trailing-space' },
        globals = {
          'quarto',
          'pandoc',
          'io',
          'string',
          'print',
          'bit',
          'require',
          'table',
          'eo',
          'hs',
          'map',
          'vim',
          'P',
          'describe',
          'it',
          'before_each',
          'after_each',
          'pending',
        },
      },
      completion = {
        autoRequire = false,
        keywordSnippet = 'Disable',
        workspaceWord = true, -- folke -> true
        callSnippet = 'Replace',
        showWord = 'Disable',
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        maxPreload = 100000,
        preloadFileSize = 50000,
        checkThirdParty = false,
        -- [[ looks like lazydev shall work? ]]
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)

        -- library = {
        --   vim.env.VIMRUNTIME,
        --   -- Depending on the usage, you might want to add additional paths here.
        --   -- "${3rd}/luv/library"
        --   -- "${3rd}/busted/library",
        -- },
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
      telemetry = { enable = false },
    })
  end,
  settings = { Lua = {} },
}
