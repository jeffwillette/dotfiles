scriptencoding utf-8

" disable python 2
let g:loaded_python_provider = 0

if $HOSTNAME == 'desktop'
    let g:python3_host_prog='/home/jeff/anaconda3/envs/neovim/bin/python'
    let $PATH='/home/jeff/anaconda3/envs/neovim/bin:' . $PATH
else
    let g:python3_host_prog='/c2/jeff/anaconda3/envs/neovim/bin/python'
    let $PATH='/c2/jeff/anaconda3/envs/neovim/bin:' . $PATH
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

Plug 'rcarriga/nvim-notify'
Plug 'MunifTanjim/nui.nvim'
Plug 'folke/noice.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" coc ----------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
" ------------------------------------------------------
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
        set verbosefile=/c2/jeff/.tmp/vim.log
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
" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes
set guicursor=
set guifont=Ubuntu
" make sure I can call stuff defined in my bash_profile
set shellcmdflag=-c
set completeopt+=noselect
set number tabstop=4 shiftwidth=4 nowrap expandtab termguicolors background=dark hidden shortmess=atT
set mouse=a directory=~/.config/nvim/tmp cursorline
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
augroup END

"coc setup
"https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-clangd', 'coc-fzf-preview', '@yaegassy/coc-pylsp']

" redefine the ripgre command from fzf plugin to include hidden files
command! -bang -nargs=* RG 
  \ call fzf#vim#grep2("rg --hidden --column --line-number --no-heading --color=always --smart-case -- ", 
  \ <q-args>, 
  \ fzf#vim#with_preview(),
  \ <bang>0)

nmap <Leader><Leader> [fzf-p]
xmap <Leader><Leader> [fzf-p]

nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResourcesRpc project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatusRpc<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActionsRpc<CR>
nnoremap <silent> [fzf-p]<leader>     :<C-u>FzfPreviewBuffersRpc<CR>
nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffersRpc<CR>
nnoremap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResourcesRpc buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumpsRpc<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChangesRpc<CR>
nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrepRpc<Space>
xnoremap          [fzf-p]gr    "sy:FzfPreviewProjectGrepRpc<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTagsRpc<CR>
nnoremap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFixRpc<CR>
nnoremap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationListRpc<CR>
nnoremap <silent> [fzf-p]<space>  :<C-u>RG<CR>

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>




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
nnoremap <silent> <leader>' :Trouble diagnostics toggle<CR>
" jump to the current error

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
