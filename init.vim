scriptencoding utf-8

" disable python 2
let g:loaded_python_provider = 0

if has('mac')
    let g:python3_host_prog = '/Users/Jeff/.venv/neovim/bin/python'
    let g:node_host_prog = '/usr/local/bin/neovim-node-host'
    let g:ruby_host_prog = '/usr/local/bin/neovim-ruby-host'
    let $NVIM_NODE_LOG_FILE='/tmp/nvim-node.log'
    let $NVIM_NODE_LOG_LEVEL='error'
    let $NVIM_PYTHON_LOG_FILE='/tmp/nvim-python.log'
    let $NVIM_PYTHON_LOG_LEVEL='info'
    " if this is uncommented, vim will freeze and you have to go into the
    " chromer dev console and click the green button and hit run on the
    " debugger
    "let $NVIM_NODE_HOST_DEBUG=1
elseif $WORKPLACE == 'KAIST'
    " this is for KAIST ai servers
    let g:python3_host_prog='/st1/jeff/.venv/nvim/bin/python'
    let $NVIM_PYTHON_LOG_FILE='/st1/jeff/.tmp/nvim-python.log'
    let $NVIM_PYTHON_LOG_LEVEL='info'
else
    " right now this is for linux a server without node stuff, if I want to
    " handle a linux environment that I control as well, then something will
    " have to change
    let g:python3_host_prog = '/home/jeff/.venv/neovim/bin/python'
    let $NVIM_PYTHON_LOG_FILE='/home/jeff/tmp/nvim-python.log'
    let $NVIM_PYTHON_LOG_LEVEL='info'
endif

augroup vimplug
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
augroup END

" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdtree'

" autocompleter and sources, filters ----------------------
Plug 'Shougo/pum.vim'
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'

" install your sources
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/ddc-around'
Plug 'Shougo/ddc-rg'
Plug 'statiolake/ddc-ale'
Plug 'delphinus/ddc-tmux'
Plug 'tani/ddc-path'
Plug 'Shougo/ddc-omni'

" install your filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
" autocompleter done --------------------------------------

" ddu (denite replacement?) ------------------------------
Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-kind-file'
Plug 'Shougo/ddu-filter-matcher_substring'
Plug 'shun/ddu-source-buffer'
Plug 'Shougo/ddu-ui-ff'
Plug 'shun/ddu-source-rg'
Plug 'Shougo/ddu-source-file_rec'
" ddu done ----------------------------------------------

Plug 'Shougo/echodoc'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'vim-python/python-syntax'

Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-one'
Plug 'gosukiwi/vim-atom-dark'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', {'rtp': 'vim/'}

call plug#end()

" :call ToggleVerbose() for writing a verbose log im tmp
function! ToggleVerbose()
    if !&verbose
        set verbosefile=/home/jeff/tmp/vim.log
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

" setting syntax and makeing colors better
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax on
filetype plugin indent on
colorscheme base16-material-darker

" status line is filename and right aligned column number
" hidden makes the buffer hidden when inactvie rather than essentially 'closing' it
" I think there was a reason that this line is after the airline option, but IDK
augroup all
    autocmd BufRead,BufNewFile * setlocal signcolumn=yes
augroup END

" set neovim to have normal vim cursor, guicursor& to restore default
set guicursor=
" make sure I can call stuff defined in my bash_profile
set shellcmdflag=-c

set number tabstop=4 shiftwidth=4 nowrap noshowmode expandtab termguicolors background=dark hidden shortmess=atT
set lazyredraw mouse=a directory=~/.config/nvim/tmp cursorline
set clipboard+=unnamedplus
set laststatus=2
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P


" vim airline ------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='tomorrow'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s: '

" called in the startup section after everything has loaded (this is hacky)
function! ChangeColors()
    hi airline_tabmod_unsel guifg=#61afef guibg=#2c323c
endfunction

" refresh the .vimrc on a save so vim does not have to be restarted
augroup startup
    autocmd!
    " sourcing the vimrc on save of this file.
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

" ddc setup ----------------------------------------------------------------
" https://github.com/Shougo/ddc.vim


inoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>

call ddc#custom#patch_global('completionMenu', 'pum.vim')
" TODO: omni and path are giving errors as invalud sources, look into this
" when there is time
call ddc#custom#patch_global('sources', ['around', 'ale', 'rg', 'tmux'])

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \       'matchers': ['matcher_fuzzy'],
      \       'sorters': ['sorter_fuzzy'],
      \       'converters': ['converter_fuzzy']
      \   },
      \   'rg': {'mark': 'rg', 'minAutoCompleteLength': 4,},
      \   'tmux': {'mark': 'T'},
      \   'omni': {'mark': 'O'},
      \ })


