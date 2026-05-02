--
--
--
-- NeoVim configuration
--

-- Useful commands:
-- :g/^$/d: Delete blank lines



-- Starting conf
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
map('i', '<c-y>', '<Esc>pi', {})

-- Emacs keybindings for command mode
map('c', '<c-a>', '<Home>', { noremap= true } )
map('c', '<c-b>', '<Left>', { noremap= true })
map('c', '<c-d>', '<Del>', { noremap= true })
map('c', '<c-e>', '<End>', { noremap= true })
map('c', '<c-f>', '<Right>', { noremap= true })

-- Find merge conflict markers
map('n', '<leader>fc', [[:/\v^[<|=>]{7}( .*\|$)<CR>]], { noremap = true, silent = true })

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
cmd [[ hi VertSplit guibg=#ff0000 ]]
--cmd [[ hi VertSplit cterm=NONE ctermfg=Green ctermbg=NONE ]]

-- yank to system clipboard
vim.api.nvim_set_option("clipboard","unnamed")

-- open nvim configuration file
--map('n', '<leader>c', ':e ~/.config/nvim/init.lua<CR>', {})

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- CopilotChat: Auto-command to customize chat buffer behavior
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'copilot-*',
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})

-- Custom functions

-- Insert current week number
function InsertCurrentWeek()
  -- Get the current date/time as a timestamp
  local now_timestamp = os.time()

  -- Get a table with date components for the current time
  local now_table = os.date("*t", now_timestamp)

  -- os.date("*t").wday returns weekday as a number (Sunday is 1, Monday is 2, ..., Saturday is 7)
  local current_wday = now_table.wday

  -- Calculate the number of days to subtract to get to Monday.
  -- If today is Monday (wday=2), days_to_subtract is 0.
  -- If today is Sunday (wday=1), days_to_subtract is 6 (to go back to previous Monday).
  local days_to_subtract
  if current_wday == 1 then
      -- If Sunday, go back 6 days to Monday
      days_to_subtract = 6
  else
      -- For other days, subtract (wday - 2) days
      days_to_subtract = current_wday - 2
  end

  -- Calculate timestamp for the start of the week (Monday)
  -- 86400 seconds in a day
  local start_of_week_timestamp = now_timestamp - (days_to_subtract * 86400)

  -- Calculate timestamp for the end of the week (Sunday)
  -- Add 6 days (6 * 86400 seconds) to the start of the week timestamp
  local end_of_week_timestamp = start_of_week_timestamp + (6 * 86400)

  -- Format the timestamps into readable date strings
  local start_date_str = os.date("%Y-%m-%d", start_of_week_timestamp)
  local end_date_str = os.date("%Y-%m-%d", end_of_week_timestamp)

  local week_number = os.date("%V")
  vim.api.nvim_put({"Week " .. week_number .. " --- " .. start_date_str .. " - " .. end_date_str}, 'c', true, true)
end
vim.api.nvim_create_user_command(
  'InsertCurrentWeek',
  InsertCurrentWeek,
  {}
)

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
            "dockerfile", "bash", "hcl", "terraform", "markdown", "elixir",
            "gleam"
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
    -- `pyright` can't format files so using `black` external plugin
    'psf/black'
  },
  {
    -- <leader><leader>w and <leader><leader>b
    'easymotion/vim-easymotion'
  },
  {
  "coffebar/neovim-project",
    opts = {
      projects = { -- define project roots
        "~/github/HerbalifeHub/*",
      },
      picker = {
        type = "telescope", -- one of "telescope", "fzf-lua", or "snacks"
      }
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- optional picker
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      -- optional picker
      { "ibhagwan/fzf-lua" },
      -- optional picker
      { "folke/snacks.nvim" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
    keys = {
      {'<Leader>r', "<cmd>NeovimProjectDiscover<CR>", "noremap=true"},
    }
  },
  {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    keys = {
      {'<C-e>', "<cmd>Neotree toggle<CR>", "noremap=true"},
    }
  },
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false,
        },
        panel = {
          enabled = false
        },
        filetypes = {
          markdown = true,
          help = true,
          html = true,
          javascript = true,
          typescript = true,
          ["*"] = true
        },
      })

      vim.keymap.set("i", '<Tab>', function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n", false)
        end
      end, {
          silent = true,
        })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    keys = {
      {'<Leader>c', "<cmd>CopilotChatToggle<CR>", "noremap=true"},
    }
    ,
    build = "make tiktoken",
    opts = {
      --window = {
      --  layout = 'float',
      --  width = 80, -- Fixed width in columns
      --  height = 20, -- Fixed height in rows
      --  border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
      --  title = '🤖 AI Assistant',
      --  zindex = 100, -- Ensure window stays on top
      --},

      auto_insert_mode = true,

      headers = {
        user = '👤 You',
        assistant = '🤖 Copilot',
        tool = '🔧 Tool',
      },

      separator = '━━',
      auto_fold = true,
      highlight_headers = false,
      error_header = '> [!ERROR] Error',
   },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function ()
      require('render-markdown').setup({
        file_types = { 'markdown', 'copilot-chat' },
      })
    end,
  },
  {
  "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    telescope = true,
    config = function()
      -- vim.cmd("colorscheme base16-terracotta-dark")
    end,
  },
  {
    'stevearc/aerial.nvim',
     opts = {},
     dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
     },
    config = function ()
      require("aerial").setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    end,
  },
  {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.9.1',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'default' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
},
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      vim.lsp.config('yamlls', {
        capabilities= { capabilities },
      })
      vim.lsp.enable('yamlls')

      vim.lsp.config('jsonls', {
        capabilities= { capabilities },
      })
      vim.lsp.enable('jsonls')

      vim.lsp.config('terraformls', {
        capabilities= { capabilities },
      })
      vim.lsp.enable('terraformls')

      vim.lsp.config('ts_ls', {
        capabilities= { capabilities },
      })
      vim.lsp.enable('ts_ls')

      vim.lsp.config('docker_language_server', {
        capabilities= { capabilities },
        filetypes = { 'dockerfile', 'Dockerfile', 'yaml.docker-compose' },
      })
      vim.lsp.enable('docker_language_server')

      vim.lsp.enable('pylsp', {
        capabilities= { capabilities },
      })
    end
  },
  {
  'nanozuki/tabby.nvim',
  },
  {
  "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "esmuellert/codediff.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    }
}

}) -- lazy.setup end
