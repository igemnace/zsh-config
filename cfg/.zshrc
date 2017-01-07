### TMUX
[[ $TMUX = ""  ]] && export TERM="xterm-256color"
### END TMUX

### OH-MY-ZSH
export ZSH=/home/ian/.oh-my-zsh
ZSH_THEME="powerlevel9k/powerlevel9k"
DISABLE_LS_COLORS="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)
source $ZSH/oh-my-zsh.sh
### END OH-MY-ZSH

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

# path
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Documents/Misc/scripts:$PATH"
### END MISC CHANGES
