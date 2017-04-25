### TMUX
# [[ $TMUX = ""  ]] && export TERM="xterm-256color"
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
enable_base16_shell() {
  BASE16_SHELL=$HOME/.config/base16-shell/
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
}
[[ $TMUX = ""  ]] && enable_base16_shell
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
export FZF_DEFAULT_OPTS='--no-bold --color=fg:7,fg+:3,bg:-1,bg+:-1,hl:5,hl+:5,prompt:8,pointer:3,marker:2'

# fzf functions
fzf_dirty_files() {
  git status --porcelain | cut -c 1,2,3 --complement | fzf --multi --preview-window=up:50% --preview='git diff --color=always {}'
}

fzf_commits() {
  git log --pretty=oneline --abbrev-commit | fzf --preview-window=up:50% --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always' | cut -f 1 -d " "
}

fzf_music() {
  rg --files $HOME/Music | fzf
}

fzf_apropos() {
  apropos '' | fzf --preview-window=up:50% --preview 'echo {} | cut -f 1 -d " " | xargs man' | cut -f 1 -d " "
}

fzf_alias() {
  alias | tr = "\t" | fzf | cut -f 1
}

fzf_grep() {
  # I use ripgrep here for speed
  # but the same thing can be done by grep -R .
  rg -n '' | sed -e 's/:/+/' -e 's/:/\t/' -e 's/+/:/' | fzf | cut -f 1
}
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
alias gaz='git add $(fzf_dirty_files)'
alias gcz='git show $(fzf_commits)'

# editor aliases
alias v='vim'
alias v.='vim .'
alias vz='vim "$(fzf --multi)"'
alias vgz='vim $(fzf_grep  | sed -e "s/:/ +/")'
alias e='emacs -nw'
alias ez='emacs -nw "$(fzf --multi)"'

# cmus aliases
alias cpz='cmus-remote -p $(fzf_music)'

# misc aliases
alias ls='ls --color=auto'
alias manz='man $(fzf_apropos)'

# path
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Documents/Misc/scripts:$PATH"
export PATH="$HOME/Documents/Misc/scripts/todotxt-helper:$PATH"

# syntax highlighting
# must be at the end of zshrc!
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
### END MISC CHANGES
