# specific type of exception. Following snippet uses exceptions to return `missing` if a specific key isnt found in a dictionary

data = Dict(
    ("ufvolume", "Germany", 2020) => 3683,
    ("volume", "France", 2020) => 3055
)

function volume(region, year)
    try
        return data["volume", region, year]
    catch e
        if isa(e, KeyError)
            return missing
        end
        rethrow(e)
    end
end


# volume("Germany", 2020) # 3683
# volume("Germany", 2025) # missing

#=
builtin function that does the samething.
=#
# get(data, ("volume", "germany", 2025), missing) # missing

# Activation function
relu(x) = max(0, x)

# Individual layer
forwardlayer(x, ω, ω₀, f) = f.(ω*x .+ ω₀)

function forward_network!(y, x, ω₁, ω₂, ω₃, ω¹, ω², ω⁴, f = relu)
    # whole chain
    x₁ = forwardlayer(x, ω₁, ω¹, f)
    x\_
end



