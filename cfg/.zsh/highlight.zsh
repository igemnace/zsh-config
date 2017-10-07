# cache newline in a variable
newline=$'\n'
setopt BASH_REMATCH

### CONTEXT
### prints directory
collapse_pwd() {
  if [[ $PWD == "$HOME" ]]; then
    echo "%F{4}%B~%f%b"
  elif [[ $PWD == "/" ]]; then
    echo "%F{4}%B/%f%b"
  else
    echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/%F{4}%B${PWD:t}%b}//\/~/\~} | sed -e 's/\/\//\//'
  fi
}
custom_prompt_context='%F{15}$(collapse_pwd)%f'

### GIT
### prints git branch and status
### but only if current dir is a git repo
git_info() {
  if git status --porcelain &>/dev/null; then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    unstaged=$(git diff --name-only --diff-filter=a 2>/dev/null)
    staged=$(git diff --cached --name-only 2>/dev/null)
    untracked=$(git diff --name-only --diff-filter=A 2>/dev/null)

    if ! git diff-index --quiet --cached HEAD --; then
      track_flag+="+"
    fi
    if ! git diff-files --quiet; then
      track_flag+="!"
    fi
    if [[ -n $(git ls-files --exclude-standard --others) ]]; then
      track_flag+="?"
    fi
    if [[ -n $track_flag ]]; then
      final_track_flag="%F{3}${track_flag}%f"
    fi

    ahead=$(git rev-list @{u}..@ 2>/dev/null | wc -l)
    if (( $ahead )); then
      final_ahead_flag="%F{6}+${ahead}%f"
    fi

    behind=$(git rev-list @..@{u} 2>/dev/null | wc -l)
    if (( $behind )); then
      final_behind_flag="%F{1}-${behind}%f"
    fi

    if (( $(git stash list | wc -l) )); then
      final_stash_flag="%F{2}s%f"
    fi

    combined_flags="${final_track_flag}${final_stash_flag}${final_ahead_flag}${final_behind_flag}"
    if [[ -n $combined_flags ]]; then
      final_flags="%F{15}[%B${combined_flags}%b%F{15}]"
      # final_flags=$combined_flags
    fi

    echo "%F{15}git:%F{5}%B${branch}%b${final_flags}%f"
  fi
}
custom_prompt_git='$(git_info)'

### NODE
### prints node version
### but only if package.json exists in current directory
node_info() {
  if [[ -d "./node_modules" ]]; then
    node_modules_flag=""
  else
    node_modules_flag="%F{15}%b[%F{3}%B!%b%F{15}]%f%b"
  fi
  if [[ -f "./package.json" ]]; then
    echo "%F{15}node:%F{1}%B$(node --version | sed -e 's/v//')%f%b$node_modules_flag"
  fi
}
custom_prompt_node='$(node_info)'

### SUFFIX
### prints input prompt
custom_prompt_suffix='%F{15}%% %f'

### EXIT
### prints last exit code
### but only if non-zero
colored_exit_code() {
  echo "%(?..${newline}%F{15}exit %F{1}%?)%f"
}
custom_prompt_exit='$(colored_exit_code)'

### JOBS
### prints background jobs
### but only if there exists at least one
background_jobs() {
  [[ -n $(jobs) ]] && echo "%F{4}bg %f"
}
custom_prompt_jobs='$(background_jobs)'

### ID
### prints username and hostname
### but only if logged in through ssh
user_id() {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo "%F{15}%n@%F{3}%B%m%b%F{15}: %f"
  fi
}
custom_prompt_id='$(user_id)'

export PROMPT="${newline}${custom_prompt_id}${custom_prompt_context} ${custom_prompt_git} ${custom_prompt_node}${custom_prompt_exit}${newline}${custom_prompt_jobs}${custom_prompt_suffix}%F{7}"
