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

g.mapleader = ','

-- Mappings
map('n', '<C-l>', '<cmd>noh<CR>', {})

-- Emacs keybindings for insert mode
map('i', '<c-a>', '<Home>', {})
map('i', '<c-e>', '<End>', {})
map('i', '<c-k>', '<Esc>d$i', {})
map('i', '<c-b>', '<Esc>i', {})
map('i', '<c-f>', '<Esc>lli', {})

-- Emacs keybindings for command mode
map('c', '<c-a>', '<Home>', { noremap= true } )
map('c', '<c-b>', '<Left>', { noremap= true })
map('c', '<c-d>', '<Del>', { noremap= true })
map('c', '<c-e>', '<End>', { noremap= true })
map('c', '<c-f>', '<Right>', { noremap= true })

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

-- vertical split bar style
cmd [[ hi VertSplit guibg=#a3a3a3 ]]

-- yank to system clipboard
vim.api.nvim_set_option("clipboard","unnamed")

-- open nvim configuration file
map('n', '<leader>c', ':e ~/.config/nvim/init.lua<CR>', {})

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)


-- Plugins managed by lazy.vim: https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('lualine').setup()
    end
  },
  { 'projekt0n/github-nvim-theme', lazy = false, priority = 1000,
    config = function()
      require('github-theme').setup({
        options = {
          styles = {
            comments = 'italic',
            keywords = 'bold',
            types = 'italic,bold',
          }
        }
      })
      vim.cmd('colorscheme github_dark')
    end
  },
  {
    'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {'<Leader>ff', "<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>", "noremap=true"},
      {'<leader>bb', "<cmd>lua require('telescope.builtin').buffers({previewer = false})<CR>", "noremap=true"},
      {'<leader>fg', "<cmd>lua require('telescope.builtin').live_grep({})<CR>", "noremap=true"}
    }
  },
  {
    'tpope/vim-fugitive',
    keys = {
      {'<Leader>gd', ':Git diff<CR>'}
    }
  },
  {
    "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
          ensure_installed = {
            "lua", "vim", "vimdoc", "javascript", "typescript", "python",
            "dockerfile", "bash", "hcl", "terraform", "markdown",
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },
      })
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ', 'hrsh7th/cmp-vsnip' },
    config = function ()
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
      }
    end
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require'lspconfig'.pyright.setup{
        capabilities = capabilities,
      }
      require'lspconfig'.jsonls.setup {
        capabilities = capabilities,
      }
      require('lspconfig').yamlls.setup {
        capabilities = capabilities,
      }
      require('lspconfig').terraformls.setup {
        capabilities = capabilities,
      }
      require('lspconfig').powershell_es.setup {
        capabilities = capabilities,
        bundle_path = "~/.local/share/pwsh-editor-services",
      }

    end
  },
  {
    -- `pyright` can't format files so using `black` external plugin
    'psf/black'
  },
  {
    -- <leader><leader>w and <leader><leader>b
    'easymotion/vim-easymotion'
  }
})
