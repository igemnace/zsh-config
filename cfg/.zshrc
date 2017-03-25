### TMUX
[[ $TMUX = ""  ]] && export TERM="xterm-256color"
### END TMUX

### OH-MY-ZSH
export ZSH=$HOME/.oh-my-zsh
export LANG="en_US.UTF-8"
ZSH_THEME="highlight"
DISABLE_LS_COLORS="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
source $ZSH/oh-my-zsh.sh
### END OH-MY-ZSH

### BASE-16 SHELL
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
### END BASE-16 SHELL

### NVM
# impacts startup time, so put in function and execute when needed
enable_nvm() {
  source /usr/share/nvm/init-nvm.sh
}
### END NVM

### FZF
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!build/*"'
### END FZF

### TODOTXT
sync_todos() {
  dropbox_uploader upload "$HOME/todo.txt" todo.txt
  dropbox_uploader upload "$HOME/done.txt" done.txt
  dropbox_uploader upload "$HOME/notes.md" notes.md
}
### END TODOTXT

### ANDROID
export ANDROID_HOME="/opt/android-sdk"
export PATH="/opt/android-sdk/platform-tools:/opt/android-sdk/tools:$PATH"
### END ANDROID

### MISC CHANGES
# editor
export VISUAL=vim
export EDITOR=vim

# tmux aliases
alias tl='tmux ls'
alias tn='tmux new -s'
alias ta='tmux a -t'
alias tk='tmux kill-session -t'
alias tx='tmux kill-server'

# git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'

# editor aliases
alias v='vim'
alias v.='vim .'
alias vz='vim "$(fzf --multi)"'
alias e='emacs -nw'
alias ez='emacs -nw "$(fzf --multi)"'

# misc aliases
alias ls='ls --color=auto'

# path
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Documents/Misc/scripts:$PATH"
### END MISC CHANGES
