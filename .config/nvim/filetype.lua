if not vim.filetype then return end

vim.g.filetype_lua = true

vim.filetype.add({
  -- extension = {
  --   png = 'image',
  --   jpg = 'image',
  --   jpeg = 'image',
  --   tf = 'terraform',
  --   tsx = 'typescriptreact',
  --   ts = 'typescript',
  -- },
  filename = {
    -- ['NEOGIT_COMMIT_EDITMSG'] = 'NeogitCommitMessage',
    ['go.mod'] = 'gomod',
    -- ['.psqlrc'] = 'conf', -- TODO: find a better filetype
    ['.gitignore'] = 'conf',
    ['launch.json'] = 'jsonc',
    Podfile = 'ruby',
    Brewfile = 'ruby',
  },
  pattern = {
    -- ['.*%.ipynb'] = 'python',
    ['.*%.conf'] = 'conf',
    ['.*%.theme'] = 'conf',
    ['.*%.gradle'] = 'groovy',
    ['.*%.env%..*'] = 'sh',
    ['.*%.*rc'] = 'sh',
  },
})
