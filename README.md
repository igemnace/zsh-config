# my-zsh-config

Easy way to transfer my ZSH configuration across multiple machines.

## Pre-Installation

Make sure that your machine satisfies the following:
- Is using GNU/Linux (scripts are untested on other UNIX systems and will
  flat-out fail on Windows)
- Has ZSH
- Has no pre-existing `.zshrc`, `.zprofile`, and `.zsh` (backup and remove if
  existing)
- Has env, bash, and git (required by install scripts)

To make use of the optional fzf integration, you must also have installed fzf.
See [the GitHub page](https://github.com/junegunn/fzf) for instructions.

## Installation

Just run `./install` from the repository's root directory. This will
automatically do the following:
- Symlink `.zshrc` into your home directory (`install-zshrc`)
- Symlink all of the contents of `.zsh` into your home directory (`install-zsh`)

## Licensing

If anyone else sees this and wants to use it, go ahead.

This project is open source, licensed under MIT.

Do you remember this project being Unlicensed? Read more about the license
change [here][license-change].

[license-change]: https://github.com/igemnace/dotfiles/issues/2
