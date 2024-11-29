### OPTIONS
# use fd instead of find to populate files
export FZF_DEFAULT_COMMAND='fd --hidden --type f --type l --exclude ".git"'

# customize colors to blend in with my own highlight.zsh theme
export FZF_DEFAULT_OPTS='--no-bold --color=fg:7,fg+:3,bg:-1,bg+:-1,hl:6,hl+:6,prompt:8,pointer:3,marker:2'

# for opening files with ez
alias vz=ez

# for existing man pages
manz() {
  apropos '' |
    fzf --preview-window=up:50% \
      --preview 'awk -v FS="[() ]" "{print \$3, \$1}" <<< {} | xargs man' |
    awk -v FS='[() ]' '{print $3, $1}' |
    xargs man
}

# source fzf completion
bindkey -r '\ec'
bindkey '^T' gosmacs-transpose-chars
