-- thanks PriceHiller & u/1linguini1

local ls = require('luasnip')
local s = ls.s
local sn = ls.sn
local snippet = ls.snippet
local c = ls.choice_node
local t = ls.text_node
local i = ls.insert_node
local isn = ls.indent_snippet_node
local d = ls.dynamic_node
local r = ls.restore_node
local rep = require('luasnip.extras').rep
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta

local function s_add(...)
  local snip = ls.s(...)
  snip.metadata = debug.getinfo(2)
  table.insert(getfenv(2).ls_file_snippets, snip)
end

local function ins_generate(nodes)
  return setmetatable(nodes or {}, {
    __index = function(table, key)
      local idx = tonumber(key)
      if idx then
        local val = ls.i(idx)
        rawset(table, key, val)
        return val
      end
    end,
  })
end

local function parse_add(...)
  local p = ls.extend_decorator.apply(ls.parser.parse_snippet, {}, { dedent = true, trim_empty = true })
  local snip = p(...)
  table.insert(getfenv(2).ls_file_snippets, snip)
end

local at_start_of_line = function(line_to_cursor, matched_trigger, _) return line_to_cursor == matched_trigger end

-- Allows to keep adding arguments via choice nodes.

local function py_init()
  return sn(
    nil,
    c(1, {
      t(''),
      sn(1, {
        t(', '),
        i(1),
        d(2, py_init),
      }),
    })
  )
end

--- splits the string of the comma separated argument list into the arguments
--- and returns the text-/insert- or restore-nodes
local function to_init_assign(args)
  local tab = {}
  local a = args[1][1]
  if #a == 0 then
    table.insert(tab, t { '', '\tpass' })
  else
    local cnt = 1
    for e in string.gmatch(a, ' ?([^,]*) ?') do
      if #e > 0 then
        table.insert(tab, t { '', '\tself.' })
        table.insert(tab, r(cnt, tostring(cnt), i(nil, e)))
        table.insert(tab, t(' = '))
        table.insert(tab, t(e))
        cnt = cnt + 1
      end
    end
  end
  return sn(nil, tab)
end

local function import(shorthand, importname) parse_add(shorthand, ('import %s as %s'):format(importname, shorthand)) end

-- dynamic node generatoor
local function generate_matchcase_dynamic(args, snip)
  if not snip.num_cases then snip.num_cases = tonumber(snip.captures[1]) or 1 end
  local nodes = {}
  local ins_idx = 1
  for j = 1, snip.num_cases do
    vim.list_extend(
      nodes,
      fmta(
        [[
        case <>:
            <>
        ]],
        { r(ins_idx, 'var' .. j, i(1)), r(ins_idx + 1, 'next' .. j, i(0)) }
      )
    )
  end
  table.insert(nodes, #nodes) -- removes the extra line break
  return isn(nil, nodes, '\t')
end

return {
    -- stylua: ignore start
    -- s({ trig = 'main', name = 'Main guard.', desc = 'Python __main__ guard.' }, {
    --   t { 'if __name__ = "__main__":', '\t' },
    --   c(1, {
    --     t(''),
    --     t('main()')
    --   })
    -- }),
    s("main", fmt(
      [[
      if __name__ == "__main__":
          {0}]],
      {
          [0] = i(0),
      }),
      {
        condition = at_start_of_line,
      }),
    s('def', fmt(
      [[
      def {1}({2}):
          {0}]],
      {
          [0] = i(0),
          [1] = i(1),
          [2] = i(2),
      }), {
        condition = at_start_of_line,
      }),
  s_add('if', fmt([[
  if {}:
    {}
    ]],
    ins_generate())),
    s_add('for', fmt([[
    for {}:
      {}
      ]], ins_generate {
        [1] = c(1, {
          { i(1, 'i'), t(' in '), c(2, {
            {i(1)},
            {i(1), t('range('),c(2, {
              { r(1, 'high', i(1)) },
              { r(1, 'low', i(1)), t(', '), r(2, 'high', i(1)) },
              { r(1, 'high', i(1)), t(', '), r(2, 'low', i(1)), t(', '), i(3, '-1') }
            }), t(')')}
          }) },
          { i(1, 'key'), t(', '), i(2, 'val'), t(' in enumerate('), i(3), t(')') },
          { i(1, 'key'), t(', '), i(2, 'val'), t(' in enumerate('), i(3), t(')') },
        }),
      }
    )
  ),
  parse_add('class',[[
  class $1:
  ]]),
  parse_add('init', [[
  def __init__(self):
  $1
  ]]),
  parse_add('meth', [[
  def $1(self$2):
  $3
  ]]),
  -- px_add({ trig = '.p', match_pattern = '^%s+(.*)' }, parse(nil, [[print($POSTFIX_MATCH)]]))
  import('pd', 'pandas'),
  import('px', 'plotly.express'),
  import('np', 'numpy'),
  import('sns', 'seaborn'),
  import('plt', 'matplotlib.pyplot'),
  import('sk', 'sklearn'),
  import('pl', 'polars'),
  s("__init",fmt(
    [[def __init__(self{args}):{inyt}]],
    {
      args = d(1, py_init),
      inyt = d(2, to_init_assign, { 1 })
    })
  ),
  s({ trig = 'mc(%d*)', name = 'match case', dscr = 'match n cases', regTrig = true, hidden = true },
  fmta([[
  match <>:
  <>
  <>
  ]],
  { i(1), d(2, generate_matchcase_dynamic, {}, {
    user_args = {
      function(snip) snip.num_cases = snip.num_cases + 1 end,
      function(snip) snip.num_cases = math.max(snip.num_cases - 1, 1) end,
    }
  }),
  c(3, {t(""), isn(nil, fmta([[
  case _:
  <>
  ]], {i(1, "pass")}), "\t")})
      }
    )
  ),
}
-- stylua: ignore end

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
