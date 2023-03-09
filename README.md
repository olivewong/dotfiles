# Dotfiles / ✨Vim✨ setup
`vimrc` to make vim look like this:
![Screen Shot 2022-12-21 at 3 53 26 PM](https://user-images.githubusercontent.com/11857485/209025580-bf345dda-8dc7-4c06-b207-025d5d49f2fe.png)

or this with `skinnyvimrc` (use if you don't want to install a separate theme/font)
<img width="1358" alt="Screen Shot 2023-01-03 at 9 34 02 PM" src="https://user-images.githubusercontent.com/11857485/210490692-07d404b9-85bb-4ee0-a2af-25a51ba51e97.png">


## Vim
### Install
1. Copy this vimrc `cp skinnyvimrc ~/.vimrc` or `cp vimrc ~/.vimrc`
2. Open `vim` and install plugs: `:PlugInstall`
3. Source: `:source ~/.vimrc`
4. Install `:ag` search: `apt-get install silversearcher-ag` or `brew install the_silver_searcher`
5. For autocomplete, install [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe#linux-64-bit) (needs root)  
  the Linux instructions lie, use:
    ```
    cd ~/.vim/plugged/YouCompleteMe
    python3 install.py --all
    ```
### Make fonts and theme pretty (not needed for `skinnyvimrc`)
1. Set Nord in iterm theme (install [here](https://github.com/arcticicestudio/nord-terminal-app) for Terminal)
2. Download Inconsolata Nerd Font and set as terminal font for nice ligatures and icons

Ubuntu theme: budgie arc-dark with mcmojave-circle-pink

### How to use
my fav vim commands
#### Searching
- `Ctrl+P`: [Search](https://github.com/ctrlpvim/ctrlp.vim) for file name
- `<space>l`: Search for file name in same directory as this file 
- `<space>ag`: Search for word under cursor across all files in directory
- `:Ag stringIWantToSearchFor`: Search for word across all files in directory
#### Misc
- `[Ctrl+N]` Show files with [NERDTree](https://github.com/preservim/nerdtree)
- `<space>pr` Format file
#### LSP (Language Server Protocol) - shows errors/warnings, definitions, etc as you type like VSCode would
- `:LspInstallServer` Install language server for currently opened file's language (you might need additional installs)
- See [vim-lsp](https://github.com/prabirshrestha/vim-lsp) for commands 


## Other setup 
-  install ohmyzsh `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` and `cp zshrc ~/.zshrc`
-  Good Ubuntu theme: budgie arc-dark with mcmojave-circle-pink
