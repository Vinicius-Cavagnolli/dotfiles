" ========================================
" Basic Settings
" ========================================
set nocompatible              " Disable legacy Vi compatibility
syntax on                     " Enable syntax highlighting
filetype plugin indent on     " Enable filetype detection and indentation

" UI
set number                    " Show line numbers
set cursorline                " Highlight current line
set nowrap                    " Don't wrap long lines

" Tabs and Indentation
set expandtab                 " Use spaces instead of tabs
set autoindent                " Copy indent from current line
set smartindent               " Smart autoindenting for code
set tabstop=4                 " Number of spaces per tab
set shiftwidth=4              " Indent by 4 spaces

" Behavior
set clipboard=unnamed         " Use system clipboard
set backspace=indent,eol,start

" ========================================
" Keybindings
" ========================================
let mapleader = ","

" File operations
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>e :e<Space>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bd<CR>

" ========================================
" Plugins
" ========================================
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" ========================================
" ALE
" ========================================
let g:ale_linters = {
\   'python': ['flake8', 'mypy', 'pylint'],
\}
let g:ale_fixers = {
\   'python': ['black'],
\}
let g:ale_fix_on_save = 1

nnoremap <leader>l :ALELint<CR>
" Skip <leader>f for ALE to avoid conflict with CoC
" nnoremap <leader>f :ALEFix<CR>

" ========================================
" CoC
" ========================================
" Autocompletion
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" LSP features
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <leader>rn <Plug>(coc-rename)
nnoremap <leader>ca <Plug>(coc-codeaction)
nnoremap <leader>d :CocList diagnostics<CR>
nnoremap <leader>o :CocList outline<CR>
nnoremap <leader>r :CocList references<CR>
nnoremap <leader>s :CocList -I symbols<CR>
nnoremap <leader>i :CocList implementations<CR>
nnoremap <leader>t :CocList typeDefinitions<CR>

" Formatting with CoC
xmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cf <Plug>(coc-format-selected)

" ========================================
" fzf
" ========================================
nnoremap <leader>p :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>l :Lines<CR>

" Use ripgrep (rg) with fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
