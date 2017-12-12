#!/usr/bin/env zsh

### OPTIONS
# use fd instead of find to populate files
export FZF_DEFAULT_COMMAND='fd --hidden --type f --exclude ".git"'

# customize colors to blend in with my own highlight.zsh theme
export FZF_DEFAULT_OPTS='--no-bold --color=fg:7,fg+:3,bg:-1,bg+:-1,hl:6,hl+:6,prompt:15,pointer:3,marker:2'

### FUNCTIONS
# for files, but separated by whitespace instead of newlines
fzf_argfiles() {
  fzf --multi | tr '\n' ' '
}

# for existing man pages
fzf_apropos() {
  apropos '' | fzf --preview-window=up:50% --preview 'echo {} | cut -f 1,2 -d " " | tr -d \(\) | sed "s/\(\S\+\) \(\S\+\)/\2 \1/" | xargs man' | cut -f 1,2 -d " " | tr -d '()' | sed 's/\(\S\+\) \(\S\+\)/\2 \1/'
}

# for existing aliases
fzf_alias() {
  alias | tr = "\t" | fzf | cut -f 1
}

# source fzf completion
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
bindkey -r '\ec'
bindkey '^T' gosmacs-transpose-chars

### ALIASES
alias vz='vim $(fzf_argfiles)'
alias ez='emacs -nw $(fzf_argfiles)'
alias manz='man $(fzf_apropos)'
alias lz='less $(fzf)'
