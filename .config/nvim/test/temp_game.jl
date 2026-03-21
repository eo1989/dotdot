using Plots

_N = 3_000
stay = zeros(Int32, _N)
switch = zeros(Int32, _N)

for game in 1:_N
    prize = rand(1:3)
    choice = rand(1:3)
    if choice == prize
        stay[game] = 1
    elseif choice != prize
        switch[game] = 1
    end
end

stayra = [sum(stay[1:i]) / i for i in 1:_N]
switchra = [sum(switch[1:i]) / i for i in 1:_N]

plot(
    1:_N,
    [stayra, switchra, ones(_N) * 1 / 3, ones(_N) * 2 / 3];
    label = ["Stay" "Switch" "" ""],
)
annotate!(2700, 1 / 3 + 0.05, "1/3")
annotate!(2700, 2 / 3 + 0.05, "2/3")
