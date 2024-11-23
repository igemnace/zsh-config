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
  tail -n +1 -- "$@" | curl -F 'sprunge=<-' http://sprunge.us/
}

ixio() {
  tail -n +1 -- "$@" | curl -F 'f:1=<-' http://ix.io/
}

0x0() {
  tail -n +1 -- "$@" | curl -F 'file=@-' https://0x0.st/
}

elimage() {
  curlargs=()
  for arg; do
    curlargs+=(-F 'name=@'"$PWD/$arg")
  done
  curl "${curlargs[@]}" https://img.vim-cn.com/
}

serveo() {
  ssh -R 80:localhost:"${@:?No port provided.}" serveo.net
}

vg() {
  vim +copen -q <(rg --vimgrep --column --no-heading "${@:?No pattern provided.}")
}

vs() {
  vim +Git +'wincmd o'
}

vm() {
  vim +'Git mergetool'
}

cdh() {
  cd "$HOME/$@"
}

detach() {
  "$@" &>/dev/null & disown
}

:h() {
  vim +"h $*" +only
}

n3() {
  # nnn's cd on quit mechanism. Taken from quitcd.bash_zsh
  # Block nesting of nnn in subshells
  if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

  # configure cd on quit
  NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  # run nnn
  nnn "$@"

  # source and clean up tempfile
  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}

rcopy-from() {
  # Usage: rcopy-from USER@HOST
  # convenience function: copy from a remote clipboard with rclip
  rclip "${1:?Connection string required.}" | clip
}

rpaste-to() {
  # Usage: rpaste-to USER@HOST
  # convenience function: paste to a remote clipboard with rclip
  clip | rclip "${1:?Connection string required.}"
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
alias gsi='git status --short --ignored'
alias ga='git add'
alias gu='git rm --cached'
alias gc='git commit --verbose'
alias gca='git commit --amend'
alias gcaa='git commit --amend --reuse-message=HEAD'
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
alias grc='git rebase --continue'
alias gcpc='git cherry-pick --continue'

# misc aliases
alias e='emacs -nw'
alias ls='ls --color=auto'
alias lx=exa
alias d=detach

### SCRIPT AUTOSOURCING
for file in "$HOME"/.config/zsh/autosource/*.zsh; do
  [[ -f $file ]] && source "$file"
done
