vim.cmd([[
  func Foo()
    eval 1
  endfunction

  breakadd expr abs(0)
  call Foo()
]])
