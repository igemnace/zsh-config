# use vim as primary editor
export VISUAL=vim
export EDITOR=vim

# set PATH
export PATH="$PATH:$HOME/.local/bin"

# set AUR_DIR for my aur tools
export AUR_DIR="$HOME/abs/aur"

# set NNN_OPTS for nnn
export NNN_OPTS=Ce

# auto-start X when running on virtual tty 1
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
