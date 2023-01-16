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

#= using Dates =#
#= input_prompt() = "julia-" * string(Dates.now()) * > =#
#= const PLOTS_DEFAULTS = Dict( =#
#=     :theme => :cividis, =#
#=     :fontfamily => "MesloLGLDZNerdFontComplete" =#
#= ) =#

using Pkg
if isfile("Project.toml") && isfile("Manfest.toml")
    # auto-activate project in pwd
    @info "Activating project in $(pwd())"
    Pkg.activate(".")
end


try
    import Term: install_term_stacktrace, install_term_logger, install_term_repr
    install_term_stacktrace()
    install_term_logger()
    install_term_repr()
catch e
    @warn "Error initializing term" exception = (e, catch_backtrace())
end

function pretty_rational()
    @eval Base.show(io::IO, x::Rational) =
        x.den == 1 ? print(io, x.num) : print(io, "$(x.num)/$(x.den)")
end

using Revise
# @async Revise.wait_steal_repl_backend()

atreplinit() do repl
    try
        @eval begin
            using OhMyREPL
            # haky fix for []] issues
            @async (sleep(1); OhMyREPL.Prompt.insert_keybindings())
            import OhMyREPL: Passes.SyntaxHighlighter
            const SH = SyntaxHighlighter
            @async OhMyREPL.input_prompt!(string(VERSION) * ">", :green)
            # OhMyREPL.Passes.SyntaxHighlighter.add!("OneDark", begin
            #     cs = SH.ColorScheme()
            #     SH.symbol!(cs, OhMyREPL.Crayon(foreground=(255, 184, 108)))
            #     SH.comment!(cs, OhMyREPL.Crayon(foreground=(98, 114, 164)))
            #     SH.string!(cs, OhMyREPL.Crayon(foreground=(241, 250, 140)))
            #     SH.call!(cs, OhMyREPL.Crayon(foreground=(189, 147, 249)))
            #     SH.op!(cs, OhMyREPL.Crayon(foreground=(255, 121, 198)))
            #     SH.keyword!(cs, OhMyREPL.Crayon(foreground=(255, 121, 198)))
            #     SH.text!(cs, OhMyREPL.Crayon(foreground=(248, 248, 242)))
            #     SH.macro!(cs, OhMyREPL.Crayon(foreground=(80, 250, 123)))
            #     SH.function_def!(cs, OhMyREPL.Crayon(foreground=(189, 147, 249)))
            #     SH.error!(cs, OhMyREPL.Crayon(foreground=(255, 85, 85)))
            #     SH.argdef!(cs, OhMyREPL.Crayon(foreground=(139, 233, 253)))
            #     SH.number!(cs, OhMyREPL.Crayon(foreground=(255, 85, 85)))
            #     cs
            # end)
            colorscheme!("OneDark")
        end
    catch e
        @warn "can't load OhMyREPL", exception = (e, catch_backtrace())
    end
end

# ------------------------------------------------------------------------------
# TEMP: Color paths in Stacktraces with custom color
# ------------------------------------------------------------------------------

# https://discourse.julialang.org/t/julia-1-6-stacktrace/57981/13
# Real solution is WIP: https://github.com/JuliaLang/julia/issues/41435
@eval Base begin
    path_color = :blue
    function print_stackframe(io, i, frame::StackFrame, n::Int, digit_align_width, modulecolor)
        file, line = string(frame.file), frame.line
        stacktrace_expand_basepaths() && (file = something(find_source_file(file), file))
        stacktrace_contract_userdir() && (file = contractuser(file))

        # Used by the REPL to make it possible to open
        # the location of a stackframe/method in the editor.
        if haskey(io, :last_shown_line_infos)
            push!(io[:last_shown_line_infos], (string(frame.file), frame.line))
        end
        inlined = getfield(frame, :inlined)
        modul = parentmodule(frame)
        # frame number
        print(io, " ", lpad("[" * string(i) * "]", digit_align_width + 2))
        print(io, " ")
        StackTraces.show_spec_linfo(IOContext(io, :backtrace => true), frame)
        if n > 1
            printstyled(io, " (repeats $n times)"; color=:light_black)
        end
        println(io)
        # @
        printstyled(io, " "^(digit_align_width + 2) * "@ ", color=:light_black)
        # module
        if modul !== nothing
            printstyled(io, modul, color=modulecolor)
            print(io, " ")
        end
        # filepath
        pathparts = splitpath(file)
        folderparts = pathparts[1:end-1]
        if !isempty(folderparts)
            printstyled(io, joinpath(folderparts...) * (Sys.iswindows() ? "\\" : "/"), color=path_color)
        end
        # filename, separator, line
        # use escape codes for formatting, printstyled can't do underlined and color
        # codes are bright black (90) and underlined (4)
        function print_underlined(io::IO, s...)
            colored = get(io, :color, false)::Bool
            start_s = colored ? text_colors[path_color] * "\033[4m" : ""
            end_s = colored ? "\033[0m" : ""
            print(io, start_s, s..., end_s)
        end
        print_underlined(io, pathparts[end], ":", line)
        # inlined
        printstyled(io, inlined ? " [inlined]" : "", color=path_color)
    end
