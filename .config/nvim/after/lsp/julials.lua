---eo -- taken straight from nvim-lspconfig .. bruh. dead.
---@brief
---
--- https://github.com/julia-vscode/julia-vscode
---
--- LanguageServer.jl can be installed with `julia` and `Pkg`:
--- ```sh
--- julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
--- ```
--- where `~/.julia/environments/nvim-lspconfig` is the location where
--- the default configuration expects LanguageServer.jl to be installed.
---
--- To update an existing install, use the following command:
--- ```sh
--- julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.update()'
--- ```
---
--- Note: In order to have LanguageServer.jl pick up installed packages or dependencies in a
--- Julia project, you must make sure that the project is instantiated:
--- ```sh
--- julia --project=/path/to/my/project -e 'using Pkg; Pkg.instantiate()'
--- ```
---
--- Note: The julia programming language searches for global environments within the `environments/`
--- folder of `$JULIA_DEPOT_PATH` entries. By default this simply `~/.julia/environments`

-- local root_files = { { 'Project.toml', 'JuliaProject.toml' }, '.git', '.JuliaFormatter.toml' }
-- local root_files = { { 'Project.toml', '.JuliaFormatter.toml' }, '.git' }

-- local function activate_env(path)
--   assert(vim.fn.has('nvim-0.10') == 1, 'requires Nvim 0.10 or newer')
--   local bufnr = vim.api.nvim_get_current_buf(0)
--   local julials_clients = vim.lsp.get_clients { bufnr = bufnr, name = 'julials' }
--   assert(
--     #julials_clients > 0,
--     'method julia/activateenvironment is not supported by any servers active on the current buffer'
--   )
--   local function _activate_env(environment)
--     if environment then
--       for _, julials_client in ipairs(julials_clients) do
--         julials_client:notify('julia/activateenvironment', { envPath = environment })
--       end
--       vim.notify('Julia environment activated: \n`' .. environment .. '`', vim.log.levels.INFO)
--     end
--   end
--   if path then
--     path = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(path), ':p'))
--     local found_env = false
--     for _, project_file in ipairs(root_files) do
--       local file = vim.uv.fs_stat(vim.fs.joinpath(path, project_file))
--       if file and file.type then
--         found_env = true
--         break
--       end
--     end
--     if not found_env then
--       vim.notify('Path is not a julia environment: \n`' .. path .. '`', vim.log.levels.WARN)
--       return
--     end
--     _activate_env(path)
--   else
--     local depot_paths = vim.env.JULIA_DEPOT_PATH
--         and vim.split(vim.env.JULIA_DEPOT_PATH, vim.fn.has('win32') == 1 and ';' or ':')
--       or { vim.fn.expand('~/.julia') }
--     local environments = {}
--     vim.list_extend(environments, vim.fs.find(root_files, { type = 'file', upward = true, limit = math.huge }))
--     for _, depot_path in ipairs(depot_paths) do
--       local depot_env = vim.fs.joinpath(vim.fs.normalize(depot_path), 'environments')
--       vim.list_extend(
--         environments,
--         vim.fs.find(
--           function(name, env_path)
--             return vim.tbl_contains(root_files, name) and string.sub(env_path, #depot_env + 1):match('^/[^/]*$')
--           end,
--           { path = depot_env, type = 'file', limit = math.huge }
--         )
--       )
--     end
--     environments = vim.tbl_map(vim.fs.dirname, environments)
--     vim.ui.select(environments, { prompt = 'Select a Julia environment' }, _activate_env)
--   end
-- end

--[[
  Load LanguageServer.jl: attempt to load from ~/.julia/environments/nvim-lspconfig with the 
  regular load path as a fallback

     # 1. Finds an explicitly set project (JULIA_PROJECT)
     # 2. Look for a Project.toml file in the current working directory,
     #    or parent directories, with $HOME as an upper boundary

     # 3. First entry in the load path
     # 4. Fallback to default global environment, this is more or less unreachable
--]]

-- local _cmd = {
--   'julia',
--   '--startup-file=no',
--   '--history-file=no',
--   '-e',
--   [[
--     ls_install_path = joinpath(
--         get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")),
--         "environments", "nvim-lspconfig"
--     )
--     pushfirst!(LOAD_PATH, ls_install_path)
--     using LanguageServer
--     popfirst!(LOAD_PATH)
--     depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
--     project_path = let
--         dirname(something(
--             Base.load_path_expand((
--                 p = get(ENV, "JULIA_PROJECT", nothing);
--                 p === nothing ? nothing : isempty(p) ? nothing : p
--             )),
--             Base.current_project(),
--             get(Base.load_path(), 1, nothing),
--             Base.load_path_expand("@v#.#"),
--         ))
--     end
--     @info "Running language server" VERSION pwd() project_path depot_path
--     server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
--     server.runlinter = true
--     run(server)
--   ]],
-- }

-- local _new_config = vim.lsp.config.julials or {}

---@type vim.lsp.Config
return {
  ---@param client vim.lsp.Client
  -- cmd = _cmd,
  -- filetypes = { 'julia' },
  single_file_support = true,
  -- root_markers = {
  --   { 'Project.toml' },
  --   '.JuliaFormatter.toml',
  --   '.git',
  -- },
  on_new_config = function(_, _) end,
  -- on_new_config = function(_new_config, _)
  --   local cmd = _new_config.cmd
  --   local julia = vim.fn.expand('~/.julia/environments/nvim-lspconfig/bin/julia')
  --   local REVISE_LANGUAGESERVER = false
  --   if REVISE_LANGUAGESERVER then
  --     cmd[5] = (cmd[5]):gsub(
  --       'using LanguageServer',
  --       'using Revise; using LanguageServer; LanguageServer.USE_REVISE[] = true'
  --     )
  --   elseif require('lspconfig.util').path.is_file(julia) then
  --     if _new_config then
  --       _new_config.cmd[1] = julia
  --     else
  --       cmd[1] = julia
  --     end
  --   end
  -- end,
  -- on_attach = function(client)
  --   vim.api.nvim_buf_create_user_command(0, 'LspJuliaActivateEnv', activate_env, {
  --     desc = 'Activate a Julia environment',
  --     nargs = '?',
  --     complete = 'file',
  --   })
  --
  --   -- vim.bo[bufnr].formatexpr = ''
  --   -- if client.server_capabilities then
  --   client.server_capabilities.documentFormattingProvider = true
  --   client.server_capabilities.documentRangeFormattingProvider = true
  --   -- end
  -- end,
  settings = {
    enableTelemetry = false,
    julia = {
      symbolCacheDownload = true,
      enableTelemetry = false,
      -- completionmode = 'qualify',
      single_file_support = true,
      useRevise = true,
      format = { indent = 4 },
      lsp = {
        autoStart = true,
        provideFormatter = true,
      },
      lint = {
        missingrefs = 'none', -- 'none' | 'all'
        NumThreads = 8,
        iter = true,
        lazy = true,
        modname = true,
      },
      inlayHints = {
        runtime = { enabled = true },
        static = {
          {
            enabled = true,
            variableTypes = { enabled = true },
          },
        },
      },
    },
  },
}
