runtime! debian.vim

if has("syntax")
  syntax on
endif

colorscheme slate

filetype plugin indent on

augroup all
    autocmd BufRead,BufNewFile * setlocal signcolumn=yes
augroup END

set number              " show line numbers
set relativenumber      " relative line numbers
set hidden              " allow unsaved buffers to be hidden
set updatetime=300      " faster completion (default is 4000ms)
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set incsearch          " Incremental search
set autowrite          " Automatically save before commands like :next and :make

set guicursor=
set guifont=Ubuntu

set shellcmdflag=-c
set completeopt+=noselect
set tabstop=4
set shiftwidth=4
set nowrap
set expandtab 
set background=dark
set shortmess=atT
set lazyredraw mouse=a cursorline
set clipboard+=unnamedplus
set laststatus=2
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P


" insert mode mappings ------------------------------------------------------
inoremap jj <Esc>

" normal mode mappings -------------------------------------------------------

" Reload the file from disk (forced so edits will be lost)
nnoremap <silent> <leader>r :edit!<CR>
" add a space in normal mode
nnoremap <silent> <space> i<space><esc>
" call the bufkill plugin commad to delete buffer form list
nnoremap <silent> <leader>q :bdelete<CR>
nnoremap <silent> <leader>qq :bdelete!<CR>
" delete all buffers
nnoremap <silent> <leader>qa :bd *<C-a><CR>
" write file (save)
nnoremap <silent> <leader>w :w!<CR>

" close the preview window with leader p
nnoremap <silent> <leader>p :pclose<CR>

" in normal mode, the arrow keys will move tabs
nnoremap <silent> <Left> :bprevious!<CR>
nnoremap <silent> <Right> :bnext!<CR>
nnoremap <silent> <Down> <C-d>
nnoremap <silent> <Up> <C-u>

" moving windows with option arrow
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-l> :wincmd l<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-h> :wincmd h<CR>

" inserting newline without entering insert
nnoremap _ O<Esc>
nnoremap - o<Esc>

" quickfix window commands
nnoremap <silent> <leader>/ :copen<CR>:wincmd k<CR>
nnoremap <silent> <leader>// :cclose<CR>
nnoremap <silent> <leader>. :cnext<CR>
nnoremap <silent> <leader>, :cprevious<CR>

nnoremap <leader><leader> :buffers<CR>:buffer<Space>

" jump to quickfix current error number
nnoremap <silent> <leader>.. :cc<CR>
" insert the UTC date at the end of the line Sun May 13 13:06:42 UTC 2018
nnoremap <silent> <leader>x :r! date -u "+\%Y-\%m-\%d \%H:\%M:\%S.000+00"<CR>k<S-j>h

" VISUAL MODE MAPPINGS ------------------------------------------------

" in visual mode, arrows will move text around
vnoremap <silent> <Left> <gv
vnoremap <silent> <Right> >gv
vnoremap <silent> <Up> :m.-2<CR>gv
vnoremap <silent> <Down> :m '>+1<CR>==gv

" toggle highlighting after search

map  <silent> <leader>h :noh<CR>
imap <silent> <leader>h <ESC>:noh<CR>a
vmap <silent> <leader>h <ESC>:noh<CR>gv

" HIGHLIGHTING ----------------------------------------------------------------

" link is not working in tmux for some reason on the LineNr and SignColumn
hi DiagnosticSignError guifg=#CC6666 guibg=NONE
hi DiagnosticSignWarn guifg=#FFCB6B guibg=NONE
hi DiagnosticSignHint guifg=#FFCB6B guibg=NONE
hi DiagnosticSignInfo guifg=#FFCB6B guibg=NONE
