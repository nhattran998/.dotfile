# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/harrytran/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="avit"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker-compose yarn)

# @Git alias
alias gpo='git pull origin'
alias grf='git checkout -f' #Revert modified files
alias guf='git clean -fd' #Remove untracked files
alias gulc='git reset --soft HEAD~1' #Undo last commit

## Khi undo commit quá đà, K biết fix ntn thì
## 1. git reflog
## 2. Pick head muốn reset lại --> EX: git reset 'HEAD@{1}'

alias gpod='git pull origin develop'
alias gdiffstat="git diff --stat | tail -n1"
alias gaalldel="git status -s | grep -E '^ D' | cut -d ' ' -f3 | xargs git add --all"
alias gitconfig="code .git/config"
alias gcmam="git commit --amend -m"
# Skip CI for Gitlab CI
alias ggpsc="ggp --push-option=ci.skip"
alias ggfsc="ggf --push-option=ci.skip"

# @Flutter Alias
alias fl='flutter'
alias flh='flutter --help'
alias flr='flutter run'
alias fldoc='flutter docker'
alias flpg='flutter pub get '
alias flc='flutter clean'
alias fle='flutter emulators'
alias entrade-x='flpg && make gen-code'

alias logstr='exa -T --color=always -L=3 --git-ignore -I="node_modules/**"'

# @Yarn Alias
# alias y="yarn"
# alias ya="yarn add"
# alias yad="yarn add --dev"
# alias yap="yarn add --peer"
# alias yb="yarn build"
# alias ycc="yarn cache clean"
# alias yd="yarn dev"
# alias yga="yarn global add"
# alias ygls="yarn global list"
# alias ygrm="yarn global remove"
# alias ygu="yarn global upgrade"
# alias yh="yarn help"
# alias yi="yarn init"
# alias yin="yarn install"
# alias yln="yarn lint"
# alias yls="yarn list"
# alias yout="yarn outdated"
# alias yp="yarn pack"
# alias yrm="yarn remove"
# alias yrun="yarn run"
# alias ys="yarn serve"
# alias yst="yarn start"
# alias yt="yarn test"
# alias ytc="yarn test --coverage"
# alias yuc="yarn global upgrade && yarn cache clean"
# alias yui="yarn upgrade-interactive"
# alias yuil="yarn upgrade-interactive --latest"
# alias yup="yarn upgrade"
# alias yv="yarn version"
# alias yw="yarn workspace"
# alias yws="yarn workspaces"

# @Docker Alias
alias drmia='docker rmi $(docker images -a -q)'
alias drma='docker rm $(docker container -a -q)'
#alias dco='docker-compose'
#alias dcb='docker-compose build'
#alias dce='docker-compose exec'
#alias dcps='docker-compose ps'
#alias dcrestart='docker-compose restart'
#alias dcrm='docker-compose rm'
#alias dcr='docker-compose run'
#alias dcstop='docker-compose stop'
#alias dcup='docker-compose up'
#alias dcupd='docker-compose up -d'
#alias dcdn='docker-compose down'
#alias dcl='docker-compose logs'
#alias dclf='docker-compose logs -f'
#alias dcpull='docker-compose pull'
#alias dcstart='docker-compose start'
#alias dck='docker-compose kill'

# @Zsh alias
alias zshconfig='code ~/.zshrc'

### Other TIP

# MacOS
adddock--large() {
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
  killall Dock
}

# Maybe enter two times
adddock() {
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
  killall Dock
}

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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

function execr() {
  find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && $1" \;
}

export PATH="/usr/local/bin/node:$PATH"
# export PATH="/usr/local/opt/node@12/bin:$PATH"
export PATH="$PATH:/Users/harrytran/flutter/bin"
export PATH="$PATH:/Users/harrytran/.pub-cache/bin"
