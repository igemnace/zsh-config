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
  apropos '' | fzf --preview-window=up:50% --preview 'echo {} | cut -f 1 -d " " | xargs man' | cut -f 1 -d " "
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

### TODOTXT
# define functions to sync todo.txt files to Dropbox
upload_todos() {
  dropbox_uploader upload "$HOME/todo.txt" todo.txt &
  dropbox_uploader upload "$HOME/done.txt" done.txt &
  dropbox_uploader upload "$HOME/notes.md" notes.md &

  wait
}
### END TODOTXT

### ANDROID
# add ANDROID_HOME env variable, apparently used by the SDK and Gradle
export ANDROID_HOME="/opt/android-sdk"
### END ANDROID

### MISC CHANGES
### META SHELL CHANGES
# force LANG
export LANG="en_US.UTF-8"

# use vim as primary editor
export VISUAL=vim
export EDITOR=vim

# force emacs key bindings
bindkey -e

### THEME
# make ls colors explicit
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';

# enable prompt substitution
setopt prompt_subst

# use my custom highlight.zsh theme
source $HOME/.zsh/highlight.zsh

### LINE-EDITING
# do not count / and . as part of a word
# to make it easier to edit paths
export WORDCHARS='*?_[]-~=&;!#$%^(){}<>'

### HISTORY
# set up history file
HISTFILE=$HOME/.zsh_history

# append each command to the history file
setopt inc_append_history

# auto reload the history file upon modifying
# such as when a different shell instance appends to it
setopt share_history

# load up to 5000 entries from the history file on startup
HISTSIZE=5000

# save up to 5000 entries for completion
SAVEHIST=5000

# make Up and Down cycle through history completions
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# expand !! into the last command
# but don't run right away so I can verify the command
setopt histverify

# expand !! inline if followed by a <Space>
bindkey " " magic-space

### COMPLETION
# source completion config
source $HOME/.zsh/completion.zsh

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
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log'
alias gll='git log --pretty=oneline'
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

### PATH
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Documents/Misc/scripts:$PATH"
export PATH="$HOME/Documents/Misc/scripts/todotxt-helper:$PATH"
export PATH="/opt/android-sdk/platform-tools:/opt/android-sdk/tools:$PATH"

### SYNTAX HIGHLIGHTING
# must be at the end of zshrc
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
### END MISC CHANGES
