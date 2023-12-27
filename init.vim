scriptencoding utf-8

" disable python 2
let g:loaded_python_provider = 0
let g:denops#debug = 0
let g:python3_host_prog='/c2/jeff/anaconda3/envs/neovim/bin/python'
let $PATH='/c2/jeff/anaconda3/envs/neovim/bin:' . $PATH

augroup vimplug
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
augroup END

" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'rcarriga/nvim-notify'
Plug 'MunifTanjim/nui.nvim'
Plug 'folke/noice.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" autocompleter and sources, filters ----------------------
Plug 'Shougo/ddc.vim'
Plug 'Shougo/pum.vim'
Plug 'vim-denops/denops.vim'

"install your sources
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/ddc-around'
Plug 'Shougo/ddc-source-lsp'
Plug 'tani/ddc-path'
Plug 'Shougo/ddc-rg'
Plug 'Shougo/ddc-ui-pum'
Plug 'matsui54/ddu-source-file_external'

" install your filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
" autocompleter done --------------------------------------


" ddu (denite replacement?) ------------------------------
Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-kind-file'
Plug 'Shougo/ddu-filter-matcher_substring'
Plug 'yuki-yano/ddu-filter-fzf'
Plug 'shun/ddu-source-buffer'
Plug 'Shougo/ddu-ui-ff'
Plug 'shun/ddu-source-rg'
Plug 'Shougo/ddu-source-file_rec'
" ddu done ----------------------------------------------

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'chriskempson/base16-vim'
Plug 'vim-python/python-syntax'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'

call plug#end()

lua require('init')

" :call ToggleVerbose() for writing a verbose log im tmp
function! ToggleVerbose()
    if !&verbose
        set verbosefile=/home/jeff/.tmp/vim.log
        set verbose=9
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

function! StartProfile()
    :profile start ~/vim-profile.log
    :profile func *
    :profile file *
endfunction

function! StopProfile()
    :profile stop
endfunction

" setting syntax and making colors better
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax on
filetype plugin indent on
" syntax for lua
let g:vimsyn_embed= 'l'

augroup all
    autocmd BufRead,BufNewFile * setlocal signcolumn=yes
augroup END

" set neovim to have normal vim cursor, guicursor& to restore default
set guicursor=
set guifont=DroidSansMono\ Nerd\ Font\ 11
" make sure I can call stuff defined in my bash_profile
set shellcmdflag=-c
set completeopt+=noselect
set number tabstop=4 shiftwidth=4 nowrap expandtab termguicolors background=dark hidden shortmess=atT
set lazyredraw mouse=a directory=~/.config/nvim/tmp cursorline
set clipboard+=unnamedplus
set laststatus=2
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P


" vim airline ------------------------------------------------------------------------
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'

" called in the startup section after everything has loaded (this is hacky)
function! ChangeColors()
    hi airline_tabmod_unsel guifg=#61afef guibg=#2c323c
endfunction

" refresh the .vimrc on a save so vim does not have to be restarted
augroup startup
    autocmd!
    " sourcing the vimrc on save of this file.
    autocmd BufWritePost init.lua luafile ~/.config/nvim/lua/init.lua
    autocmd BufWritePost *.vim so $MYVIMRC | :AirlineRefresh | :call ChangeColors()
    autocmd FileType gitcommit setlocal cc=72 tw=72
    autocmd BufEnter *.md,*.mdx setlocal tw=120
    autocmd VimEnter * call ChangeColors()
augroup END

" vim fugitive --------------------------------------------------
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gl :Git --no-pager log<CR>
" when cvc (git verbose commit) is called from status and there is too much
" diff to see on the screen, a new buffer can be opened to compose the diff
" message while scrolling through the diff.
nnoremap <leader>n :new<CR>:resize -40<CR>
" for looking at diffs from the status window. left window is index, right
" window is the current file. push or get the changes to the other file while
" the curor is on the line. the file must be saved after this
nnoremap <leader>dg :diffget<CR>
nnoremap <leader>dp :diffpush<CR>
" after running arbitraty git commands like :Git log, there is a tab and an
" extra buffer
nnoremap <leader>tc :bdelete!<CR>:tabclose<CR>

