--[[
 modfified from https://github.com/dsully/nvim/blob/main/lua/lib/root.lua who modified it from LazyVim
]]

---@class lib.root
---@overload fun(): string
---@return string[]
local M = setmetatable({}, {
  __call = function(m, ...) return m.get(...) end,
})

---@class Root
---@field paths string[]
---@field spec RootSpec

---@alias RootFn fun(buf: number): (string|string[])

---@alias RootSpec string|string[]|RootFn

---@type RootSpec[]
M.spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

M.detectors = {}

---@return string[]
function M.detectors.cwd() return { vim.uv.cwd() } end

---@param buf integer
---@return string[]
function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)

  if not bufpath then return {} end

  ---@type string[]
  local roots = {}
  local clients = vim.lsp.get_clients { bufnr = buf }

  clients = vim.tbl_filter(function(client)
    -- return not vim.tbl_contains(vim.g.root_lsp_ignore or {}, client.name)
    return not vim.tbl_contains(defaults.ignored.lsp, client.name)
  end, clients)

  for _, client in pairs(clients) do
    local workspace = client.config.workspace_folders

    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_from_fname(ws.uri)
    end

    if client.root_dir then roots[#roots + 1] = client.root_dir end
  end

  return vim.tbl_filter(function(path)
    -- path = Root.norm(path)
    path = vim.fs.normalize(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == 'string' and { patterns } or patterns
  local path = M.bufpath(buf) or vim.uv.cwd()
  local pattern = vim.fs.find(function(name)
    for _, p in ipairs(patterns) do
      if name == p then return true end
      if p:sub(1, 1) == '*' and name:find(vim.pesc(p:sub(2)) .. '$') then return true end
    end
    return false
  end, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.bufpath(buf) return M.realpath(vim.api.nvim_buf_get_name(assert(buf))) end

function M.cwd() return M.realpath(vim.uv.cwd()) or '' end

function M.realpath(path)
  if path == '' or path == nil then return nil end
  path = vim.uv.fs_realpath(path) or path
  return Root.norm(path)
end

---@param spec RootSpec
---@return RootFn
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == 'function' then
    return spec
  end
  return function(buf) return M.detectors.pattern(buf, spec) end
end

---@param opts? { buf?: number , spec?: RootSpec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.root_spec) == 'table' and vim.g.root_spec or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  local ret = {} ---@type Root[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == 'table' and paths or { paths }
    local roots = {} ---@type string{}
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then roots[#roots + 1] = pp end
    end
    table.insert(roots, function(a, b) return #a > #b end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then break end
    end
  end
  return ret
end

function M.info()
  local spec = type(vim.g.root_spec) == 'table' and vim.g.root_spec or M.spec

  local roots = M.detect { all = true }
  local lines = {} ---@type string[]
  local first = true
  for _, root in ipairs(roots) do
    for _, path in ipairs(root.paths) do
      lines[#lines + 1] = ('- [%s] `%s` **[%s]**'):format(
        first and 'x' or ' ',
        path,
        type(root.spec) == 'table' and table.concat(root.spec, ', ') or root.spec
      )
      first = false
    end
  end
  lines[#lines + 1] = '```lua'
  lines[#lines + 1] = 'vim.g.root_spec = ' .. vim.inspect(spec)
  lines[#lines + 1] = '```'
  Root.info(lines, { title = 'Roots' })
  return roots[1] and roots[1].paths[1] or vim.uv.cwd()
end

---@type table<number, string>
M.cache = {}

function M.setup()
  vim.api.nvim_create_user_command('Root', function() M.info() end, { desc = 'Roots for the current buffer' })
  vim.api.nvim_create_autocmd({ 'LspAttach', 'BufWritePost', 'DirChanged', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('root_cache', { clear = true }),
    callback = function(event) M.cache[event.buf] = nil end,
  })
end

---@param opts? {normalize?: boolean, buf?: number}
---@return string
function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local roots = M.detect { all = false, buf = buf }
    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
    M.cache[buf] = ret
  end
  if opts and opts.normalize then return ret end
  return M.is_win() and ret:gsub('/', '\\') or ret
end

function M.is_win() return vim.uv.os_uname().sysname:find('Windows') ~= nil end

function M.git()
  local root = M.get()
  local git_root = vim.fs.find('.git', { path = root, upward = true })[1]
  local ret = git_root and vim.fn.fnameescape(git_root, ':h') or root
  return ret
end

---@param opts? {hl_last?: string}
function M.pretty_path(opts) return '' end

--[[ the three below are from wookayin]]
--- list_plugs: get all the registered plugins (incl. non-loaded ones)
---@return string[]
function M.list_plugs() return vim.tbl_keys(require('lazy.core.config').plugins) end

--- Get a LazyPlugin table by its name (exact).
---@param name string
---@return LazyPlugin|nil
function M.get_plugin(name) return require('lazy.core.config').plugins[name] end

--- load: immediately load (lazy) plugins synchronously
---@return LazyPlugin?
function M.load(names) require('lazy.core.loader').load(names, {}, { force = true }) end

return M
