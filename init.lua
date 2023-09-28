--
-- NeoVim configuration
--
local o = vim.o				-- global options
local wo = vim.wo			-- window scope options
local bo = vim.bo			-- buffer scope options
local fn = vim.fn
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local map = vim.api.nvim_set_keymap

wo.number = true

o.mouse = 'a'
o.colorcolumn = '80'

opt.splitbelow = true
opt.splitright = true

opt.tabstop = 2         -- number of spaces tabs count for
opt.expandtab = true    -- using spaces instead of tabs
opt.shiftwidth = 2      -- size of an indent

opt.termguicolors = true
--cmd "colo PaperColor"
--cmd "colo juliana"
cmd "colo github_dark"

g.mapleader = ','

-- Mappings
map('n', '<C-l>', '<cmd>noh<CR>', {})

-- Emacs keybindings
map('i', '<c-a>', '<Home>', {})
map('i', '<c-e>', '<End>', {})
map('i', '<c-k>', '<Esc>d$i', {})
map('i', '<c-b>', '<Esc>i', {})
map('i', '<c-f>', '<Esc>lli', {})

-- netrw
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 4
g.netrw_altv = 1
g.netrw_winsize = 25

-- removing traling whitespaces on save
cmd [[au BufWritePre * :%s/\s\+$//e]]

-- open a terminal pane on the right using :Term
cmd [[command Term :botright vsplit term://$SHELL]]
-- Terminal visual tweaks
cmd [[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufLeave term://* stopinsert
]]
-- Esc for terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.api.nvim_set_hl(0, 'Comment', { italic=true, fg='grey' })

--== Plugins configuration
-- Telescope
map('n', '<Leader>ff',[[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]] , {noremap = true})
map('n', '<leader>bb', [[<cmd>lua require('telescope.builtin').buffers({previewer = false})<CR>]], {noremap = true})
map('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep({})<CR>]], {noremap = true})

-- nvim-lspconfig
local lspconfig = require('lspconfig')
lspconfig.tsserver.setup {}
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- lualine
require('lualine').setup()

-- coc.nvim
-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
-- Use <c-j> to trigger snippets
vim.keymap.set("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