" auto pairs ----------------------------------------------------------------------------

" do not make the line in the center of the page after pressing enter
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCR = 1

" Python
" ---------------------------------------------------------------------------------------
let g:python_highlight_all = 1

augroup python
    autocmd!
    autocmd FileType python set tabstop=4 shiftwidth=0 expandtab
    autocmd BufWritePre *.py lua vim.lsp.buf.format({ async = true })
augroup END

" ddc setup ----------------------------------------------------------------
" https://github.com/Shougo/ddc.vim

call ddc#custom#patch_global('ui', 'pum')
call pum#set_option({'border': 'rounded'})

inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>

inoremap <silent><expr> <TAB>
\ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

call ddc#custom#patch_global('sources', ['lsp', 'around', 'rg', 'path'])

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_fuzzy'],
      \   'sorters': ['sorter_fuzzy'],
      \   'converters': ['converter_fuzzy']
      \ },
      \ 'rg': {'mark': 'rg', 'minAutoCompleteLength': 4,},
      \ 'tmux': {'mark': 'T'},
      \ 'path': {'mark': 'P'},
      \ 'lsp': {
      \     'mark': 'lsp',
      \     'forceCompletionPattern': '\.\w*|:\w*|->\w*',
      \     'minAutoCompleteLength': 1
      \ },
      \ })

call ddc#custom#patch_global('sourceParams', {
      \    'path': {'cmd': ["fd", "--max-depth", "5"] },
      \ })

" Use ddc.
call ddc#enable()

" ddu settings -----------------------------------------------------------

" You must set the default ui.
" Note: ff ui
" https://github.com/Shougo/ddu-ui-ff
call ddu#custom#patch_global({
    \ 'ui': 'ff',
    \ 'uiParams': {'ff': {'split': 'floating', 'winHeight': 35, 'floatingBorder': 'rounded'}}
    \ })

" You must set the default action.
" Note: file kind
" https://github.com/Shougo/ddu-kind-file
call ddu#custom#patch_global({
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   }
    \ })

" Specify matcher.
" Note: matcher_substring filter
" https://github.com/Shougo/ddu-filter-matcher_substring


call ddu#custom#patch_global({
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_fzf', 'matcher_substring'],
    \     },
    \   }
    \ })

call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'rg' : {
    \       'args': ['--column', '--no-heading', '--color', 'never'],
    \       'highlights': 'Search',
    \     },
	\     'file_external': {
	\       'cmd': [
    \         'fd', '.', '--hidden', '--ignore-case', '--max-depth', '10',
    \         '--exclude', '__pycache__', '--exclude', '.git', '--exclude', '*.pyc',
    \         '--exclude', '.mypy_cache', '--type', 'f'
    \        ],
	\     },
    \   },
    \ })

call ddu#custom#patch_global({
    \   'filterParams': {
    \     'matcher_substring': {
    \       'highlightMatched': 'Search',
    \     },
    \     'matcher_matchfuzzy': {
    \       'highlightMatched': 'Search',
    \       'limit': 100,
    \       'matchseq': v:true,
    \     }
    \   }
    \ })

function! s:ddu_rg_live() abort
  call ddu#start({
        \   'sources': [{
        \     'name': 'rg',
        \     'options': {'matchers': [], 'volatile': v:true},
        \   }],
        \   'uiParams': {'ff': {
        \     'ignoreEmpty': v:false,
        \     'autoResize': v:false,
        \   }},
        \ })
endfunction

autocmd FileType ddu-ff call s:ddu_ff_my_settings()
function! s:ddu_ff_my_settings() abort
  nnoremap <buffer> <CR>
  \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> d
  \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'delete'})<CR>
  nnoremap <buffer> <Space>
  \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer> i
  \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer> q
  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer> <CR>
  \ <Esc><Cmd>call ddu#ui#ff#do_action('closeFilterWindow')<CR>
  nnoremap <buffer> <CR>
  \ <Esc><Cmd>call ddu#ui#ff#do_action('closeFilterWindow')<CR>
endfunction

