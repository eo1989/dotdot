using Pkg: Pkg
# using Revise

atreplinit() do repl
    try
        @eval begin
            # macros for utilizing test env
            @eval using TestEnv
            macro testenv()
                return :(TestEnv.activate())
            end
            macro testenv(body)
                return :(
                    TestEnv.activate() do
                        $body
                    end
                )
            end
        end

        @eval using OhMyREPL
        colorscheme!("Monokai24bit")
        @async OhMyREPL.input_prompt!(string(VERSION) * "λ: ", :green)
        OhMyREPL.enable_pass!("RainbowBrackets", true)
        OhMyREPL.enable_pass!("Markdown", true)
        OhMyREPL.enable_pass!("Fzf", true)
    catch e
        @warn "error while importing OhMyREPL" e

        if haskey(ENV, "KITTY_LISTEN_ON")
            @eval import KittyTerminalImages
            KittyTerminalImages.pushKittyDisplay()
        end

        if haskey(ENV, "TERM_PROGRAM") && ENV["TERM_PROGRAM"] == "vscode"
            OhMyREPL.enable_autocomplete_brackets(false)
        else
            # not in vscode repl
            using Revise
        end

        if isfile("Project.toml")
            # @eval using Pkg: Pkg
            @info "Activating project in $(pwd())"
            Pkg.activate(".")
            Pkg.instantiate(".")
        end

        @eval using REPL
        if !isdefined(repl, :interface)
            repl.interface = REPL.setup_interface(repl)
        end
    end

    # try
    #     @eval using OhMyREPL
    #     OhMyREPL.enable_autocomplete_brackets(true) # only in vscode!
    #     OhMyREPL.enable_fzf(true)
    #     OhMyREPL.enable_highlight_markdown(true)
    #     @async (sleep(0.1); Prompt.insert_keybindings())
    #     #=  NOTE: all darker colorschemes I may like
    #         Monokai{16,24bit,256}, OneDark, Tomorrow{,24bit}, Dracula, Distinguished, GithubDark{,Dimmed}, BoxyMonokai256, Base16MarterialDarker, Tomorrow{,24bit,Day,NightBright{,24bit}}
    #     =#
    #     colorscheme!("Monokai24bit")
    #     REPL.numbetered_prompt!(OhMyREPL.input_prompt!(string(VERSION) * " λ:", :green))
    # catch e
    #     @warn "error importing OhMyREPL"
    # end


    # try
    #     @eval using OhMyREPL &&
    #         if !isdefined(repl, :interface)
    #         repl.interface = REPL.setup_interface(repl)
    #
    #         OhMyREPL.enable_autocomplete_brackets(true)
    #         OhMyREPL.enable_fzf(true)
    #         OhMyREPL.enable_highlight_markdown(true)
    #         @async (sleep(0.1); Prompt.insert_keybindings())
    #
    #         import OhMyREPL: Passes.SyntaxHighlighter
    #         const SH = SyntaxHighlighter
    #         # @async OhMyREPL.input_prompt!(string(VERSION) * "λ", :green)
    #
    #         OhMyREPL.Passes.SyntaxHighlighter.add!(
    #             "OneDark", begin
    #                 cs = SH.ColorScheme()
    #                 SH.symbol!(cs, OhMyREPL.Crayon(foreground = (255, 184, 108)))
    #                 SH.comment!(cs, OhMyREPL.Crayon(foreground = (98, 114, 164)))
    #                 SH.string!(cs, OhMyREPL.Crayon(foreground = (241, 250, 140)))
    #                 SH.call!(cs, OhMyREPL.Crayon(foreground = (189, 147, 249)))
    #                 SH.op!(cs, OhMyREPL.Crayon(foreground = (255, 121, 198)))
    #                 SH.keyword!(cs, OhMyREPL.Crayon(foreground = (255, 121, 198)))
    #                 SH.text!(cs, OhMyREPL.Crayon(foreground = (248, 248, 242)))
    #                 SH.macro!(cs, OhMyREPL.Crayon(foreground = (80, 250, 123)))
    #                 SH.function_def!(cs, OhMyREPL.Crayon(foreground = (189, 147, 249)))
    #                 SH.error!(cs, OhMyREPL.Crayon(foreground = (255, 85, 85)))
    #                 SH.argdef!(cs, OhMyREPL.Crayon(foreground = (139, 233, 253)))
    #                 SH.number!(cs, OhMyREPL.Crayon(foreground = (255, 85, 85)))
    #                 cs
    #             end
    #         )
    #         colorscheme!("OneDark")
    #     end
    #     @async REPL.numbered_prompt!(input_prompt!(string(VERSION) * "λ", :green))
    # catch e
    #     @warn "error while importing OhMyREPL" e
    # end
end


# try
#     # import Term: install_term_stacktrace, install_term_logger, install_term_repr
#     import Term: install_term_repr
#     # install_term_stacktrace()
#     # install_term_logger()
#     install_term_repr()
# catch e
#     @warn "Error initializing term" exception = (e, catch_backtrace())
# end

# using OhMyREPL
# using REPL



#
#    Trying out OhMyREPL, Colorschemes, Plots (themes) and InteractiveCodeSearch
#

# Using OhMyREPL, InteractiveCodeSearch, Plots

# InteractiveCodeSearch.

