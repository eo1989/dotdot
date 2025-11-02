# open("/Users/eo/Downloads/lichess_db_puzzle.csv", "w") do io
#     println(io, "PuzzleID,FEN,Moves,Rating,RatingDeviation,Popularity,NbPlays,Themes,GameUrl")
#     write(io)
# end
# readlines("/Users/eo/Downloads/lichess_db_puzzle.csv")

using CSV, DataFrames
file = "/Users/eo/Downloads/lichess_db_puzzle.csv"
if isfile(file) == false
    error("File not found: $file")
    download("https://database.lichess.org/lichess_db_puzzle.csv.bz2", file * ".bz2")
    
end


puzzles = CSV.read(file, DataFrame);
show(describe(puzzles); truncate=14);

using Statistics
plays_lo = median(puzzles.NbPlays)

# check
# Note the use of broadcasting when writing `.>` to compare the `NbPlays` col to
# a scalar value of a computed median. If the dot (.) is omitted, an error would be returned.
puzzles.NbPlays .> plays_lo

rating_lo = 1500
rating_hi = quantile(puzzles.Rating, 0.99)

# broadcasting used again to get the desired result.
rating_lo .< puzzles.Rating .< rating_hi

# combining both conditions by using the broadcasted && operator
row_selector = (puzzles.NbPlays .> plays_lo) .&& (rating_lo .< puzzles.Rating .< rating_hi)


# Diff btwn the `sum` and the `count` fx is that `count` requires that the data passed to it is Boolean
# and counts the number of true values, while `sum` can process any data for which addition is meaningfully defined.
sum(row_selector) == count(row_selector)
# true

good = puzzles[row_selector, ["Rating", "Popularity"]]

using Plots
plot(histogram(good.Rating; label="Rating"), histogram(good.Popularity; label="Popularity"))

# puzzles[1, "Rating"]
# puzzles[:, "Rating"]

# row1 = puzzles[1, ["Rating", "Popularity"]]
good = puzzles[row_selector, ["Rating", "Popularity"]]
