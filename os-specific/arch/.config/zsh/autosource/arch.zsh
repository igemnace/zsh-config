# source zsh scripts installed from pacman
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# aur convenience functions
aur() {
  aurget "$@" && aurinstall "$@"
}

aurdeps() {
  aurget "$@" && aurinstall --asdeps "$@"
}

reaur() {
  # TODO: batch all the PKGBUILD inspection together
  for package in "$@"; do
    aurupdate "$package" && aurinstall "$package"
  done
}

unaur() {
  sudo pacman -Runs "$@" && aurremove "$@"
}

# guarded, because takes a long time to source
enable_nvm() {
  source /usr/share/nvm/init-nvm.sh
}

# dummy command for lazy loading
# sources the real thing and calls it
nvm() {
  unset -f nvm
  enable_nvm
  nvm "$@"
}