# import OhMyREPL
# import REPL
# import REPL.LineEdit
# import JLFzf
# const mykeys = Dict{Any, Any}(
#     # primary history search: most recent 1st
#     "^R" => function (mistate, o, c)
#         line = JLFzf.inter_fzf(JLFzf.read_repl_hist(),
#         "--read0",
#         "--tiebreak = index",
#         "--height = 80%");
#         JLFzf.insert_history_to_repl(mistate, line)
#     end,
# )
# function customize_keys(repl)
#     repl.interface = REPL.setup_interface(repl; extra_repl_keymap = mykeys)
# end

# using Dates
# input_prompt() = "julia-" * string(Dates.now()) * >
# const PLOTS_DEFAULTS = Dict(
#     :theme => :cividis,
#     :fontfamily => "MesloLGLDZNerdFontComplete"
# )

# if isinteractive() &&
#         (local REPL = get(Base.loaded_modules, Base.PkgId(Base.UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb"), "REPL"), nothing); REPL !== nothing)
#     # using Revise
#
#     pushfirst!(
#         REPL.repl_ast_transforms, function (ast::Union{Expr, Nothing})
#             function toplevel_quotenode(ast, s)
#                 return (Meta.isexpr(ast, :toplevel, 2) && ast.args[2] === QuoteNode(s)) ||
#                     (Meta.isexpr(ast, :toplevel) && any(x -> toplevel_quotenode(x, s), ast.args))
#             end
#             if toplevel_quotenode(ast, :q)
#                 exit()
#             elseif toplevel_quotenode(ast, :r)
#                 argv = Base.julia_cmd().exec
#                 opts = Base.JLOptions()
#                 if opts.project != C_NULL
#                     push!(argv, "--project=$(unsafe_string(opts.project))")
#                 end
#                 if opts.nthreads != 0
#                     push!(argv, "--threads=$(opts.nthreads)")
#                 end
#                 # @ccall execv(argv[1]::Cstring, argv::Ref{Cstring})::Cint
#                 ccall(:execv, Cint, (Cstring, Ref{Cstring}), argv[1], argv)
#             end
#             return ast
#         end
#     )
#
#     # Automatically load tooling on demand:
#     # - BenchmarkTools.jl when encountering @btime or @benchmark
#     # - Cthulhu.jl when encountering @descend(_code_(typed|warntype))
#     # - Debugger.jl when encountering @enter or @run
#     # - Profile.jl when encountering @profile
#     # - ProfileView.jl when encountering @profview
#     # - Test.jl when encountering @test, @testset, @test_xxx, ...
#     local tooling_dict = Dict{Symbol, Vector{Symbol}}(
#         :BenchmarkTools => Symbol.(["@btime", "@benchmark"]),
#         :Cthulhu => Symbol.(["@descend", "@descend_code_typed", "@descend_code_warntype"]),
#         :Debugger => Symbol.(["@enter", "@run"]),
#         :Profile => Symbol.(["@profile"]),
#         :ProfileView => Symbol.(["@profview"]),
#         :Test => Symbol.(
#             [
#                 "@test", "@testset", "@test_broken", "@test_deprecated",
#                 "@test_logs", "@test_nowarn", "@test_skip",
#                 "@test_throws", "@test_warn",
#             ]
#         ),
#     )
#     pushfirst!(
#         REPL.repl_ast_transforms, function (ast::Union{Expr, Nothing})
#             function contains_macro(ast, m)
#                 return ast isa Expr && (
#                     (Meta.isexpr(ast, :macrocall) && ast.args[1] === m) ||
#                         any(x -> contains_macro(x, m), ast.args)
#                 )
#             end
#             for (mod, macros) in tooling_dict
#                 if any(contains_macro(ast, s) for s in macros) && !isdefined(Main, mod)
#                     @info "Loading $mod ..."
#                     try
#                         Core.eval(Main, :(using $mod))
#                     catch err
#                         @info "Failed to automatically load $mod" exception = err
#                     end
#                 end
#             end
#             return ast
#         end
#     )
# end

# ------------------------------------------------------------------------------
# Open files in another tmux instance where nvim should already be running
# with @edit <function call> or, when a stacktrace is displayed, with [number]<C-q>
# ------------------------------------------------------------------------------
# using InteractiveUtils

# ENV["EDITOR"] = "nvim"
# ENV["JULIA_EDITOR"] = "nvim"
# InteractiveUtils.define_editor( r"nvim", wait=true)

# do cmd, path, line
#     `$cmd +$line $path`
#     # Open in pane to the left of REPL
#     # `tmux send-keys -t '{'left-of'}' Escape ":edit +$line $path" C-m C-h`
#     # Open in window 1
#     # `tmux select-window -t 0:1';' send-keys -t 0:1.0 Escape ":edit +$line $path" C-m`
# end

# ------------------------------------------------------------------------------

function pretty_rational()
    return @eval Base.show(io::IO, x::Rational) =
        x.den == 1 ? print(io, x.num) : print(io, "$(x.num)/$(x.den)")
end


# ------------------------------------------------------------------------------
## Clear screen leaving prompt at the bottom
# ------------------------------------------------------------------------------
# function clr()
#     for i in 1:60
#         println()
#     end
#     return
# end

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
    return open(script * ".stdout", "w") do io
        redirect_stdout(io) do
            include(script * ".jl")
        end
    end
end


# vim: ft=julia:sw=4:ts=4:sts=4:et:ai:
