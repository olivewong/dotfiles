# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# fzf-powered Ctrl+R
# export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NODE_PATH=$NODE_PATH:`npm root -g`
export PATH=$PATH:~/.node/bin
export PATH=$PATH:~/repos/foxglove-extensions/tagsmith/node_modules/.bin

export GO_PATH=~/go
export PATH=$PATH:/$GO_PATH/bin
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Use the `-S` option so it truncates long lines for scrolling instead of wrapping them psql
# https://challahscript.com/what_i_wish_someone_told_me_about_postgres
# needs less installed
# export PAGER='less -S'
ENV_VARS=$(printenv)
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"
prompt_context(){}

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# General aliases
alias cd2="cd ../.."
alias cd3="cd ../../.."
alias zshrc="vim ~/.zshrc"
alias vim="vim +'colorscheme nord'"
alias nplug="nvim ~/.config/nvim/lua/plugins/plug.lua"
alias conf="nvim ~/.config/nvim/lua"
alias plug="vim ~/.config/nvim/lua/plugins/plug.lua"

# notify when done ex. ./long_task.sh; lmk
alias lmk='tput bel'

# Docker
alias dcd="docker compose down"
dockerstop() {
    docker stop $(docker ps -a -q)
}

# Git
alias gs="git status"
alias gc="git commit"
alias gp="git push origin HEAD"
alias esl="yarn lint:eslint --fix"

# Web
alias yi="yarn install"
alias ys="yarn start"
alias esfix="npx eslint --fix ."
alias yp="yarn package && open ."

alias st="~/repos/foxglove-studio/desktop/package-and-open.sh"
alias ma="cd ~/repos/mappa"
alias mc="cd ~/repos/mcapybara"
alias de="cd ~/repos/data-platform"
alias ssw="ssh workstation"
# fr() {
#     docker-compose up -d && yarn watch;
# }
alias lint="tools/trunk check && tools/trunk fmt"
alias ci="tools/trunk check && tools/trunk fmt && yarn type-check && yarn test"
alias rb="docker-compose build app && docker-compose -f docker-compose.yml up -d"
alias sslw="ssh -L 8081:127.0.0.1:8081 -v  -N  workstation"


alias rsr="cd ~/repos/sim_results && bash .scripts/run-sim-results.sh"
alias sr="cd ~/repos/sim_results "
alias srs="cd ~/repos/sim_results && docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build"
alias srtest="sr && docker-compose -f docker-compose.yml -f docker-compose.integration.yml up --build  --exit-code-from integration_test"
#alias vim='vim "+colorscheme nord"' # I don't know why everything is green but this fixes it

# run when ur out of space
# docker builder prune -f

alias fo="cd ~/repos/foxglove-extensions"
alias fr="cd ~/repos/foxglove-extensions"
alias dp="cd ~/repos/data-platform"
alias ra="cd ~/repos/remote-assist"
alias yli="yarn local-install"
alias fs="cd ~/repos/foxglove-studio"
alias uaf="aws --profile fleet-svcs-dev sso login"
alias co="copilot --allow-all-tools  --deny-tool 'shell(rm)' --deny-tool 'shell(git push)' --deny-tool 'shell(git commit)'"

uac() { ~/setup/refresh-aws-creds.sh; }
udp() { ~/setup/refresh-aws-creds-dp.sh; }
umc() { ~/setup/refresh-aws-creds.sh && ~/setup/refresh-aws-creds-dp.sh; }


export TERM=xterm-256color
export PATH="/opt/homebrew/opt/protobuf@3/bin:$PATH"

[ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh



# port forward 
# ssha workstation 5000 5052 8080 9090 9091 9901 5051;
ssha () {
      local a=() i
          for i in "$@[2,-1]"
                do
                          a+=(-L "${i}:localhost:${i}")
                              done
                                  autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -NT "$1" "$a[@]"
                                }
alias ssm="ssha workstation 5000 5052 8080 9090 9091 9901 5051"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Added by Antigravity
export PATH="/Users/owong/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# TODO: test
refresh-aws() {
    echo "attempting refresh"
    
    
    echo "✅ Credentials updated in ~/.aws/credentials"
}

alias fs-test="~/repos/foxglove-studio/desktop/test.sh"
