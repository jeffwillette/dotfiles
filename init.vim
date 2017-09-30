" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'jiangmiao/auto-pairs'
Plug 'chriskempson/base16-vim'
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'Galooshi/vim-import-js'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-surround'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'jaawerth/neomake-local-eslint-first'
Plug 'w0rp/ale'
Plug 'qpkorr/vim-bufkill'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'rakr/vim-one'

call plug#end()

" :call ToggleVerbose() for writing a verbose log im tmp
function! ToggleVerbose()
    if !&verbose
        set verbosefile=/tmp/vim.log
        set verbose=9
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

" SETCOLORS -------------------------------------------------------------------------
nnoremap <leader>+ :NextColorScheme<CR>
nnoremap <leader>- :PrevColorScheme<CR>

" change the cursor shape for insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" status line is filename and right aligned column number
" hidden makes the buffer hidden when inactvie rather than essentially 'closing' it
" I think there was a reason that this line is after the airline option, but IDK
set number tabstop=4 shiftwidth=4 expandtab termguicolors background=dark hidden
set synmaxcol=128 ttyfast lazyredraw mouse=a directory=~/.config/nvim/tmp
set clipboard=unnamed

" setting syntax and makeing colors better
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax on
filetype plugin indent on
colorscheme one

" VIM AIRLINE ------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='one'

" called in the startup section after everything has loaded (this is hacky)
function! ChangeColors()
    hi airline_tabmod_unsel guifg=#61afef guibg=#2c323c
endfunction

" refresh the .vimrc on a save so vim does not have to be restarted
augroup startup
    autocmd!
    " sourcing the vimrc on save of this file.
    autocmd BufWritePost *.vim so $MYVIMRC | :AirlineRefresh | :call ChangeColors()
    " making vim cd to the directory of the file that teh cursor is active in
    autocmd BufEnter * cd %:p:h
    " coloring column 91 with errmesg color
    autocmd FileType * set cc=90 tw=90
    autocmd VimEnter * call ChangeColors()
augroup END

" AUTO_PAIRS ----------------------------------------------------------------------------

" do not make the line in the center of the page after pressing enter
let g:AutoPairsCenterLine = 0

" DEOPLETE --------------------------------------------------------------
let g:deoplete#enable_at_startup = 1

" letting tab scroll through the autocomplete list
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

let g:tern_request_timeout = 1
let g:tern_show_signature_in_pum = '0'
" This do disable full signature type on autocomplete

"Add extra filetypes
let g:tern#filetypes = [
\ 'js',
\ 'jsx',
\ 'javascript.jsx',
\ 'vue',
\ '...'
\ ]

" VIM FUGITIVE MAPPINGS -----------------------------------------------------
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>ga :Git add -A :/<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gr :Git rebase -i HEAD~

" VIM-GO ---------------------------------------------------------------------
augroup vimgo
    autocmd!
    autocmd BufWritePre *.go :GoImports
    autocmd FileType go nmap <leader>ds <Plug>(go-def-split)
    autocmd FileType go nmap <leader>b <Plug>(go-build)
    autocmd FileType go nmap <leader>dt <Plug>(go-def-tab)
    autocmd FileType go nmap <leader>d <Plug>(go-def)
    autocmd FileType go nmap <leader>t <Plug>(go-test)
    autocmd FileType go nmap <leader>tf <Plug>(go-test-func)
    autocmd FileType go nmap <leader>dc <Plug>(go-doc)
    autocmd FileType go nmap <leader>rn <Plug>(go-rename)
    autocmd FileType go set tabstop=4 shiftwidth=4
augroup END

" Highlights
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 0
let g:go_list_type = "quickfix"
let g:go_list_height = 1

" ALE ---------------------------------------------------------------------
let g:ale_sign_column_always=1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
" call each manually with BufWritePre :OtherCommands :ALEFix
let g:ale_fix_on_save = 1
let g:ale_javascript_eslint_executable='eslint_d'
let g:ale_javascript_eslint_use_global = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_list_window_size = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

let g:ale_fixers = {
  \ 'javascript': ['prettier', 'eslint'],
  \}

let g:ale_linters = {
    \'go': ['golint', 'go vet', 'gofmt', 'gometalinter']
\}

let g:ale_go_gometalinter_options = '--fast'

" ReactJS stuff --------------------------------------------------------
" react syntax will work on .js files
let g:jsx_ext_required = 0

augroup javascript
    autocmd!
    " setting javascript things.
    autocmd FileType javascript set tabstop=2 shiftwidth=2 expandtab
augroup END

" HTML FILES -----------------------------------------------------------
augroup html
    autocmd!
    autocmd FileType html set tabstop=2 shiftwidth=2 expandtab
