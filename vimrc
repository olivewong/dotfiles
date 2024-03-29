filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set splitright 
set nornu
set synmaxcol=256
set ttyfast " u got a fast terminal
"set ttyscroll=3
set lazyredraw " to avoid scrolling problems
set clipboard=unnamed
xnoremap p pgvy

" BINDINGS
let mapleader = "\<Space>"
nnoremap <leader>vs :vsp<CR>
nnoremap <leader>sp :sp<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>w :w <CR>
nnoremap <leader>l :CtrlP <C-R>=expand("%:p:h") . "/" <CR><CR>
nnoremap <leader>gs :Gstatus <CR>
nnoremap <leader>gc :Gcommit <CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>ga :!git add .<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>gp :Gpush origin HEAD<CR>
nnoremap <leader>gl :0Gclog<CR>
nnoremap <leader>' <C-W><C-W>
nnoremap <leader>; <C-W>h
nnoremap <leader>1 <C-W><C-H>
" Lsp/format stuff
nnoremap <leader>pr :Neoformat<CR>
nnoremap <leader>d :LspDefinition <CR>
nnoremap <leader>r :LspReferences <CR>
nnoremap <leader>e :LspNextDiagnostic <CR>
nnoremap <leader>E :LspPreviousDiagnostic <CR>
nnoremap <leader>pp :LspDocumentFormat <CR>
nnoremap <leader>fm :!tools/trunk fmt<CR>

function! ToggleSplitsAndNu()
    if !exists("w:is_sole_window")
        let w:is_sole_window = 0
    endif
    if w:is_sole_window
        " Restore other splits and line numbers
        execute "wincmd o"
        execute "windo set nu"
        let w:is_sole_window = 0
    else
        " Hide other splits and line numbers
        execute "wincmd O"
        execute "windo set nonu"
        let w:is_sole_window = 1
    endif
endfunction
nnoremap <leader>c :call ToggleSplitsAndNu()<CR>
" Clear search highlight after hitting enter in normal mode
"nnoremap <CR> :noh<CR><CR>

" Search for word under cursor
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
" Load vim-plug - install if not present
" vim
if empty(glob("~/.vim/autoload/plug.vim"))
execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'gabrielelana/vim-markdown'
" Fuzzy search folder tree
Plug 'ctrlpvim/ctrlp.vim'
" Allows you to prefix movements with ',' to move through
" CamelCased/snake_cased word movements (e.g. ,w ,b ,e)
Plug 'vim-scripts/camelcasemotion'
" Nicely formats JSON
Plug 'leshill/vim-json'
" LSP
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

"https://github.com/ycm-core/YouCompleteMe/issues/914
"Plug 'ycm-core/YouCompleteMe'
" Press ctrl+n to browse directory tree
Plug 'scrooloose/nerdtree'
" Shows changes to git repo files in nerdtree
Plug 'Xuyuanp/nerdtree-git-plugin'
" COLORS
" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/CSApprox'
Plug 'joshdick/onedark.vim'
"Plug 'olivewong/cosme-dark.vim'
Plug 'arcticicestudio/nord-vim'
" Improved syntax highlighting
Plug 'sheerun/vim-polyglot'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
\ 'do': 'yarn install --frozen-lockfile --production',
\ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
Plug 'sbdchd/neoformat'
" Initialize Plug plugins
" Seamlessly navigate vim splits and tmux panes
" https://robots.thoughtbot.com/seamlessly-navigate-vim-and-tmux-splits
Plug 'christoomey/vim-tmux-navigator'
" Show git diff on left side
Plug 'tpope/vim-fugitive'
"Plug 'airblade/vim-gitgutter'
" Show class definitions
Plug 'majutsushi/tagbar'
Plug 'dkprice/vim-easygrep'

