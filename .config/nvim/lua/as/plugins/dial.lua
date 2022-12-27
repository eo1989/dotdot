return function()
  local dial = require('dial.map')
  local augend = require('dial.augend')
  local map = vim.keymap.set
  map('n', '<C-a>', dial.inc_normal(), { remap = false })
  map('n', '<C-x>', dial.dec_normal(), { remap = false })
  map('v', '<C-a>', dial.inc_visual(), { remap = false })
  map('v', '<C-x>', dial.dec_visual(), { remap = false })
  map('v', 'g<C-a>', dial.inc_gvisual(), { remap = false })
  map('v', 'g<C-x>', dial.dec_gvisual(), { remap = false })
  require('dial.config').augends:register_group({
    -- default augends used when no group name is specified
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.integer.alias.octal,
      augend.integer.alias.binary,
      augend.date.alias['%Y/%m/%d'],
      augend.constant.alias.bool,
      augend.constant.new({
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
      }),
      augend.case.new({
        types = { 'camelCase', 'snake_case', 'PascalCase' },
        cyclic = true,
      }),
    },
    dep_files = {
      augend.semver.alias.semver,
    },
    -- py_files = {
    --   augend.constant.new({
    --     elements = { '&', '|', '~', '^' }, -- py bitwise and, or, not, xor
    --     word = false,
    --     cyclic = true,
    --   }),
    --   augend.constant.new({
    --     elements = { '&=', '|=', '^=' }, -- py inplace bitwise versions of and, or, xor
    --     word = false,
    --     cyclic = true,
    --   }),
    --   augend.constant.new({
    --     elements = { 'and', 'or', 'not' },
    --     word = false,
    --     cyclic = true,
    --   }),
    --   augend.constant.new({
    --     elements = { '=', '!=', ':=' },
    --     word = false,
    --     cyclic = true,
    --   }),
    --   augend.constant.new({
    --     elements = { '>=', '<=' },
    --     word = false,
    --     cyclic = true,
    --   }),
    --   augend.constant.new({
    --     elements = { '>>', '<<' }, -- py inplace bitewise right and left shift
    --     word = false,
    --     cyclic = true,
    --   }),
    --   augend.constant.new({
    --     elements = { '>>=', '<<=' }, -- py inplace bitewise right and left shift
    --     word = false,
    --     cyclic = true,
    --   }),
    --   augend.constant.new({
    --     elements = { '>', '<' },
    --     word = false,
    --     cyclic = true,
    --   }),
    --   augend.constant.alias.bool.new({
    --     elements = { 'True', 'False' },
    --     word = false,
    --     cyclic = true,
    --     preserve_case = true,
    --   }),
    --   augend.constant.new({
    --     elements = { '+=', '-=', '*=', '/=', '//=', '%=' },
    --     word = false,
    --     cyclic = true,
    --   }),
    -- },
  })
  -- if vim.filetype.match('python') ~= 1 or vim.filetype.match({ 'yaml', 'toml' }) == 1 then
  --   as.augroup('DialMaps', {
  --     {
  --       event = 'FileType',
  --       pattern = { 'python', 'julia' },
  --       command = function()
  --         map('n', '<C-a>', require('dial.map').inc_normal('py_files'), { remap = true })
  --         map('n', '<C-x>', require('dial.map').dec_normal('py_files'), { remap = true })
  --       end,
  --     },
  --   })
  -- end

  as.augroup('DialMaps', {
    -- {
    --   event = 'FileType',
    --   pattern = { 'python' },
    --   command = function()
    --     map('n', '<C-a>', require('dial.map').inc_normal('py_files'), { remap = true })
    --     map('n', '<C-x>', require('dial.map').dec_normal('py_files'), { remap = true })
    --   end,
    -- },
    {
      event = 'FileType',
      pattern = { 'yaml', 'toml' },
      command = function()
        map('n', '<C-a>', require('dial.map').inc_normal('dep_files'), { remap = true })
      end,
    },
  })
end
