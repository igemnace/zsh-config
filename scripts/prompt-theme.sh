#!/usr/bin/env bash

[[ -d $HOME/.zsh ]] && mkdir -p $HOME/.zsh

ln -s "$PWD/cfg/highlight.zsh" "$HOME/.zsh/highlight.zsh"
