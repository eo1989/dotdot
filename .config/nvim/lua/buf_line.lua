local vim = vim
require'bufferline'.setup{
    options = {
        view = "default",
        numbers = "ordinal", -- "buffer_id" | "none"
        number_style = "superscript",
        mappings = true,
        buffer_close_icon = {'\uf655'},
        modified_icon = '\u25cf',
        close_icon = {'\uf00d'},
        left_trunc_marker = '\uf0a8',
        right_trunc_marker = '\uf0a9',
        max_name_length = 16,
        max_prefix_length = 12,
        tab_size = 18,
        diagnostics = false | "nvim_lsp"
        diagnostics_indicator = function(count, level)
            return "("..count..")"
        end
        show_buffer_close_icons = true,
        persist_buffer_sort = true,
        separator_style = {'slant', 'thick'},
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = 'relative_directory' | function(buffer_a, buffer_b)
            print(vim.inspect(buffer_a))
          return buffer_a.modified > buffer_b.modified
        end
    }
}
