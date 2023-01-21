-- NB these are relative to `.config/nvim/lua/`
require('settings')
require('keymaps')

-- packer bootstrapping
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'morhetz/gruvbox'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'vimwiki/vimwiki'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    indent = {
        enable = false,
    }
  }
  use 'terryma/vim-smooth-scroll'
  use 'airblade/vim-gitgutter'

  use 'aklt/plantuml-syntax'
  -- required for plantuml-previewer
  use 'tyru/open-browser.vim'
  use 'weirongxu/plantuml-previewer.vim'
  use 'dense-analysis/ale'
  use 'rhysd/conflict-marker.vim'
  use 'preservim/vim-markdown'
  use 'neovim/nvim-lspconfig'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

vim.cmd[[colorscheme gruvbox]]
vim.opt.background = "dark"

-- Smooth Scroll bindings
map('n', '<c-u>', ':call smooth_scroll#up(&scroll, 10, 2)<CR>', { silent = true })
map('n', '<c-d>', ':call smooth_scroll#down(&scroll, 10, 2)<CR>', { silent = true })
map('n', '<c-b>', ':call smooth_scroll#up(&scroll*2, 10, 4)<CR>', { silent = true })
map('n', '<c-f>', ':call smooth_scroll#down(&scroll*2, 10, 4)<CR>', { silent = true })

vim.g.vimwiki_list = {{ path = '~/vimwiki/', syntax = 'markdown' }}
vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_auto_header = 1

vim.g.airline_theme = 'gruvbox'
vim.g.airline_powerline_fonts = 1
vim.g.ale_fixers = { ['*'] = {'remove_trailing_lines', 'trim_whitespace'} }
vim.g.ale_fix_on_save = 1

vim.g['plantuml_previewer#plantuml_jar_path'] = vim.fn.expand('~/Downloads/plantuml.jar')
vim.api.nvim_create_autocmd({ "bufreadpre", "bufnewfile" },  {
  pattern = {"*.wiki", "*.md"},
  callback = function()
    vim.opt_local.textwidth = 80
  end
})

map('n', '<C-p>', require('telescope.builtin').find_files)
map('n', '<leader>fg', require('telescope.builtin').live_grep)
map('n', '<C-j>', require('telescope.builtin').buffers)
map('n', '<leader>fh', require('telescope.builtin').help_tags)
map('n', '<leader>fr', require('telescope.builtin').lsp_references)

local cmp = require('cmp')
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm
    -- explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' }
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
end

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig').rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities
}