call ddc#custom#patch_global('sourceParams', {
      \    'ale': {'cleanResultsWhitespace': v:true},
      \   'path': { 'mark': 'P', 'cmd': ['fd', '--max-depth', '5'] },
      \ })

inoremap <silent><expr> <TAB>
\ ddc#map#pum_visible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'

" Use ddc.
call ddc#enable()


" denite settings -----------------------------------------------------------

" You must set the default ui.
" Note: ff ui
" https://github.com/Shougo/ddu-ui-ff
call ddu#custom#patch_global({
    \ 'ui': 'ff',
    \ 'uiParams': {'ff': {'split': 'horizontal'}}
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
    \       'matchers': ['matcher_substring'],
    \     },
    \     'file_rec': {'path': getcwd()},
    \   }
    \ })

" \       'args': ['--column', '--no-heading', '--color', 'never'],
call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'rg' : {
    \       'args': ['--column', '--no-heading'],
    \     },
    \     'file_rec': {
    \       'ignoredDirectories': ["__pycache__", ".git", ".mypy_cache", "results"]
    \     }
    \   },
    \ })

call ddu#custom#patch_global({
    \   'filterParams': {
    \     'matcher_substring': {
    \       'highlightMatched': 'Search',
    \     },
    \   }
    \ })

function! s:ddu_rg_live() abort
  call ddu#start({
        \   'volatile': v:true,
        \   'sources': [{
        \     'name': 'rg',
        \     'options': {'matchers': []},
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
  \ <Esc><Cmd>close<CR>
  nnoremap <buffer> <CR>
  \ <Cmd>close<CR>
endfunction

" open list of buffers, open directory for seatch, search for test in files (rg)
nnoremap <leader><leader> <Cmd>call ddu#start({'sources': [{'name': 'buffer'}]})<CR>
nnoremap <leader><Space> <Cmd>call ddu#start({'sources': [{'name': 'file_rec'}]})<CR>
nnoremap <leader><Space>a <Cmd>call ddu#start({'sources': [{'name': 'file_rec', 'options': {'path': expand("~")}}]})<CR>
nnoremap <leader><Space><Space> <Cmd>call <SID>ddu_rg_live()<CR>


" ale ---------------------------------------------------------------------
"
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_fix_on_save = 1

" for some reason it wasn't finding my project config files with prettier_d
let g:ale_open_list = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_keep_list_window_open = 0
let g:ale_list_window_size = 2
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" I had to hack on the main typescript repo so I adde dthis to not run
" prettier on their code and mess up the formatting
let g:ale_pattern_options = {
  \ 'nvim-typescript': {'ale_fixers': ['tslint']},
  \ 'ContinualDBB': {'ale_fixers': [], 'ale_linters': []},
  \ 'SetEncoding': {'ale_fixers': [], 'ale_linters': []},
  \ 'set_transformer': {'ale_fixers': [], 'ale_linters': []},
  \ 'MiniBatchSetEncoding': {'ale_fixers': [], 'ale_linters': []},
  \ 'AI611-project': {'ale_fixers': [], 'ale_linters': []}
  \}

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'cpp': ['clang-format'],
  \ 'python': ['isort'],
  \}

let g:ale_linters = {
   \ 'vim': ['vint'],
   \ 'cpp': ['clang'],
   \ 'python': ['mypy', 'flake8'],
   \}

let g:ale_python_flake8_options = '--ignore E501,E203,W503,W605,E741,E127'
let g:ale_python_isort_options = '--skip __init__.py --filter-files'

" Python

let g:python_highlight_all = 1

let g:jedi#completions_enabled = 0 " use deoplete for completions, vim-jedi for other commands
let g:jedi#use_splits_not_buffers = 'top'
let g:jedi#goto_command = '<leader>g'
let g:jedi#goto_assignments_command = ''
let g:jedi#goto_definitions_command = '<leader>gd'
let g:jedi#documentation_command = '<leader>d'
let g:jedi#usages_command = '<leader>u'
let g:jedi#completions_command = ''
let g:jedi#rename_command = '<leader>rn'

augroup python
    autocmd!
    autocmd FileType python set tabstop=4 shiftwidth=0 expandtab
augroup END

" nerdtree settings ------------------------------------------------------------

nnoremap <leader>[ :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 50
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeAutoDeleteBuffer = 1

augroup nerdtree
    autocmd FileType nerdtree setlocal signcolumn=no modifiable
augroup END

" insert mode mappings ------------------------------------------------------
" maps jj to escape to get out of insert mode
inoremap jj <Esc>
" make Shift + Forward/Back skip by word in insert mode
inoremap <S-Right> <Esc>lwi
inoremap <S-Left> <Esc>bi
" for some reason Shift or Control is not working <Del> if fn+backspace
inoremap <Del> <C-W>
" call the autocomplete semantic completion when needed
inoremap ;; <C-x><C-o>

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

" copy the current buffer filepath into the clipboard
nnoremap <leader>cp :let @+ = expand("%:p")<CR>
" open two terminals and let the user name them
nnoremap <leader>sh :terminal<CR>i . ~/.bash_profile<CR><C-\><C-n>:keepalt file
" Reload the file from disk (forced so edits will be lost)
nnoremap <leader>r :edit!<CR>
" open a terminal, source bash profile and let user name it
nnoremap <leader>te :terminal<CR>i . ~/.bash_profile<CR><C-\><C-n>:keepalt file
" add a space in normal mode
nnoremap <space> i<space><esc>
" call the bufkill plugin commad to delete buffer form list
nnoremap <leader>q :bdelete<CR>
nnoremap <leader>qq :bdelete!<CR>
" delete all buffers
nnoremap <leader>qa :bd *<C-a><CR>
" write file (save)
nnoremap <leader>w :w!<CR>
" close the preview window with leader p
nnoremap <leader>p :pclose<CR>
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

" this complements the vim command <S-J> which joins current line to below line, this one breaks the current line in two
nnoremap K i<CR><Esc>
" location list open, close, next, previous wincmd's make it so that the cursor goes back to the main buffer
nnoremap <leader>' :lopen<CR>:wincmd k<CR>
nnoremap <leader>'' :lclose<CR>
nnoremap <leader>; :lnext<CR>
nnoremap <leader>l :lprev<CR>
" jump to the current error
nnoremap <leader>;; :ll<CR>
" quickfix window commands
nnoremap <leader>/ :copen<CR>:wincmd k<CR>
nnoremap <leader>// :cclose<CR>
nnoremap <leader>. :cnext<CR>
nnoremap <leader>, :cprevious<CR>
" jump to quickfix current error number
nnoremap <leader>.. :cc<CR>
" insert the UTC date at the end of the line Sun May 13 13:06:42 UTC 2018
nnoremap <leader>x :r! date -u "+\%Y-\%m-\%d \%H:\%M:\%S.000+00"<CR>k<S-j>h

" VISUAL MODE MAPPINGS ------------------------------------------------

" in visual mode, arrows will move text around
vnoremap <Left> <gv
vnoremap <Right> >gv
vnoremap <Up> :m.-2<CR>gv
vnoremap <Down> :m '>+1<CR>==gv

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

map  <leader>h :noh<CR>
imap <leader>h <ESC>:noh<CR>a
vmap <leader>h <ESC>:noh<CR>gv

" Highlight the highlight group name under the cursor
map fhi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" HIGHLIGHTING ----------------------------------------------------------------

" link is not working in tmux for some reason on the LineNr and SignColumn
hi LineNr guibg=#2d2d2d
hi SignColumn guibg=#2d2d2d
hi Normal guibg=#212121
hi Comment guifg=#595959
hi VertSplit ctermbg=NONE ctermfg=8 cterm=NONE guibg=NONE guifg=#3a3a3a gui=NONE
hi Visual ctermfg=7 ctermbg=8 guibg=#373737
hi Operator guifg=#E9E9E9
hi Type guifg=#E9E9E9
hi Boolean guifg=#e06c75
hi Search guibg=#0059b3 guifg=#ffffff
hi ColorColumn guibg=#2b2b2b
" to color the background of the vim-go testing errors
hi ErrorMsg guifg=#cc6666 guibg=NONE
" to color the errors in the gutter
hi Error guibg=NONE guifg=#cc6666
" to change the color of the autocomplete menu
hi Pmenu guifg=#a6a6a6 guibg=#373737
hi PmenuSel guifg=#4d4d4d guibg=#81a2be
" changes the color of the line number that the cursor is on
hi CursorLineNr gui=bold guifg=#81a2be
hi CursorLine guibg=#2d2d2d
" go methods only
hi goMethodCall guifg=#81a2be
hi jsFuncCall guifg=#81a2be
" changes them to stand out more
hi link typescriptCase Keyword
hi link typescriptLabel Keyword
hi link typescriptImport Function
hi typescriptIdentifierName gui=BOLD
hi link jsxTagName Function
hi link jsxCloseString ErrorMsg
hi tsxTagName guifg=#5098c4
hi tsxCloseString guifg=#2974a1
hi link graphqlString graphqlComment
hi link deniteMatchedRange NONE


hi DiffChange guifg=#b294bb guibg=#373737
hi DiffText guifg=#8abeb7 gui=bold guibg=#373737
hi DiffAdd guifg=#b5bd68 guibg=#373737
hi DiffDelete gui=bold guifg=#cc6666 guibg=#373737

hi NERDTreeOpenable guifg=#b294bb gui=bold
hi link NERDTreeClosable NERDTreeOpenable
hi NERDTreeDir guifg=#ffffff gui=bold