augroup END

" NERDTREE SETTINGS ---------------------------------------------------
augroup nerdtree
    autocmd!
    autocmd VimEnter * NERDTree
    autocmd VimEnter * wincmd p
augroup END

map <leader>[ :NERDTreeTabsToggle<CR>
map <leader>e :vertical resize 25<CR>
let g:nerdtree_tabs_open_on_console_startup = 1
let g:NERDTreeWinSize=25
let g:NERDTreeShowHidden=1

" INSERT MODE MAPPINGS -------------------------------------------------

" maps jj to escape to get out of insert mode
inoremap jj <Esc>

" make Shift + Forward/Back skip by word in insert mode
inoremap <S-Right> <Esc>lwi
inoremap <S-Left> <Esc>bi
inoremap <S-CR> <Esc>o

" call the autocomplete semantic completion when needed.
inoremap ;; <C-x><C-o>

" NORMAL MODE MAPPINGS ------------------------------------------------

" open a terminal with a window split
command! -nargs=* TermSplit split | terminal <args>
nnoremap <leader>t :TermSplit<CR>

" add a space in normal mode
nnoremap <space> i<space><esc>

" call the bufkill plugin commad to delete buffer form list
nnoremap <leader>q :BD<CR>

" write file (save)
nnoremap <leader>w :w<CR>

" close the preview window with leader p
nnoremap <leader>p :pclose<CR>

" in normal mode, the arrow keys will move tabs
nnoremap <silent> <Left> :bprevious<CR>
nnoremap <silent> <Right> :bnext<CR>
nnoremap <silent> <Down> <C-d>
nnoremap <silent> <Up> <C-u>


" moving windows with option arrow
nnoremap <silent> <S-Up> :wincmd k<CR>
nnoremap <silent> <S-Right> :wincmd l<CR>
nnoremap <silent> <S-Down> :wincmd j<CR>
nnoremap <silent> <S-Left> :wincmd h<CR>

" inserting newline without entering insert
nnoremap _ O<Esc>
nnoremap - o<Esc>

" location list open, close, next, previous
nnoremap <leader>l :lopen<CR>
nnoremap <leader>ll :lclose<CR>
nnoremap [l :lnext<CR>
nnoremap ]l :lprev<CR>

" skip to the numbered buffer
nnoremap <leader>1 :b1<CR>
nnoremap <leader>2 :b2<CR>
nnoremap <leader>3 :b3<CR>
nnoremap <leader>4 :b4<CR>
nnoremap <leader>5 :b5<CR>
nnoremap <leader>6 :b6<CR>
nnoremap <leader>7 :b7<CR>
nnoremap <leader>8 :b8<CR>
nnoremap <leader>9 :b9<CR>

" this complements the vim command <S-J> which joins current line to below line, this one
" breaks the current line in two
nnoremap <C-j> i<CR><Esc>

" vimgrep the current dir (gd = grepdir) and drops the cursor in the proper spot to type
" the identifier
nnoremap <leader>gd :vimgrep  %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left>

" VISUAL MODE MAPPINGS ------------------------------------------------
" in visual mode, arrows will move text around
vnoremap <Left> <gv
vnoremap <Right> >gv
vnoremap <Up> :m.-2<CR>gv
vnoremap <Down> :m '>+1<CR>==gv

" QUICKFIX WINDOW SETTINGS -------------------------------------------------
" This trigger takes advantage of the fact that the quickfix window can be
" easily distinguished by its file-type, qf. The wincmd J command is
" equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" the very bottom (see :help :wincmd and :help ^WJ).
augroup quickfix
    autocmd!
    autocmd FileType qf wincmd J
    autocmd FileType qf setlocal wrap cc=
augroup END

nnoremap <leader>n :cnext<CR>
nnoremap <leader>b :cprevious<CR>
nnoremap <leader>mm :cclose<CR>
nnoremap <leader>m :copen<CR>

" toggle highlighting after search
map  <leader>h :set hls!<CR>
imap <leader>h <ESC>:set hls!<CR>a
vmap <leader>h <ESC>:set hls!<CR>gv

" Highlight the highlight group name under the cursor
map fhi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" HIGHLIGHTING ----------------------------------------------------------------
hi SignColumn guibg=#202329
hi Normal guibg=#202329
hi VertSplit ctermbg=NONE ctermfg=8 cterm=NONE guibg=NONE guifg=#3a3a3a gui=NONE
hi Visual ctermfg=7 ctermbg=15
hi Operator guifg=#E9E9E9
hi Type guifg=#E9E9E9
hi Boolean guifg=#e06c75
hi Search guibg=#61afef
