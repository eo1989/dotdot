using LanguageServer
import Pkg

depot_path = get(ENV, "JULIA_DEPOT_PATH")

function is_instantiated(path)
    if isdir(path)
        for filename in Base.project_names
            if is_instantiated(joinpath(path, filename))
                return true
            end
        end
    elseif isfile(path)
        env = Pkg.Types.EnvCache(path)
        return Pkg.Operations.is_instantiated(env)
    end
    return false
end

function get_project_path()

    # Step 1: Tries an explicit project set by JULIA_PROJECT
    julia_project = get(ENV, "JULIA_PROJECT", nothing)
    if julia_project !== nothing && !isempty(julia_project)
        @info "Using JULIA_PROJECT=$julia_project for LSP"
        path = Base.load_path_expand(julia_project)
        if isfile(path)
            path = dirname(path)
        end
        return path
    end

    # Step 2: Look for a Project.toml file in the current working directory and
    # up. If available, prefer environments in a `test` subfolder.
    project_toml = Base.current_project()
    if isnothing(project_toml)
        @warn "No current project"
    else
        project_folder = dirname(project_toml)
        # A test environment takes precedent over the main project environment
        test_folder = joinpath(project_folder, "test")
        if is_instantiated(test_folder)
            @info "Use project_path=$test_folder (instantiated)"
            return test_folder
        else
            if is_instantiated(project_toml)
                @info "Use project_path=$project_folder (instantiated)"
                return project_folder
            else
                @warn "Project folder $project_folder is not instantiated"
            end
        end
    end

    # Step 3 (fallback): First entry in the load path
    first_load_path = get(Base.load_path(), 1, nothing)
    if first_load_path !== nothing
        if isfile(first_load_path)
            project_path = dirname(first_load_path)
        else
            project_path = first_load_path
        end
        @info "project_path = $project_path from load path (fallback)"
        return project_path
    end
end

project_path = get_project_path()
@info "Running language server" VERSION pwd() project_path depot_path
server = LanguageServer.LanguageServerInstance(
    stdin, stdout, project_path, depot_path
)
server.runlinter = true
run(server)


# function recurse_project_paths(path::AbstractString)
#   isnothing(Base.current_project(path)) && return
#   tmp = path
#   CUSTOM_LOAD_PATH = []
#   while !isnothing(Base.current_project(tmp))
#     pushfirst!(CUSTOM_LOAD_PATH, tmp)
#     tmp = dirname(tmp)
#   end
#
#   # push all to LOAD_PATHs
#   pushfirst!(Base.LOAD_PATH, CUSTOM_LOAD_PATH...)
#   return joinpath(CUSTOM_LOAD_PATH[1], "Project.toml")
# end

# buffer_file_path = ARGS[1]
# project_path = let
#   dirname(something(
#     Base.load_path_expand((
#       p = get(ENV, "JULIA_PROJECT", nothing);
#       p === nothing ? nothing : isempty(p) ? nothing : p
#     )),
#     Base.current_project(strip(buffer_file_path)),
#     Base.current_project(pwd()),
#     Pkg.Types.Context().env.project_file,
#     Base.active_project()
#   ))
# end
#
#
# ls_install_path = joinpath(get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")), "environments", "nvim-lspconfig");
# pushfirst!(LOAD_PATH, ls_install_path)
# using LanguageServer;
# popfirst!(LOAD_PATH);
# @info "LOAD_PATHS: $(Base.load_path())"
# depot_path = get(ENV, "JULIA_DEPOT_PATH", "");
# symbol_server_path = joinpath(homedir(), ".cache", "nvim", "julia_lsp_symbol_store")
# mkpath(symbol_server_path)
# @info "LanguageServer has started with buffer $project_path or $(pwd())"
# server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path, nothing, symbol_server_path, true);
# server.runlinter = true;
# run(server);
