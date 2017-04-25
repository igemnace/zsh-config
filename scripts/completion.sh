#!/usr/bin/env bash

[[ -d $HOME/.zsh ]] && mkdir -p $HOME/.zsh

ln -s "$PWD/cfg/completion.zsh" "$HOME/.zsh/completion.zsh"
