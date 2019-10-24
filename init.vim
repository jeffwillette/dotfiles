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
elseif $WORKPLACE == 'KAIST'
    let g:python3_host_prog='/st2/jeff/anaconda3/envs/jeff/bin/python'
    let $NVIM_PYTHON_LOG_FILE='/st2/jeff/.tmp/nvim-python.log'
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
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'xolox/vim-misc'
Plug 'honza/vim-snippets'

Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

Plug 'jvirtanen/vim-octave'

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

Plug 'Shougo/deoplete-clangx', { 'for': ['cpp'] }
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['cpp'] }

Plug 'zchee/deoplete-jedi', { 'for': 'python' }
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'vim-python/python-syntax'

Plug 'jparise/vim-graphql'

Plug 'xolox/vim-colorscheme-switcher'
Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-one'
Plug 'gosukiwi/vim-atom-dark'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
" removed because it interferes with denite somehow
"Plug 'ryanoasis/vim-devicons'

if executable('go')
    Plug 'fatih/vim-go', {'for': 'go'}
    Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go'}
    Plug 'fatih/vim-go', {'for': 'go'}
    Plug 'sebdah/vim-delve', {'for': 'go'}
endif

if executable('node')
    Plug 'ternjs/tern_for_vim', { 'do': 'yarn install', 'for': 'javascript' }
    Plug 'carlitux/deoplete-ternjs', { 'do': 'yarn global add tern', 'for': 'javascript' }
    Plug 'Galooshi/vim-import-js', {'for': ['javascript']}
    Plug 'pangloss/vim-javascript', {'for': ['javascript', 'javascript.jsx']}
    Plug 'mxw/vim-jsx', {'for': ['javascript', 'javascript.jsx']}

    Plug 'HerringtonDarkholme/yats'
    Plug 'mhartington/nvim-typescript', {'branch': 'master', 'do': './install.sh'}

    Plug 'deltaskelta/nvim-deltaskelta', {'do': ':UpdateRemotePlugins'}
endif

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
colorscheme base16-tomorrow-night

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

" vim-latex-preview ------------------------------------------------------------------
let g:livepreview_previewer = 'open -a Preview'

" vim airline ------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 0
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

" this is called to avoid square brackets on icons after refreshing the vimrc
if exists('g:loaded_webdevicons')
	call webdevicons#refresh()
endif

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

" neosnippets ---------------------------------------------------------------------------

let g:neosnippet#enable_completed_snippet = 1
imap qq <Plug>(neosnippet_expand_or_jump)
let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets,~/dotfiles/vim-snippets'

" auto pairs ----------------------------------------------------------------------------

" do not make the line in the center of the page after pressing enter
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCR = 1

" tern for vim --------------------------------------------------------------------------
let g:tern_show_signature_in_pum = 1

" deoplete --------------------------------------------------------------------------

let g:deoplete#enable_profile = 1
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


" deoplete-ternjs ----------------------------------------------------------------

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

" vim fugitive mappings -----------------------------------------------------

nnoremap <leader>gs :Gstatus<CR>
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

" vim go ---------------------------------------------------------------------

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
let g:go_list_type = 'quickfix'
let g:go_list_height = 10
let g:go_list_autoclose = 0

" vim delve -----------------------------------------------------------------------------
let g:delve_new_command = 'new' "make a new window a hirizontal split

" ale ---------------------------------------------------------------------
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_fix_on_save = 1
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_use_global = 1
let g:ale_completion_enabled = 1

" using global prettier because the local one has graphql version conflicts
let g:ale_javascript_prettier_use_global = 1

" for some reason it wasn't finding my project config files with prettier_d
"let g:ale_javascript_prettier_executable = 'prettier_d'
"let g:ale_javascript_prettier_options = '--fallback'
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_keep_list_window_open = 1
let g:ale_list_window_size = 10
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" I had to hack on the main typescript repo so I adde dthis to not run
" prettier on their code and mess up the formatting
let g:ale_pattern_options = {
  \ 'TypeScript': {'ale_fixers': ['tslint']},
  \ 'nvim-typescript': {'ale_fixers': ['tslint']}
  \}

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'cpp': ['clang-format'],
  \ 'go': ['gofmt', 'goimports'],
  \ 'graphql': ['prettier'],
  \ 'javascript': ['prettier', 'eslint', 'importjs'],
  \ 'python': ['black', 'isort'],
  \ 'typescript': ['prettier', 'tslint'],
  \}

" gometalinter only checks the file on disk, so it is only run when the file is saved,
" which can be misleading because it seems like it should be running these linters on save
" \ 'go': ['golint', 'go vet', 'go build', 'gometalinter'],
"\ 'typescript': ['tslint'],
let g:ale_linters = {
   \ 'go': ['golangci-lint'],
   \ 'proto': ['protoc-gen-lint'],
   \ 'graphql': ['gqlint'],
   \ 'javascript': ['eslint'],
   \ 'vim': ['vint'],
   \ 'cpp': ['clang'],
   \ 'python': ['mypy']
   \}

let g:ale_go_golangci_lint_options = '--fast'
let g:ale_go_golangci_lint_package = 1

" CPP ------------------------------------------------------------------
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
let g:jedi#rename_command = '<leader>r'

augroup python
    autocmd!
    autocmd FileType python set tabstop=4 shiftwidth=0 expandtab
augroup END

" ReactJS stuff --------------------------------------------------------
" react syntax will work on .js files
let g:javascript_plugin_flow = 1


augroup javascript
    autocmd!
    " setting javascript things.
    " importjs seems to mess with things
    nnoremap <leader>i :ImportJSFix<CR>
    "autocmd BufWritePre *.js :ImportJSFix
    autocmd FileType javascript set tabstop=2 shiftwidth=2 expandtab
augroup END

" let g:nvim_typescript#server_path = '/Users/Jeff/typescript/TypeScript/bin/tsserver'
let g:nvim_typescript#diagnostics_enable = 1

augroup typescript
    autocmd!
    autocmd FileType typescript,typescript.tsx set omnifunc=TSComplete
    autocmd FileType typescript,typescript.tsx set tabstop=2 shiftwidth=2 expandtab
    autocmd FileType typescript,typescript.tsx nnoremap <buffer><leader>i :TSGetCodeFix<CR>
    autocmd FileType typescript,typescript.tsx nnoremap <buffer><leader>dp :TSDefPreview<CR>
    autocmd FileType typescript,typescript.tsx nnoremap <buffer><leader>d :TSDef<CR>
    autocmd FileType typescript,typescript.tsx nnoremap <buffer><leader>t :TSType<CR>
augroup END

" html files ---------------------------------------------------------------
augroup html
    autocmd!
    autocmd FileType html set tabstop=2 shiftwidth=2 expandtab
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
    autocmd FileType qf setlocal wrap cc=
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

" italics was interfering with some latex
hi markdownItalic guifg=None
