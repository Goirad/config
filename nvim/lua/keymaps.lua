-- General plugin-agnostic keymaps

-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Moving through splits
map('n', '<M-h>', '<C-w>h', { silent = true })
map('n', '<M-j>', '<C-w>j', { silent = true })
map('n', '<M-k>', '<C-w>k', { silent = true })
map('n', '<M-l>', '<C-w>l', { silent = true })
map('n', '<Leader>S', ':%s//g<Left><Left>')
map('v', '<Leader>S', ":s//g<Left><Left>")

map('v', '<Leader>y', '"+y')

-- `git blame` the current line
map('n', '<M-b>', ":execute \":!git blame % -L \" . line('.') . \",\" . line('.')<CR>", { silent = true })

-- Goto definition
map('n', '<M-g>', vim.lsp.buf.definition)
