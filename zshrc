# backups: verbatim in ~/.dotfiles-bckp/<date>/, sanitized in ~/repos/dotfiles (github olivewong/dotfiles, PUBLIC)

export ZSH=$HOME/.oh-my-zsh

# nvm is lazy-loaded, default node goes on PATH directly
export NVM_DIR="$HOME/.nvm"
_node=($NVM_DIR/versions/node/*(nOn[1]))
export PATH="$_node/bin:$PATH" NODE_PATH="$_node/lib/node_modules"
nvm() { unfunction nvm; . "$NVM_DIR/nvm.sh"; nvm "$@"; }

export PATH=$PATH:~/.node/bin
export PATH=$PATH:~/repos/foxglove-extensions/tagsmith/node_modules/.bin

export GO_PATH=~/go
export PATH=$PATH:/$GO_PATH/bin
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# psql: `less -S` truncates long lines instead of wrapping
# https://challahscript.com/what_i_wish_someone_told_me_about_postgres
# export PAGER='less -S'

ZSH_THEME="agnoster"
prompt_context(){}

plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# General aliases
alias cd2="cd ../.."
alias cd3="cd ../../.."
alias zshrc="nvim ~/.zshrc"
alias ta="tmux -CC new -A -s main"
alias vim="vim +'colorscheme nord'"
alias nplug="nvim ~/.config/nvim/lua/plugins/plug.lua"
alias conf="nvim ~/.config/nvim/lua"

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