" open list of buffers, open directory for seatch, search for test in files (rg)
nnoremap <leader><leader> <Cmd>call ddu#start({'sources': [{'name': 'buffer'}]})<CR>
nnoremap <leader><Space> <Cmd>call ddu#start({'sources': [{'name': 'file_external'}]})<CR>
nnoremap <leader><Space><Space> <Cmd>call <SID>ddu_rg_live()<CR>


nnoremap <silent> <leader>[ :NvimTreeToggle<CR>

" insert mode mappings ------------------------------------------------------
" maps jj to escape to get out of insert mode
inoremap jj <Esc>
" for some reason Shift or Control is not working <Del> if fn+backspace
inoremap <Del> <C-W>

" terminal mode mappings -----------------------------------------------------

augroup terminal
  autocmd TermOpen * set bufhidden=hide
  " commenting to see if it fixes problem with going to insert on the other
  " non terminal buffers
  "autocmd BufEnter term://* startinsert
augroup END

" when in the terminal, use the jj commands to get out of insert
tnoremap jj <C-\><C-n>
" enter a buffer name after file so that the user can rename the terminal
" buffer and keep track of multiple terminals
nnoremap <leader>tn :keepalt file

" normal mode mappings -------------------------------------------------------

" setup terminals with gpustat and htop
function! HtopAndGpuStat()
    call feedkeys(":terminal\<CR>i gpustat -i 0.5 -cu\<CR>\<C-\>\<C-n>\:file gpustat\<CR>")
    call feedkeys(":terminal\<CR>i htop\<CR>\<C-\>\<C-n>\:file htop\<CR>")
endfunction

" copy the current buffer filepath into the clipboard
nnoremap <silent> <leader>cp :let @+ = expand("%:p")<CR>
" open two terminals and let the user name them
nnoremap <silent> <leader>sh :terminal<CR>i . ~/.bash_profile<CR><C-\><C-n>:keepalt file
" Reload the file from disk (forced so edits will be lost)
nnoremap <silent> <leader>r :edit!<CR>
" open a terminal, source bash profile and let user name it
nnoremap <silent> <leader>te :terminal<CR>i . ~/.bash_profile<CR><C-\><C-n>:keepalt file
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

" location list open, close, next, previous wincmd's make it so that the cursor goes back to the main buffer
nnoremap <silent> <leader>' :TroubleToggle<CR>
nnoremap <silent> <leader>'' :lclose<CR>
nnoremap <silent> <leader>; :lnext<CR>
nnoremap <silent> <leader>l :lprev<CR>
" jump to the current error
nnoremap <silent> <leader>;; :ll<CR>
" quickfix window commands
nnoremap <silent> <leader>/ :copen<CR>:wincmd k<CR>
nnoremap <silent> <leader>// :cclose<CR>
nnoremap <silent> <leader>. :cnext<CR>
nnoremap <silent> <leader>, :cprevious<CR>
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

" quickfix window settings -------------------------------------------------

" This trigger takes advantage of the fact that the quickfix window can be
" easily distinguished by its file-type, qf. The wincmd J command is
" equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" the very bottom (see :help :wincmd and :help ^WJ).
augroup quickfix
    autocmd!
    autocmd! FileType qf setlocal wrap cc=
    autocmd! FileType qf wincmd J
augroup END

" toggle highlighting after search

map  <silent> <leader>h :noh<CR>
imap <silent> <leader>h <ESC>:noh<CR>a
vmap <silent> <leader>h <ESC>:noh<CR>gv

" Highlight the highlight group name under the cursor
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

map fhi <Cmd>call SynStack()<CR>
"
" HIGHLIGHTING ----------------------------------------------------------------

" link is not working in tmux for some reason on the LineNr and SignColumn

hi DiagnosticSignError guifg=#CC6666 guibg=NONE
hi DiagnosticSignWarn guifg=#FFCB6B guibg=NONE
hi DiagnosticSignHint guifg=#FFCB6B guibg=NONE
hi DiagnosticSignInfo guifg=#FFCB6B guibg=NONE

" hi DiffChange guifg=#b294bb guibg=#373737
" hi DiffText guifg=#8abeb7 gui=bold guibg=#373737
" hi DiffAdd guifg=#b5bd68 guibg=#373737
" hi DiffDelete gui=bold guifg=#cc6666 guibg=#373737
" ---------------------------------------------------------------
