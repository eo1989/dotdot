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
local lua_library_files = vim.api.nvim_get_runtime_file('', true)

if resources then table.insert(lua_library_files, resources .. '/lua-types') end
table.insert(lua_library_files, vim.fn.expand('$VIMRUNTIME/lua'))

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
table.insert(runtime_path, '?.lua')
table.insert(runtime_path, '?/init.lua')
if resources then table.insert(runtime_path, resources .. '/lua-plugin/plugin.lua') end

---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    { '.luarc.json', '.luarc.jsonc', 'stylua.toml', '.stylua.toml' },
    '.git',
  },
  ---@param client vim.lsp.Client
  single_file_support = true,
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false --|> conform stylua
    client.server_capabilities.documentRangeFormattingProvider = false --|> conform stylua
  end,
  on_init = function(client, _)
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
        path = runtime_path,
      },
      codeLens = { enable = true }, -- disable for now
      misc = {},
      hover = { expandAlias = false },
      type = { castNumberToInteger = false },
      hint = {
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
        -- keywordSnippet = 'Disable',
        workspaceWord = true, -- folke -> true
        callSnippet = 'Replace',
        -- showWord = 'Disable',
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        -- ignoreDir = 'tmp/',
        useGitIgnore = false,
        -- maxPreload = 100,000,000,
        maxPreload = 100000000,
        preloadFileSize = 50000,
        checkThirdParty = false,
        library = { lua_library_files },
      },
      telemetry = { enable = false },
    })
  end,
  settings = {
    Lua = {},
  },
}

--   client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua,
--     {
--     runtime = {
--       -- Tell the language server which version of Lua you're using
--       -- (most likely LuaJIT in the case of Neovim)
--       version = 'LuaJIT',
--       path = runtime_path,
--     },
--     codeLens = { enable = true },
--     misc = {},
--     hover = { expandAlias = false },
--     type = { castNumberToInteger = false },
--     hint = {
--       enable = true,
--       await = true,
--       setType = false,
--       -- paramType = true,
--       paramName = 'Disable', -- 'Disable' | 'Literal'
--       semicolon = 'Disable',
--       arrayIndex = 'Disable', -- show hints ('auto') only when table is >3 items, or tbl is mixed; 'Disable'
--     },
--     format = { enable = false },
--     diagnostics = {
--       disable = { 'unused-local', 'trailing-space' },
--       globals = {
--         'quarto',
--         'pandoc',
--         'io',
--         'string',
--         'print',
--         'bit',
--         'require',
--         'table',
--         'eo',
--         'hs',
--         'map',
--         'vim',
--         'P',
--         'describe',
--         'it',
--         'before_each',
--         'after_each',
--         'pending',
--       },
--     },
--     completion = {
--       autoRequire = false,
--       keywordSnippet = 'Disable',
--       workspaceWord = true, -- folke -> true
--       callSnippet = 'Replace',
--       showWord = 'Disable',
--     },
--     -- Make the server aware of Neovim runtime files
--     workspace = {
--       ignoreDir = 'tmp/',
--       useGitIgnore = false,
--       maxPreload = 100000000,
--       preloadFileSize = 50000,
--       checkThirdParty = false,
--       library = lua_library_files,
--     },
--     telemetry = { enable = false },
--   })
