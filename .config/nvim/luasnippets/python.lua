-- thanks PriceHiller & u/1linguini1

return {
  s({ trig = 'main', name = 'Main guard.', desc = 'Python __main__ guard.' }, {
    t { 'if __name__ = "__main__":', '\t' },
    c(1, {
      t(''),
      t('main()'),
    }),
  }),
  -- s({ trig = 'def', desc = 'Create a function/method definition with standard parameters.' }, {
  --   t { 'def' },
  --   i(1, 'fn_name'),
  --   d(2, function()
  --     -- immediate parent must be a class definition (first method created in a class will have the
  --     -- current node as a class definition.)
  --     local in_class = false
  --     local node = vim.treesitter.get_node()
  --     if node then in_class = node:type() == 'class_definition' or node:parent():type() == 'class_definition' end
  --
  --     local pos = vim.api.nvim_win_get_cursor(0)
  --     local decorator = vim.api.nvim_buf_get_lines(0, pos[1] - 3, pos[1] - 2, false)
  --
  --     -- decide default args based on nodes
  --     local arguments = '('
  --     if in_class then
  --       if string.find(decorator[1], 'classmethod') then
  --         arguments = arguments .. 'cls, '
  --       elseif not string.find(decorator[1], 'staticmethod') then
  --         arguments = arguments .. 'self, '
  --       end
  --     end
  --
  --     return sn(nil, {
  --       t { arguments },
  --       i(1, ''),
  --       t { ') -> ' },
  --     })
  --   end),
  --   i(3, 'None'),
  --   t { ':', '\t' },
  --   i(0, 'pass'),
  -- }),
  -- s({ trig = '[[', wordTrig = false }, {
  --   t,
  -- }),
}
