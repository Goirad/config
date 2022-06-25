" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'jremmen/vim-ripgrep'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'iCyMind/NeoSolarized'
Plug 'morhetz/gruvbox'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rhysd/conflict-marker.vim'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

Plug 'terryma/vim-smooth-scroll'
" Plug 'jiangmiao/auto-pairs'
Plug 'stephpy/vim-yaml'
Plug 'cespare/vim-toml'
Plug 'vimwiki/vimwiki'
" Inatialize plugin system
call plug#end()

set hidden
set signcolumn=yes

call deoplete#custom#option({
    \ 'auto_refresh_delay': 100,
    \ })
"let g:LanguageClient_useVirtualText='All'
let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')
let g:LanguageClient_loggingLevel = 'WARN'
let g:LanguageClient_serverCommands = {
    \ 'rust': {
    \   'name': 'rust-analyzer',
    \   'command': ['rust-analyzer'],
    \   'initializationOptions': {
    \     "cargo": {
    \       "loadOutDirsFromCheck": v:true,
    \     },
    \     "procMacro": {
    \       "enable": v:false,
    \     },
    \   },
    \ },
    \}
let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown'}]
let g:vimwiki_auto_header = 1

set termguicolors
colorscheme gruvbox
"silent! colorscheme NoSolarized
set background=dark

set number
set relativenumber
set expandtab
set shiftwidth=4
set cursorline
set cursorcolumn
set colorcolumn=80
command! Date :r !~/.config/scripts/date.sh
nnoremap <C-p> :FZF <CR>
nnoremap <C-j> :Buffers <CR>
nnoremap <M-b> :execute ":!git blame % -L " . line('.') . "," . line('.')<CR>
" Quick find and replace
nnoremap S :%s//g<Left><Left>

" Goto definition
nnoremap <M-g> :call LanguageClient#textDocument_definition() <CR>
" Explain error
nnoremap <M-e> :call LanguageClient#explainErrorAtPoint() <CR>

" Easier escaping
inoremap <C-Space> <Esc>

" Moving through splits
nnoremap <M-h> <C-w>h
nnoremap <M-l> <C-w>l
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
inoremap <M-h> <C-w>h
inoremap <M-l> <C-w>l
inoremap <M-j> <C-w>j
inoremap <M-k> <C-w>k

" Moving through buffers
nnoremap <C-M-h> :bp<CR>
nnoremap <C-M-l> :bn<CR>
set list

let g:deoplete#enable_at_startup=1

set updatetime=100
set diffopt+=iwhite

autocmd bufreadpre,bufnewfile *.wiki setlocal textwidth=80
autocmd bufreadpre *.md   setlocal textwidth=80


" Smooth Scroll bindings

nnoremap <silent> <c-u> :call smooth_scroll#up(&scroll, 10, 2)<CR>
nnoremap <silent> <c-d> :call smooth_scroll#down(&scroll, 10, 2)<CR>
nnoremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
nnoremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>
