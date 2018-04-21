" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')
"
"TODO: add "for" statements to plugins for filetypes?

Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'qpkorr/vim-bufkill'
Plug 'xolox/vim-misc'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

Plug 'xolox/vim-colorscheme-switcher'
Plug 'rakr/vim-one'
Plug 'gosukiwi/vim-atom-dark'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', {'rtp': 'vim/'}

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go'}
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'sebdah/vim-delve', {'for': 'go'}

Plug 'ternjs/tern_for_vim', { 'do': 'yarn install', 'for': 'javascript' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'yarn global add tern', 'for': 'javascript' }
Plug 'Galooshi/vim-import-js', {'for': 'javascript'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript'}
Plug 'jaawerth/neomake-local-eslint-first'

Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'peitalin/vim-jsx-typescript', { 'for': 'typescript' }
Plug 'mhartington/nvim-typescript', { 'do': ':UpdateRemotePlugins', 'for': 'typescript'}

Plug 'zchee/deoplete-jedi', { 'for': 'python' }
Plug 'fenetikm/falcon'
Plug 'chriskempson/base16-vim'

Plug 'jparise/vim-graphql'

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

function! StartProfile() 
    :profile start ~/vim-profile.log
    :profile func *
    :profile file *
endfunction

function! StopProfile()
    :profile stop
endfunction

" SETCOLORS -------------------------------------------------------------------------
nnoremap <leader>+ :NextColorScheme<CR>
nnoremap <leader>- :PrevColorScheme<CR>

" set neovim to have normal vim cursor, guicursor& to restore default
set guicursor=

" setting syntax and makeing colors better
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax on
filetype plugin indent on
colorscheme base16-tomorrow-night

" status line is filename and right aligned column number 
" hidden makes the buffer hidden when inactvie rather than essentially 'closing' it
" I think there was a reason that this line is after the airline option, but IDK
set number
set tabstop=4
set shiftwidth=4
set nowrap
set expandtab
set termguicolors
set background=dark
set hidden
set ttyfast
set lazyredraw
set mouse=a
set directory=~/.config/nvim/tmp
set clipboard=unnamed
set cursorline 
" do not show the scratch preview window when tabbing through completions
set completeopt-=preview
set laststatus=2
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" VIM AIRLINE ------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='tomorrow'
"let g:airline#extensions#tabline#buffer_idx_mode = 0
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
    " making vim cd to the directory of the file that teh cursor is active in
    autocmd BufEnter * cd %:p:h
    " coloring column 91 with errmesg color
    autocmd FileType * set cc=90 tw=90
    autocmd VimEnter * call ChangeColors()
augroup END

" NEOSNIPPETS ---------------------------------------------------------------------------
" added for autocomplete-flow
let g:neosnippet#enable_completed_snippet = 1
imap qq <Plug>(neosnippet_expand_or_jump)
let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets'

" AUTO_PAIRS ----------------------------------------------------------------------------

" do not make the line in the center of the page after pressing enter
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCR = 1

" TERN-FOR-VIM --------------------------------------------------------------------------
let g:tern_show_signature_in_pum = 1

" DEOPLETE --------------------------------------------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

let g:deoplete#ignore_sources = {}
" gathering text from around seems to be largely unnecessary
let g:deoplete#ignore_sources._ = ['around']

" shows type info in the completion, but dont confuse this with flow type info, tern and
" flow serve different purposes https://github.com/ternjs/tern/issues/827
let g:deoplete#sources#ternjs#types = 1 
let g:deoplete#sources#ternjs#case_insensitive = 1

" in order to have tern go through and resolve all of the modules and imports in a webpack
" project, it needs the path to the webpack config. I am usually using create-react-app
" which bundles it in node_modules (path in the project level .tern-project file) If I
" don't want to eject the react-scripts, the references webpack file looks for NODE_ENV
" variable which is unset, this script sets it.
let g:deoplete#sources#ternjs#tern_bin = 'custom-tern' " for tern autocompleting
let g:tern#command = ['custom-tern'] " for running tern commands

" letting tab scroll through the autocomplete list, up to go backwards
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><Up> pumvisible() ? "\<c-p>" : "\<Up>"

" VIM FUGITIVE MAPPINGS -----------------------------------------------------
nnoremap <leader>c :Gcommit<CR>
nnoremap <leader>a :Git add -A :/<CR>

" VIM-GO ---------------------------------------------------------------------
augroup vimgo
    autocmd!
    " this is from the vim-go docs `go-guru-scope` which (I think) sets the scope for
    " go-guru to the current project directory
    autocmd BufRead /Users/Jeff/go/src/*.go
        \  let s:tmp = matchlist(expand('%:p'),
            \ '/Users/Jeff/go/src/\(github.com/user/[^/]\+\)')
        \| if len(s:tmp) > 1 |  exe 'silent :GoGuruScope ' . s:tmp[1] | endif
        \| unlet s:tmp
    autocmd FileType go nmap <leader>ds <Plug>(go-def-split)
    autocmd FileType go nmap <leader>gb <Plug>(go-build)
    autocmd FileType go nmap <leader>dt <Plug>(go-def-tab)
    autocmd FileType go nmap <leader>d <Plug>(go-def)
    autocmd FileType go nmap <leader>gt <Plug>(go-test)
    autocmd FileType go nmap <leader>gl :call GoLinting()<CR>
    autocmd FileType go nmap <leader>gc :GoCoverage<CR><CR>
    autocmd FileType go nmap <leader>gcc :GoCoverageToggle<CR>
    autocmd FileType go nmap <leader>gtf <Plug>(go-test-func)
    autocmd FileType go nmap <leader>gd <Plug>(go-doc)
    autocmd FileType go nmap <leader>gr <Plug>(go-rename)
    autocmd FileType go nmap <leader>da :DlvAddBreakpoint<CR>
    autocmd FileType go nmap <leader>dr :DlvRemoveBreakpoint<CR>
    autocmd FileType go nmap <leader>dt :DlvTest<CR>
    autocmd FileType go set tabstop=4 shiftwidth=4
augroup END

" Highlights
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 0
" vim-go uses the location list by default. This clashes with gometalinter through ale
" plugin and erases test output when there are errors. Set vim-go to use quickfix
let g:go_list_type = "quickfix"
let g:go_list_height = 10
let g:go_list_autoclose = 0

" VIM-DELVE -----------------------------------------------------------------------------
let g:delve_new_command = 'new' "make a new window a hirizontal split

" ALE ---------------------------------------------------------------------
let g:ale_sign_column_always=1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_fix_on_save = 1
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_prettier_executable = 'prettier_d'
let g:ale_javascript_prettier_options = '--fallback'
let g:ale_javascript_prettier_use_global = 1
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_keep_list_window_open = 1
let g:ale_list_window_size = 10
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

let g:ale_fixers = {
	\ 'javascript': ['prettier', 'eslint', 'importjs'],
	\ 'graphql': ['prettier'],
	\ 'typescript': ['prettier', 'tslint'],
	\ 'python': ['autopep8'],
	\ 'go': ['gofmt', 'goimports'], 
	\}

" gometalinter only checks the file on disk, so it is only run when the file is saved,
" which can be misleading because it seems like it should be running these linters on save
" \ 'go': ['golint', 'go vet', 'go build', 'gometalinter'],
let g:ale_linters = {
   \ 'go': ['gometalinter'],
   \ 'proto': ['protoc-gen-lint'],
   \ 'graphql': ['gqlint'],
   \ 'javascript': ['eslint']
   \}

let g:ale_go_gometalinter_options = '--fast --tests'
let g:ale_go_gometalinter_lint_package = 0

" ReactJS stuff --------------------------------------------------------
" react syntax will work on .js files
let g:jsx_ext_required = 0
let g:javascript_plugin_flow = 1

augroup javascript
    autocmd!
    " setting javascript things.
    " importjs seems to mess with things
    nnoremap <leader>i :ImportJSFix<CR>
    "autocmd BufWritePre *.js :ImportJSFix
    autocmd FileType javascript set tabstop=2 shiftwidth=2 expandtab
augroup END

augroup typescript
    autocmd!
    " setting typescript things.
    " TODO: just deleted ,*.jsx after *.tsx, if problems arise, put it back
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
    autocmd FileType typescript set tabstop=2 shiftwidth=2 expandtab
    nnoremap <leader>i :TSImport<CR>
    nnoremap <leader>d :TSDefPreview<CR>
    nnoremap <leader>t :TSType<CR>
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
    autocmd FileType nerdtree 
          \ nnoremap <buffer> <Left> <ESC> |
          \ nnoremap <buffer> <Right> <ESC>
augroup END


nnoremap <leader>[ :NERDTreeToggle<CR>
nnoremap <leader>e :vertical resize 25<CR>
let g:NERDTreeWinSize=25
let g:NERDTreeShowHidden=1

" INSERT MODE MAPPINGS -------------------------------------------------

" maps jj to escape to get out of insert mode
inoremap jj <Esc>

" make Shift + Forward/Back skip by word in insert mode
inoremap <S-Right> <Esc>lwi
inoremap <S-Left> <Esc>bi

" call the autocomplete semantic completion when needed.
inoremap ;; <C-x><C-o>

" NORMAL MODE MAPPINGS ------------------------------------------------

" Reload the file from disk (forced so edits will be lost)
nnoremap <leader>r :edit!<CR>

" open a terminal with a window split and source bash profile
nnoremap <leader>t :new<CR>:terminal<CR>i . ~/.bash_profile<CR>

" add a space in normal mode
nnoremap <space> i<space><esc>

" call the bufkill plugin commad to delete buffer form list
nnoremap <leader>q :BD<CR>

" delete all buffers
nnoremap <leader>qa :bd *<C-a><CR>

" write file (save)
nnoremap <leader>w :w<CR>

" close the preview window with leader p
nnoremap <leader>p :pclose<CR>

" move to the previous buffer
nnoremap <leader>b <C-o>

" in normal mode, the arrow keys will move tabs
nnoremap <silent> <Left> :bprevious!<CR>
nnoremap <silent> <Right> :bnext!<CR>
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

" skip to the numbered buffer
nnoremap <leader>1 :b1<CR>
nnoremap <leader>2 :b2<CR>
nnoremap <leader>3 :b3<CR>
nnoremap <leader>4 :b4<CR>
nnoremap <leader>5 :b5<CR>
nnoremap <leader>6 :b6<CR>
nnoremap <leader>7 :b7<CR>
nnoremap <leader>8 :b8<CR>
nnoremap <leader>10 :b10<CR>
nnoremap <leader>11 :b11<CR>
nnoremap <leader>12 :b12<CR>
nnoremap <leader>13 :b13<CR>
nnoremap <leader>14 :b14<CR>
nnoremap <leader>15 :b15<CR>
nnoremap <leader>16 :b16<CR>
nnoremap <leader>17 :b17<CR>
nnoremap <leader>18 :b18<CR>
nnoremap <leader>19 :b19<CR>
nnoremap <leader>20 :b20<CR>

" this complements the vim command <S-J> which joins current line to below line, this one
" breaks the current line in two
nnoremap <C-j> i<CR><Esc>

" vimgrep the current dir (gd = grepdir) and drops the cursor in the proper spot to type
" the identifier
nnoremap <leader>s :lvimgrep  %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left>

" VISUAL MODE MAPPINGS ------------------------------------------------
" in visual mode, arrows will move text around
vnoremap <Left> <gv
vnoremap <Right> >gv
vnoremap <Up> :m.-2<CR>gv
vnoremap <Down> :m '>+1<CR>==gv

" location list open, close, next, previous wincmd's make it so that the cursor goes back
" to the main buffer and not nerdtree
nnoremap <leader>l :lopen<CR>:wincmd k<CR>:wincmd l<CR>
nnoremap <leader>ll :lclose<CR>:wincmd l<CR>
nnoremap <leader>; :lnext<CR>
nnoremap <leader>' :lprev<CR>

" QUICKFIX WINDOW SETTINGS -------------------------------------------------
" This trigger takes advantage of the fact that the quickfix window can be
" easily distinguished by its file-type, qf. The wincmd J command is
" equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" the very bottom (see :help :wincmd and :help ^WJ).
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap cc=
augroup END

nnoremap <leader>. :cnext<CR>
nnoremap <leader>, :cprevious<CR>
nnoremap <leader>/ :cc<CR>
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
hi link SignColumn LineNr
hi Normal guibg=#212121
hi Comment guifg=#595959
hi VertSplit ctermbg=NONE ctermfg=8 cterm=NONE guibg=NONE guifg=#3a3a3a gui=NONE
hi Visual ctermfg=7 ctermbg=8 guibg=#373737
hi Operator guifg=#E9E9E9
hi Type guifg=#E9E9E9
hi Boolean guifg=#e06c75
hi Search guibg=#61afef
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
