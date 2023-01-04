# Dotfiles / ✨Vim✨ setup

vimrc (featuring Nord)
![Screen Shot 2022-12-21 at 3 53 26 PM](https://user-images.githubusercontent.com/11857485/209025580-bf345dda-8dc7-4c06-b207-025d5d49f2fe.png)

## .vimrc installation
1. Copy desired vimrc to `~/.vimrc` (make sure to save a copy of yours first): `cp skinnyvimrc ~/.vimrc`
2. Open `vim` and install plugs with VimPlug: `:PlugInstall`
3. Source: `:source ~/.vimrc`
4. Install :ag search: `apt-get install silversearcher-ag` or `brew install the_silver_searcher`
5. For autocomplete, install [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe#linux-64-bit) 
  (needs root) the Linux instructions lie, use:
    ```
    cd ~/.vim/plugged/YouCompleteMe
    python3 install.py --all
    ```
### Make fonts and theme pretty
(not needed for `skinnyvimrc`)
1. Set Nord in iterm theme (install [here](https://github.com/arcticicestudio/nord-terminal-app) for Terminal)
2. Download Inconsolata Nerd Font and set as terminal font for nice ligatures and icons


## Vim commands 
### Search
- [Ctrl+P](https://github.com/ctrlpvim/ctrlp.vim): Search for file name
- `<space>l`: Search for file name in same directory as this file 
- `<space>ag`: Search for word under cursor across all files in directory (see silver searcher installation above)
- `:Ag stringIWantToSearchFor`: Search for word across all files in directory

### LSP (Language Server Protocol)
- Show errors/warnings and definitions as you type like VSCode would
- `:LspInstallServer` Install language server for currently opened file's language (you might need additional installs but should show errors after this)
- See [vim-lsp](https://github.com/prabirshrestha/vim-lsp) for commands 

### Other
-`[Ctrl+N]` Show files with [NERDTree](https://github.com/preservim/nerdtree)
-`<space>pr` Format this file


## Other setup things 
-  (install zsh and `cp zshrc ~/.zshrc`)
-  Good Ubuntu theme: budgie arc-dark with mcmojave-circle-pink
