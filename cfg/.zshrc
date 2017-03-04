### TMUX
[[ $TMUX = ""  ]] && export TERM="xterm-256color"
### END TMUX

### OH-MY-ZSH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel9k/powerlevel9k"
DISABLE_LS_COLORS="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)
source $ZSH/oh-my-zsh.sh
### END OH-MY-ZSH

### BASE-16 SHELL
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
### END BASE-16 SHELL

### POWERLEVEL9K
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs background_jobs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
### END POWERLEVEL9K

### POWERLINE
export POWERLINE_CONFIG_COMMAND="/usr/local/bin/powerline-config"
export POWERLINE_COMMAND=powerline
### END POWERLINE

### NVM
source /usr/share/nvm/init-nvm.sh
### END NVM

### FZF
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!build/*"'
### END FZF

### ANDROID
export ANDROID_HOME="/opt/android-sdk"
export PATH="/opt/android-sdk/platform-tools:/opt/android-sdk/tools:$PATH"
### END ANDROID

### MISC CHANGES
# editor
export VISUAL=vim
export EDITOR=vim

# aliases
alias ls='ls --color=auto'
alias tl='tmux ls'
alias tn='tmux new -s'
alias ta='tmux a -t'
alias tk='tmux kill-session -t'
alias tx='tmux kill-server'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias vz='vim $(fzf)'

# path
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Documents/Misc/scripts:$PATH"
### END MISC CHANGES
