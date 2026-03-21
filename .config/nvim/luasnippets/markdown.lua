local visual_selection_insert = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return snippet(nil, t(parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

return {
  snippet(
    {
      trig = 'mdCodeBlock',
      dscr = 'select text, surround it with a md code block, & add an insert node for the language',
    },
    fmta(
      [[```<>
      <>
      ```
      ]],
      {
        i(1, 'python'),
        d(2, visual_selection_insert),
      }
    )
  ),
}
