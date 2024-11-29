# my-zsh-config

Easy way to transfer my ZSH configuration across multiple machines.

## Pre-Installation

Make sure that your machine satisfies the following:
- Has ZSH
- Has no pre-existing `.zshrc` and `.zprofile` (backup and remove if existing)
- Has env, bash, git, and GNU cp (required by install scripts)

## Installation

Just run `./install` from the repository's root directory. This will
automatically do the following:
- Symlink all of the contents of `cfg` into your home directory (`install-cfg`)
- Detect OS and symlink matching contents of `os-specific` into your home
  directory (`install-os-specific`)
- Symlink all of the contents of `machine-specific` (if existing) into your home
  directory (`install-machine-specific`)

## Licensing

If anyone else sees this and wants to use it, go ahead.

This project is open source, licensed under MIT.

Do you remember this project being Unlicensed? Read more about the license
change [here][license-change].

[license-change]: https://github.com/igemnace/dotfiles/issues/2
