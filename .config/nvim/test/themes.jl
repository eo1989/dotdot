using Plots, PlotThemes
plotlyjs()

using KittyTerminalImages

themes = [:dao, :boxed, :vibrant, :mute, :lime, :orange, :rose_pine, :rose_pine_dawn, :gruvbox_light, :gruvbox_dark, :wong, :dracula, :juno, :sheet, :sand, :solarized, :solarized_light, :bright, :dark, :ggplot2, :statistical]
# x = 1:7
# y = [3, 1, 4, 1, 5, 9, 2]

# for theme in themes
#     Plots.reset_defaults()
#     plt = bar(x, y; theme = theme, title = string(theme))
#     savefig(plt, "theme_$(theme).png")
# end

for theme in themes
    Plots.reset_defaults()
    plt = plot(legend = false, title = string(theme), size = (300, 80))
    showtheme(plt, theme)
    plot(rand(1:7, 7), color = palette(:auto, 7), seriestype = :bar, title = string(theme), legend = false, dpi = 400)
    display()
end

# for theme in themes
#     Plots.reset_defaults()
#     p = plot(legend = false, xticks = nothing, yticks = nothing, title = string(theme), size = (300, 80))
#     cols = palette(theme, 7)
#     for (i, c) in enumerate(cols)
#         bar!([i], [1]; color = c, bar_width = 1)
#     end
#     savefig(p, "palette_$(theme).png")
# end
