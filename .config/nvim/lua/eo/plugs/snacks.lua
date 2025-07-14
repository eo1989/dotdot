return {
  {
    'folke/snacks.nvim',
    priority = 1001,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = { enabled = false },
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dashboard = { enabled = false },
      dim = { enabled = true },
      explorer = { enabled = false },
      git = { enabled = false },
      gitbrowse = { enabled = true },
      image = {
        -- define these here, so that we don't need to load the image module
        enabled = true,
        formats = {
          'png',
          'jpg',
          'jpeg',
          'gif',
          'bmp',
          'webp',
          'tiff',
          'heic',
          'avif',
          'mp4',
          'mov',
          'avi',
          'mkv',
          'webm',
          'pdf',
        },
        doc = {
          -- enable image viewer for documents
          -- a treesitter parser must be available for the enabled languages.
          enabled = true,
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = false,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = true,
          max_width = 80,
          max_height = 40,
          -- Set to `true`, to conceal the image text when rendering inline.
          conceal = true, -- (experimental)
        },
        math = {
          enabled = true,
          -- in the templates below, `${header}` comes from any section in your document,
          -- between a start/end header comment. Comment syntax is language-specific.
          -- * start comment: `// snacks: header start`
          -- * end comment:   `// snacks: header end`
          typst = {
            tpl = [[
            #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
            #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
            #set text(size: 12pt, fill: rgb("${color}"))
            ${header}
            ${content}]],
          },
          latex = {
            font_size = 'large', -- see https://www.sascha-frank.com/latex-font-size.html
            -- for latex documents, the doc packages are included automatically,
            -- but you can add more packages here. Useful for markdown documents.
            packages = { 'amsmath', 'amssymb', 'amsfonts', 'amscd', 'mathtools' },
            tpl = [[
            \documentclass[preview,border=2pt,varwidth,12pt]{standalone}
            \usepackage{${packages}}
            \begin{document}
            ${header}
            { \${font_size} \selectfont
              \color[HTML]{${color}}
            ${content}}
            \end{document}]],
          },
        },
      },
      indent = { enabled = true },
      input = { enabled = false },
      layout = { enabled = false },
      lazygit = { enabled = true },
      notifier = {
        enabled = false,
        timeout = 2000,
      },
      picker = { enabled = true }, --[[ needed for Snacks.picker.lsp_definition() & such ]]
      profiler = { enabled = true },
      quickfile = { enabled = true },
      rename = { enabled = false },
      scope = { enabled = true },
      scratch = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      terminal = { enabled = false },
      toggle = { enabled = true },
      win = { enabled = false },
      words = { enabled = true },
      zen = { enabled = false },
      styles = { enabled = false },
    },
    keys = {
      {
        '<leader>qq',
        function() Snacks.bufdelete() end,
        desc = 'Delete buffer',
      },
      {
        '<localleader>.',
        function() Snacks.scratch() end,
        desc = 'Scratch buffer',
      },
      {
        '<localleader>.',
        function() Snacks.scratch.select() end,
        desc = 'Scratch buffer',
      },
      {
        '<localleader>n',
        function() Snacks.notifier.show_history() end,
        desc = 'Notification history',
      },
      {
        ']]',
        function() Snacks.words.jump(1) end,
        -- noremap = true,
        silent = true,
        desc = 'Next reference',
        mode = { 'n', 't' },
        nowait = true,
      },
      {
        '[[',
        function() Snacks.words.jump(-1) end,
        -- noremap = true,
        silent = true,
        desc = 'Prev reference',
        mode = { 'n', 't' },
        nowait = true,
      },
      {
        '<localleader>z',
        function() Snacks.zen() end,
        desc = 'Toggle Zen mode',
      },
      {
        '<localleader>Z',
        function() Snacks.zen.zoom() end,
        desc = 'Toggle Zoom',
      },
      -- {
      --   '<localleader>n',
      --   function() Snacks.notifier.show_history() end,
      --   desc = 'Notification history',
      -- },
      -- {
      --   '<localleader>n',
      --   function() Snacks.notifier.hide() end,
      --   desc = 'Dismiss All Notification',
      -- },
      {
        '<localleader>lg',
        function() Snacks.lazygit() end,
        desc = 'Lazygit',
      },
      {
        '<localleader>lG',
        function() Snacks.gitbrowse() end,
        desc = 'gitbrowse',
        mode = { 'n', 'v' },
      },
      {
        '<localleader>N',
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = 'yes',
              statuscolumn = ' ',
              conceallevel = 3,
            },
          }
        end,
        desc = 'nvim news',
      },
    },
    init = function()
      -- require('snacks').setup(opts)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd

          Snacks.toggle.option('spell', { name = 'Spelling' }):map('<localleader>us')
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<localleader>uw')
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<localleader>uL')
          Snacks.toggle.diagnostics():map('<localleader>ud')
          Snacks.toggle.line_number():map('<localleader>ul')
          Snacks.toggle
            .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map('<localleader>uc')
          Snacks.toggle.treesitter():map('<localleader>uT')
          Snacks.toggle
            .option('background', { off = 'light', on = 'dark', name = 'Dark background' })
            :map('<localleader>ub')
          Snacks.toggle.indent():map('<localleader>ug')
          Snacks.toggle.dim():map('<localleader>uD')
        end,
      })
    end,
  },
}