" Fuzzy find
" Ag required, on timeshare use conda to download
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'ryanoasis/vim-devicons'
" CSE 130 C shit
Plug 'mechatroner/minimal_gdb'
" All of your Plugins must be added before the following line
call plug#end()              " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Plugged package manager commands
" :PlugList       - lists configured plugins
" :PlugInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PlugSearch foo - searches for foo; append `!` to refresh local cache
" :PlugClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let g:neoformat_try_node_exe = 1
map <C-t> :TagbarToggle<CR>
let g:tagbar_show_linenumbers = -1
" NERDTree shit
" Toggle NERDTree with Ctrl+n
if has('nvim')
nnoremap <C-n> :CHADopen<CR>
else
map <C-n> :NERDTreeToggle<CR>
endif
" Ignore certain files in NERDTree
let NERDTreeIgnore = ['\.pyc$','\.class$']
" Show relative line numbers in NERDTree
" enable line numbers
let NERDTreeShowLineNumbers=1

" ctrlp shit
" Force files searched for to be open in a new buffer,
" even if they're already open in another split
let g:ctrlp_switch_buffer = 0
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|py_modules'
" don't make git repo the working directory
let g:ctrlp_working_path_mode = '' 

"ignore subdirectory stuff using .gitignore
let g:ctrlp_user_command = [
  \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
  \ 'find %s -type f'
  \ ]


" Enable filetype plugin
filetype on
filetype plugin on
filetype indent on
" COLORS
" Order matters here - TODO: doubel check
" Make sure to set background before theme 
" Turn on syntax highlighting
syntax on
set background=dark
"let g:airline_theme='nord'
let g:airline_theme='onedark'
colorscheme onedark

" Color scheme
:hi Comment gui=italic cterm=italic term=italic
"idk if these are necessary below
let g:nord_italic = 1
let g:nord_italic_comments = 1
  "autocmd ColorScheme nord highlight Comment cterm=NONE gui=NONE
  "autocmd ColorScheme nord highlight Italic cterm=italic gui=italic
let g:nord_bold = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline_powerline_fonts = 1
set encoding=UTF-8

" uh idk if this does anything
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
"highlight Comment gui=italic
highlight Comment cterm=italic
" autoindent stuff as you are coding
set autoindent
" json highlighting
au! BufRead,BufNewFile *.json set filetype=json "foldmethod=syntax
" Don't suggest filenames with these extensions when vs or sp or edit etc.
set wildignore+=*.pdf,*.d,*.o,*.pyc,*.jpg,*.jpeg,*.png,*.class,*.output,*.DS_Store,

" python
let g:neoformat_enabled_python = ['autopep8', 'yapf', 'docformatter']
"  convert tabs to spaces
map <LocalLeader>kt :%s/\t/  /g<CR>

" set history to be longer
set history=1000

" shut the F*** up
set visualbell


"  Highlight text that goes beyond 90 char column limit
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%91v.\+/

" Automatically show line numbers
set nu

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on



let g:notes_suffix = '.txt'

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

set backspace=indent,eol,start

" Enable folding
set foldmethod=indent
set foldlevelstart=99

" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
let line = line('.')
let column = col('.')
let lastline = line('$')
let indent = indent(line)
let stepvalue = a:fwd ? 1 : -1
while (line > 0 && line <= lastline)
  let line = line + stepvalue
  if ( ! a:lowerlevel && indent(line) == indent ||
        \ a:lowerlevel && indent(line) < indent)
    if (! a:skipblanks || strlen(getline(line)) > 0)
      if (a:exclusive)
        let line = line - stepvalue
      endif
      exe line
      exe "normal " column . "|"
      return
    endif
  endif
endwhile
endfunction
" To use:
" 1. Move to the window to mark for the swap via ctrl-w movement
" 2. Type \mw
" 3. Move to the window you want to swap
" 4. Type \pw

" Always display the statusline:
:set laststatus=2

" Incremental searching - start search as soon as first char entered after /
set incsearch

" Highlight search matchces
set hlsearch



" LSP THINGS
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
let g:lsp_diagnostics_enabled = 1
let g:lsp_document_highlight_enabled = 0
let g:lsp_inlay_hints_enabled = 1

" Go
augroup LspGo
au!
autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'go-lang',
    \ 'cmd': {server_info->['gopls']},
    \ 'whitelist': ['go'],
    \ })
autocmd FileType go setlocal omnifunc=lsp#complete
autocmd FileType go nmap <buffer> gd <plug>(lsp-definition)
augroup END

if executable('pyls')
 " pip install python-language-server
  au User lsp_setup call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['pyls']},
      \ 'allowlist': ['python'],
      \ })
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  "nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)
    " Asyncomplete
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

