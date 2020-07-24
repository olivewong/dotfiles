filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set splitright
set nu
xnoremap p pgvy

call plug#begin('~/.vim/addons')
" Offers slick autocomplete functionality.
Plug 'Valloric/YouCompleteMe'
" Gives easy keybindings for commenting and uncommenting things.
Plug 'scrooloose/nerdcommenter'
" All of the colors of the vimbow.
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'
" File opener with fuzzy search.
Plug 'ctrlpvim/ctrlp.vim'
" Git integration.
Plug 'tpope/vim-fugitive'
" Lets you make codebase-wide changes after a grep.
Plug 'yegappan/greplace'
" Bridges the gap between terminal and GUI vim by setting the cursor properly.
Plug 'wincent/terminus'
" For all of your syntax highlighting needs.
Plug 'sheerun/vim-polyglot'
" Lints better than a dryer.
Plug 'sbdchd/neoformat'
" Initialize Plug plugins
Plug 'flowtype/vim-flow', {
      \ 'for': ['javascript', 'typescript'] }
Plug 'preservim/nerdtree'
call plug#end()
" Use ag (the silver searcher) with ctrlp
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
let mapleader = "\<Space>"
map <leader>pr :Neoformat <CR>
map <leader>w :w <CR>
nnoremap <leader>l :CtrlP <C-R>=expand("%:p:h") . "/" <CR><CR>
nnoremap <leader>gs :Gstatus <CR>
nnoremap <leader>gc :Gcommit <CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>ga :!git add .<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gp :Gpush origin HEAD<CR>
nnoremap <leader>gl :0Gclog<CR>
nnoremap <leader>vs :vsp<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>' <C-W><C-W>
nnoremap <leader>; <C-W>h
nnoremap <leader>1 <C-W><C-H>

" Sets the directory for swap files
set directory^=$HOME/.vim/tmp//
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