end

# ------------------------------------------------------------------------------
## Clear screen leaving prompt at the bottom
# ------------------------------------------------------------------------------
function clr()
    for i = 1:60
        println()
    end
end

# ------------------------------------------------------------------------------
# Open files in another tmux instance where nvim should already be running
# with @edit <function call> or, when a stacktrace is displayed, with [number]<C-q>
# ------------------------------------------------------------------------------
using InteractiveUtils

ENV["JULIA_EDITOR"] = "nvim"
InteractiveUtils.define_editor( r"nvim", wait=true)
do cmd, path, line
    `$cmd +$line $path`
    # Open in pane to the left of REPL
    # `tmux send-keys -t '{'left-of'}' Escape ":edit +$line $path" C-m C-h`
    # Open in window 1
    # `tmux select-window -t 0:1';' send-keys -t 0:1.0 Escape ":edit +$line $path" C-m`
end

# ------------------------------------------------------------------------------
##  Improvement to the display of stack traces in the Julia REPL
# ------------------------------------------------------------------------------
# using AbbreviatedStackTraces

#=----------------------------------------------------------------------------=#
## JULIA TIPS AND TRICKS
#=----------------------------------------------------------------------------=#

#=--------------------------- Open file in stacktrace --------------------------
In the REPL, enter the stacktrace number followed by <Ctrl-q>
julia> map("hola")
  Stacktrace:
  [1] map(f::String)
    @ Base ./abstractarray.jl:2859
  [2] top-level scope
    @ REPL[15]:1
julia> 1<C-q>
------------------------------- List of Handy Macros ---------------------------
@edit           <function call/macro call>
@debug          <string message> [key=value | value ...]
  To enable @debug messages, you need to set the JULIA_DEBUG environment var:
  julia> ENV["JULIA_DEBUG"] = "all"
--------------------- View Code at different Compiling Stages ------------------
@code_lowered   <function/macro>
@code_typed     <function/macro>
@code_llvm      <function/macro>
@code_native    <function/macro>
@code_warntype  <function/macro>
-------------------------------- Methods Available -----------------------------
Write a function in the REPL with the opening parenthesis and type <Tab>
Another option is tu use the @which macro:
  @which <function/macro>
You can also query Julia to output all methods that take a certain type of
argument with:
  methodswith(typ[, module or function]; supertypes::Bool=false])
----------------------------------- REPL History -------------------------------
Type the beginning of a command and type Ctrl-p to browse through all commands
in history that begin with the same chars. For example:
  julia> ENV<CTRL+P>
completes to:
  julia> ENV["JULIA_DEBUG"] = "all"
With OhMyREPL, type Ctrl-R in the REPL to start FZF to filter the REPL History
----------------------------------- REPL Propose -------------------------------
Search available docstrings for entries containing pattern.
When pattern is a string, case is ignored. Results are printed to io.
  apropos([io::IO=stdout], pattern::Union{AbstractString,Regex})
------------------------------------- Debugger ---------------------------------
  julia> using Debugger       # import the julia debugger
  julia> @enter <function>    # run <function> in debugger mode
  debug> ?                    # list the help to see all debugger available cmds
  debug> `                    # go to julia mode keeping the backtrace (backspace to leave)
  |julia> print(x)            # print the content of `x`
  |julia> x = 2               # assign the value 2 to `x`
------------------------------------------------------------------------------=#

# add dependencies to  env stack
#=
let
    # add dependencies to the env stack
    pkgpath = dirname(dirname(pathof(PDEInterfaces)))
    tstpath = joinpath(pkgpath, "test")
    !(tstpath in LOAD_PATH) && push!(LOAD_PATH, tstpath)
    nothing
end
=#

# utility
ls(x) = readdir(x)
ls() = readdir()
ty(x) = typeof(x)
fn(x) = filenames(x)
fnty = fn ∘ ty

iscallable(op) = !isempty(methods(op))
push(x::Tuple, val) = (x..., val)
linspace(zi::Number, ze::Number, n::Integer) = Array(range(zi, stop=ze, length=n))

# TODO: make macro @capture_out include("script.jl")
function capture_out(script::AbstractString)
    open(script * ".stdout", "w") do io
        redirect_stdout(io) do
            include(script * ".jl")
        end
    end
end



