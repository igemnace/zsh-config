#!/usr/bin/env bash

if [ ! -d "$HOME/.config" ]; then
  mkdir "$HOME/.config"
fi

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
