### BASE-16 SHELL
# define function to enable base16 helper in current shell instance
# sourcing impacts startup time, so execute only when needed
enable_base16_shell() {
  BASE16_SHELL=$HOME/.config/base16-shell/
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
}

# outside tmux, colors misbehave
# enable base16 helper automatically in such cases
[[ $TMUX = ""  ]] && enable_base16_shell
### END BASE-16 SHELL

### NVM
# define function to enable nvm in current shell instance
# sourcing impacts startup time, so execute only when needed
enable_nvm() {
  source /usr/share/nvm/init-nvm.sh
}
### END NVM

### FZF
# use ripgrep instead of find to populate files
# only used when fzf is called without piping anything into stdin
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!build/*"'

# customize colors to blend in with my own highlight.zsh theme
export FZF_DEFAULT_OPTS='--no-bold --color=fg:7,fg+:3,bg:-1,bg+:-1,hl:6,hl+:6,prompt:8,pointer:3,marker:2'

### FZF FUNCTIONS
# for files, but separated by whitespace instead of newlines
fzf_argfiles() {
  fzf --multi | tr '\n' ' '
}

# for unstaged changes and untracked files
fzf_dirty_files() {
  git status --porcelain | cut -c 1,2,3 --complement | fzf --multi --preview-window=up:50% --preview='git diff --color=always {}'
}

fzf_modified_files() {
  git status --porcelain --untracked-files=no | cut -c 1,2,3 --complement | fzf --multi --preview-window=up:50% --preview='git diff --color=always {}'
}

# for commits
fzf_commits() {
  git log --pretty=oneline --abbrev-commit | fzf --preview-window=up:50% --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always' | cut -f 1 -d " "
}

# for music files in ~/Music
fzf_music() {
  rg --files $HOME/Music | fzf
}

# for existing man pages
fzf_apropos() {
  apropos '' | fzf --preview-window=up:50% --preview 'echo {} | cut -f 1,2 -d " " | tr -d \(\) | sed "s/\(\S\+\) \(\S\+\)/\2 \1/" | xargs man' | cut -f 1,2 -d " " | tr -d '()' | sed 's/\(\S\+\) \(\S\+\)/\2 \1/'
}

# for existing aliases
fzf_alias() {
  alias | tr = "\t" | fzf | cut -f 1
}

# for lines in all files in this directory, recursively
fzf_grep() {
  # I use ripgrep here for speed
  # but the same thing can be done by grep -R .
  rg --hidden -n '' | sed -e 's/:/+/' -e 's/:/\t/' -e 's/+/:/' | fzf | cut -f 1
}
### END FZF

### SPRUNGE
sprunge() {
  curl -F "sprunge=<-" http://sprunge.us
}
### END SPRUNGE

### INOTIFY-TOOLS
watchdir() {
  inotifywait -rme modify --format '%w%f' "$1"
}
### END INOTIFY-TOOLS

### MISC CHANGES
### META SHELL CHANGES
# force emacs key bindings
bindkey -e

### THEME
# make ls colors explicit
source "$HOME/.zsh/lscolors.zsh"

# enable prompt substitution
setopt prompt_subst

# use my custom highlight.zsh theme
source "$HOME/.zsh/highlight.zsh"

### LINE EDITING
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

### COMPLETION
# source completion config
source "$HOME/.zsh/completion.zsh"

# source fzf completion
# must be done after initializing all zle widgets
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

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
alias gaz='git add $(fzf_dirty_files)'
alias gpz='git add --patch $(fzf_dirty_files)'
alias gdz='git diff $(fzf_modified_files)'
alias gcz='git show $(fzf_commits)'

# for editors
alias v='vim'
alias v.='vim .'
alias vz='vim $(fzf_argfiles)'
alias vgz='vim $(fzf_grep | sed -e "s/:/ +/")'
alias e='emacs -nw'
alias ez='emacs -nw "$(fzf --multi)"'

# for cmus
alias cpz='cmus-remote -p $(fzf_music)'

# misc aliases
alias ls='ls --color=auto'
alias manz='man $(fzf_apropos)'
alias lz='less $(fzf)'
alias n='notify-exit.sh'

### SYNTAX HIGHLIGHTING
# must be at the end of zshrc
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
### END MISC CHANGES
