# my-zsh-config

Easy way to transfer my zsh configuration across multiple machines.

## Pre-Installation

Make sure that your machine satisfies the following:
- Is using GNU/Linux (scripts are untested on other UNIX systems and will flat-out fail on Windows)
- Has zsh 4.3.9 or later (version required by oh-my-zsh)
- Has no pre-existing `.zshrc` (backup and remove if existing)
- Has bash, git, and wget (required by install scripts)
- Has a working internet connection (will be downloading oh-my-zsh files)

## Installation

Just run `install.sh`. This will automatically do the following:
- Symlink `.zshrc` into your home directory (`zshrc.sh`)
- Run oh-my-zsh installation through wget (`oh-my-zsh.sh`)
- Git clone powerlevel9k zsh theme into oh-my-zsh directory (`powerlevel9k.sh`)

## Licensing

If anyone else sees this and wants to use it, go ahead.

This project is licensed under the Unlicense and is entirely under public domain.
