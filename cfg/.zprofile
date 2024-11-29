# use vim as primary editor
export VISUAL=vim
export EDITOR=vim

# set PATH
export PATH="$PATH:$HOME/.local/bin"

# set AUR_DIR for my aur tools
export AUR_DIR="$HOME/abs/aur"

# set NNN_OPTS for nnn
export NNN_OPTS=Ce

# control firefox behavior
export MOZ_USE_XINPUT2=1

### ENV AUTOSOURCING
if [[ -d "$HOME/.config/zsh/env" ]]; then
  for file in "$HOME"/.config/zsh/env/*.zsh; do
    [[ -e $file ]] && source "$file"
  done
fi
