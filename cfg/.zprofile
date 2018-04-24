# use vim as primary editor
export VISUAL=vim
export EDITOR=vim

# set PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.gem/ruby/2.4.0/bin"

# set AUR_DIR for my aur tools
export AUR_DIR="$HOME/Downloads/AUR"

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
