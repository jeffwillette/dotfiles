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
    let g:python3_host_prog='/home/jeff/.venv/nvim/bin/python'
    let $NVIM_PYTHON_LOG_FILE='/home/jeff/.tmp/nvim-python.log'
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
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

Plug 'zchee/deoplete-jedi', { 'for': 'python' }
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
    autocmd FileType denite call s:denite_my_settings()
    autocmd FileType denite-filter call s:denite_filter_my_settings()
augroup END

" auto pairs ----------------------------------------------------------------------------

" do not make the line in the center of the page after pressing enter
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCR = 1

" deoplete --------------------------------------------------------------------------

call deoplete#enable_logging('INFO', '/tmp/deoplete.log')
call deoplete#custom#source('jedi', 'is_debug_enabled', v:true)

let g:deoplete#enable_at_startup = 1

call deoplete#custom#option({
  \ 'smart_case': v:true,
  \ 'profile': v:true,
  \ 'auto_complete_delay': 0,
  \ 'auto_refresh_delay': 20,
  \ })

call deoplete#custom#source(
  \ 'file', 'enable_buffer_path', v:false)


" letting tab scroll through the autocomplete list, up to go backwards
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><Up> pumvisible() ? "\<c-p>" : "\<Up>"

" vim fugitive mappings -----------------------------------------------------

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

" denite settings -----------------------------------------------------------

" called in startup augrouph
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
  imap <silent><buffer> JJ denite#do_map('quit')
endfunction

" called in startup augroup
function! s:denite_my_settings() abort
    " set some navigation commands
    inoremap <C-j> denite#do_map('<denite:move_to_next_line>')

    nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q denite#do_map('quit')
    nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
endfunction

" file search command shows hidden and ignores !.git and respected .gitignore
call denite#custom#var('file/rec', 'command',
    \['rg', '--follow', '--files', '--hidden', '-g', '!.git'])

" grep command using rg for speed, respected .gitignore
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--iglob', '!yarn.lock'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" let the denite buffer window match by buffer number
call denite#custom#var('buffer', 'date_format', '')
call denite#custom#source('buffer', 'matchers', ['converter/abbr_word', 'matcher/substring'])

" define a custom grep (rg) command that will unignore files I usually don't want to search,
" -uu is the flag that searches everything excpet binary files
call denite#custom#alias('source', 'rg/unignore', 'grep')
call denite#custom#var('rg/unignore', 'command', ['rg'])
call denite#custom#var('rg/unignore', 'default_opts',
    \ ['-iuu', '--vimgrep'])
call denite#custom#var('rg/unignore', 'recursive_opts', [])
call denite#custom#var('rg/unignore', 'pattern_opt', [])
call denite#custom#var('rg/unignore', 'separator', ['--'])
call denite#custom#var('rg/unignore', 'final_opts', [])

nnoremap <leader><Space> :Denite -split=floating -prompt=❯ -start-filter -highlight-matched-range=NONE -highlight-matched-char=NONE file/rec<CR>
nnoremap <leader>` :Denite -split=floating -prompt=❯ -start-filter -highlight-matched-range=NONE -highlight-matched-char=NONE -path=~/ file/rec<CR>
nnoremap <leader><leader> :Denite -split=floating buffer<CR>
nnoremap <leader><Space><Space> :Denite -split=floating grep:.<CR>
nnoremap <leader>c :DeniteCursorWord -split=floating grep:.<CR>
nnoremap <leader><Space>a :Denite -split=floating -highlight-matched-range=NONE -highlight-matched-char=NONE rg/unignore<CR>

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

" CPP ------------------------------------------------------------------
"
call deoplete#custom#var('clangx', 'clang', '/usr/bin/clang')
augroup cpp
    autocmd!
    autocmd FileType cpp set tabstop=2 shiftwidth=2 expandtab
augroup END

" Python

let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#enable_typeinfo = 1 " for faster results

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
