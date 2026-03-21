---@type vim.lsp.Config
return {
  cmd = {
    'jetls',
    -- 'serve',
    -- '--pip-listen=/tmp/jetls.sock',
    '--threads=auto',
    '--',
  },
  filetypes = { 'julia' },
  -- single_file_support = true,
  root_markers = { 'Project.toml' },
  settings = {
    jetls = {
      full_analysis = {
        debounce = 2.0,
      },
      -- initialization_options = {
      --   n_analysis_workers = 2,
      -- },
      -- Use JuliaFormatter instead of Runic for now?
      formatter = 'JuliaFormatter',
      diagnostic = {
        patterns = {
          -- suppress toplevel/inference warnings in test folders
          {
            pattern = '(toplevel|inference)/.*',
            match_by = 'code',
            match_type = 'regex',
            severity = 'off',
            path = 'test/**/*.jl',
          },
        },
      },
      testrunner = {
        executable = '/Users/eo/.julia/bin/testrunner',
      },
    },
  },
}
