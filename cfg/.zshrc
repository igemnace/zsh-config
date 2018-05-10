### FUNCTIONS
binify() {
  for arg; do
    ln -s "$PWD/$arg" "$HOME/.local/bin/$arg"
  done
}

binedit() {
  files=()
  for arg; do
    files+=("$(command -v "$arg")")
  done
  vim "${files[@]}"
}

sprunge() {
  curl -F 'sprunge=<-' http://sprunge.us/
}

ixio() {
  curl -F 'f:1=<-' http://ix.io/
}

elimage() {
  curlargs=()
  for arg; do
    curlargs+=(-F 'name=@'"$PWD/$arg")
  done
  curl "${curlargs[@]}" https://img.vim-cn.com/
}

vg() {
  vim +"Grep ${*:?No pattern provided.}" +copen
}

cdh() {
  cd "$HOME/$@"
}

detach() {
  "$@" &>/dev/null & disown
}

### META SHELL CHANGES
# force emacs key bindings
bindkey -e

# enable prompt substitution
setopt prompt_subst

# do not count / and . as part of a word
# to make it easier to edit paths
WORDCHARS='*?_[]-~=&;!#$%^(){}<>'

### HISTORY
# set up history file
HISTFILE="$HOME/.zsh_history"

# load up to 5000 entries from the history file on startup
HISTSIZE=5000

# save up to 5000 entries for completion
SAVEHIST=5000

# append each command to the history file
setopt inc_append_history

# auto reload the history file upon modifying
# such as when a different shell instance appends to it
setopt share_history

# make Up and Down cycle through history completions
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

# expand !! into the last command
# but don't run right away so I can verify the command
setopt histverify

# expand !! inline if followed by a <Space>
bindkey " " magic-space

### ALIASES
# for tmux
alias tl='tmux ls'
alias tn='tmux new -s'
alias ta='tmux a -t'
alias tk='tmux kill-session -t'
alias tx='tmux kill-server'

# for git
alias gs='git status --short'
alias ga='git add'
alias gu='git reset HEAD'
alias gc='git commit --verbose'
alias gca='git commit --amend --reuse-message=HEAD'
alias gd='git diff'
alias gb='git branch'
alias gl='git log'
alias gp='git push'
alias gf='git fetch'
alias gm='git merge'
alias gco='git checkout'
alias gll='git log --oneline'
alias glf='git log --oneline HEAD..@{u}'
alias glp='git log --oneline @{u}..HEAD'

# misc aliases
alias e='emacs -nw'
alias ls='ls --color=auto'

### SCRIPT SOURCING
for file in "$HOME/.zsh"/*.zsh; do
  [[ -f $file ]] && source "$file"
done
