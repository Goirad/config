let g:python3_host_prog='/usr/bin/python3'

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'iCyMind/NeoSolarized'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'rhysd/conflict-marker.vim'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

Plug 'terryma/vim-smooth-scroll'
" Plug 'jiangmiao/auto-pairs'
Plug 'stephpy/vim-yaml'
Plug 'cespare/vim-toml'
" Inatialize plugin system
call plug#end()

set hidden
set signcolumn=yes
let g:LanguageClient_useVirtualText=1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'nightly', 'rls'],
    \ }
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts=1

set termguicolors
silent! colorscheme NeoSolarized
set background=dark

set number
set relativenumber
set expandtab
set shiftwidth=4

nnoremap <C-p> :FZF <CR>
nnoremap <M-b> :execute ":!git blame % -L " . line('.') . "," . line('.')<CR>

" Indenting in normal mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<

" Easier escaping
inoremap <C-Space> <Esc>

" Moving through splits
nnoremap <M-h> <C-w>h<CR>
nnoremap <M-l> <C-w>l<CR>
inoremap <M-h> <C-w>h<CR>
inoremap <M-l> <C-w>l<CR>


set list

let g:deoplete#enable_at_startup=1

set updatetime=100



" Smooth Scroll bindings

nnoremap <silent> <c-u> :call smooth_scroll#up(&scroll, 10, 2)<CR>
nnoremap <silent> <c-d> :call smooth_scroll#down(&scroll, 10, 2)<CR>
nnoremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
nnoremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>
