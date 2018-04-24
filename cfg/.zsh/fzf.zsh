#!/usr/bin/env zsh

### OPTIONS
# use fd instead of find to populate files
export FZF_DEFAULT_COMMAND='fd --hidden --type f --type l --exclude ".git"'

# customize colors to blend in with my own highlight.zsh theme
export FZF_DEFAULT_OPTS='--no-bold --color=fg:7,fg+:3,bg:-1,bg+:-1,hl:6,hl+:6,prompt:15,pointer:3,marker:2'

# for opening files with EDITOR
ez() {
  files=()
  while IFS= read -r -d '' file; do
    files+=("$file")
  done < <(fzf --multi --print0)

  (( ${#files} )) || return
  "${VISUAL:-${EDITOR:-vi}}" "$@" "${files[@]}"
}
alias vz=ez

# for existing man pages
fzf_apropos() {
  apropos '' | fzf --preview-window=up:50% --preview 'echo {} | cut -f 1,2 -d " " | tr -d \(\) | sed "s/\(\S\+\) \(\S\+\)/\2 \1/" | xargs man' | cut -f 1,2 -d " " | tr -d '()' | sed 's/\(\S\+\) \(\S\+\)/\2 \1/'
}
alias manz='man $(fzf_apropos)'

# source fzf completion
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
bindkey -r '\ec'
bindkey '^T' gosmacs-transpose-chars
