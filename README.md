# my-zsh-config

Easy way to transfer my zsh configuration across multiple machines.

## Pre-Installation

Make sure that your machine satisfies the following:
- Is using GNU/Linux (scripts are untested on other UNIX systems and will
  flat-out fail on Windows)
- Has zsh
- Has no pre-existing `.zshrc` (backup and remove if existing)
- Has env, bash, and git (required by install scripts)
- Has a working internet connection (will be cloning a git repo for base16)

To make use of the optional fzf integration, you must also have installed fzf.
See [the GitHub page](https://github.com/junegunn/fzf) for instructions.

## Installation

Just run `./install`. This will automatically do the following:
- Symlink `.zshrc` into your home directory (`install-zshrc`)
- Symlink completion options `completion.zsh` into `~/.zsh` (`install-completion`)
- Git clone base16-shell colorscheme into your home directory (`install-base16`)
- Git clone my "highlight" zsh theme into `~/.zsh` (`install-prompt-theme`)
- Symlink LS_COLORS file into `~/.zsh` (`install-ls-colors`)

## Licensing

If anyone else sees this and wants to use it, go ahead.

This project is licensed under the Unlicense and is entirely under public
domain.
