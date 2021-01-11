#
#    Trying out OhMyREPL, Colorschemes, Plots (themes) and InteractiveCodeSearch
#

# Using OhMyREPL, InteractiveCodeSearch, Plots

# InteractiveCodeSearch.
import OhMyREPL
import REPL
import REPL.LineEdit
import JLFzf
const mykeys = Dict{Any, Any}(
    # primary history search: most recent 1st
    "^R" => function (mistate, o, c)
        line = JLFzf.inter_fzf(JLFzf.read_repl_hist(),
        "--read0",
        "--tiebreak = index",
        "--height = 80%");
        JLFzf.insert_history_to_repl(mistate, line)
    end,
)
function customize_keys(repl)
    repl.interface = REPL.setup_interface(repl; extra_repl_keymap = mykeys)
end

using Dates
input_prompt() = "julia-" * string(Dates.now()) * >

atreplinit(customize_keys) do repl
    try
        @eval using OhMyREPL
        OhMyREPL.input_prompt!(input_prompt)
    catch e
        @warn "error while importing OhMyREPL" e
    end
end
