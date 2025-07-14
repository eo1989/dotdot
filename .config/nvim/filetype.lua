vim.filetype.add {
  extension = {
    pip = 'requirements',
    mdx = 'markdown',
    cconf = 'python',
    -- jl = 'julia',
    plist = 'xml.plist', -- macOS PropertyList files
    pcf = 'pkl',
    pkl = 'pkl',
    tex = 'latex',
  },
  filename = {
    ['.rgignore'] = 'gitignore',
    ['PklProject'] = 'pkl',
    ['NEOGIT_COMMIT_EDITMSG'] = 'NeogitCommitMessage',
    ['.psqlrc'] = 'conf',
    ['launch.json'] = 'jsonc',
    Podfile = 'ruby',
    Brewfile = 'ruby',
    ['MANIFEST.in'] = 'pymanifest',
    -- ['config.custom'] = 'sshconfig',
    ['fish_history'] = 'yaml',
    ['Cargo.toml'] = 'caddyfile',
    -- dsully/nvim/blob/main/filetype.lua ex:
    -- set specific ft to enable ruff_lsp & taplo to attach as lang servers
    ['poetry.lock'] = 'toml',
    ['pyproject.toml'] = 'toml.pyproject',
    ['ruff.toml'] = 'toml.ruff',
    ['uv.lock'] = 'toml',
    ['.flake8'] = 'ini',
    -- ['.zshrc'] = 'sh',
    -- ['.zshenv'] = 'sh',
  },
  pattern = {
    ['*Caddyfile*'] = 'caddyfile',
    ['.*/%.github[%w/]+workflows[%w/]+.*%.ya?ml'] = 'yaml.github',
    -- ['.*/.github/workflows/.*%yaml'] = 'yaml.ghaction',
    -- ['.*/.github/workflows/.*%yml'] = 'yaml.ghaction',
    ['.yml$'] = function(path) return path:find('compose') and 'yaml.docker-compose' or 'yaml' end,
    ['*.dockerignore'] = 'gitignore',
    ['.*requirements%.in'] = 'requirements',
    ['.*requirements.*%.in'] = 'requirements',
    ['requirements[%w_.-]+%.txt'] = 'requirements', --[[ this covers the 2 below ]]
    -- ['.*requirements%.txt'] = 'requirements',
    -- ['.*requirements.*%.txt'] = 'requirements',
    -- ['.*/%.vscode/.*%.json'] = 'json5', -- stevearc dotfiles -> these json files freq have comments
    ['.*/%.?vscode/settings.json'] = 'jsonc', -- dhruvmanilla dotfiles
    ['.*/zed/settings.json'] = 'jsonc',
    ['.*%.conf'] = 'conf',
    ['.*%.theme'] = 'conf',
    ['.*%.gradle'] = 'groovy',
    ['^.env%..*'] = 'bash',
    ['.*aliases'] = 'bash',
    ['README.(a+)$'] = function(_, _, ext)
      if ext == 'md' then
        return 'markdown'
      elseif ext == 'rst' then
        return 'rst'
      end
    end,
  },
}
