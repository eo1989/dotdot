#
#    Trying out OhMyREPL, Colorschemes, Plots (themes) and InteractiveCodeSearch
#

# Using OhMyREPL, InteractiveCodeSearch, Plots

# InteractiveCodeSearch.
#  import OhMyREPL
#  import REPL
#  import REPL.LineEdit
#  import JLFzf
#  const mykeys = Dict{Any, Any}(
#      # primary history search: most recent 1st
#      "^R" => function (mistate, o, c)
#          line = JLFzf.inter_fzf(JLFzf.read_repl_hist(),
#          "--read0",
#          "--tiebreak = index",
#          "--height = 80%");
#          JLFzf.insert_history_to_repl(mistate, line)
#      end,
#  )
#  function customize_keys(repl)
#      repl.interface = REPL.setup_interface(repl; extra_repl_keymap = mykeys)
#  end

#  using Dates
#  input_prompt() = "julia-" * string(Dates.now()) * >
atreplinit() do repl
    try
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch e
        @warn "Error initializing Revise" exception=(e, catch_backtrace())
    end
    try
        @eval begin
            using OhMyREPL
            # haky fix for []] issues
            @async (sleep(1); OhMyREPL.Prompt.insert_keybindings())
        @async OhMyREPL.input_prompt!(string(VERSION) * ">", :green)
            import OhMyREPL: Passes.SyntaxHighlighter; const SH = SyntaxHighlighter
            OhMyREPL.Passes.SyntaxHighlighter.add!("Dracula", begin
                cs = SH.ColorScheme()
                SH.symbol!(cs, OhMyREPL.Crayon(foreground = (255, 184, 108)))
                SH.comment!(cs, OhMyREPL.Crayon(foreground = (98, 114, 164)))
                SH.string!(cs, OhMyREPL.Crayon(foreground = (241, 250, 140)))
                SH.call!(cs, OhMyREPL.Crayon(foreground = (189, 147, 249)))
                SH.op!(cs, OhMyREPL.Crayon(foreground = (255, 121, 198)))
                SH.keyword!(cs, OhMyREPL.Crayon(foreground = (255, 121, 198)))
                SH.text!(cs, OhMyREPL.Crayon(foreground = (248, 248, 242)))
                SH.macro!(cs, OhMyREPL.Crayon(foreground = (80, 250, 123)))
                SH.function_def!(cs, OhMyREPL.Crayon(foreground = (189, 147, 249)))
                SH.error!(cs, OhMyREPL.Crayon(foreground = (255, 85, 85)))
                SH.argdef!(cs, OhMyREPL.Crayon(foreground = (139, 233, 253)))
                SH.number!(cs, OhMyREPL.Crayon(foreground = (255, 85, 85)))
                cs
            end)
            colorscheme!("Dracula")
        end
    catch e
        @warn("can't load OhMyREPL ;(", e)
    end
end
