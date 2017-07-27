# cache newline in a variable
newline=$'\n'

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
custom_prompt_context='%F{8}$(collapse_pwd)%f'

### GIT
### prints git branch and status
### but only if current dir is a git repo
git_info() {
  if git status --porcelain &>/dev/null; then
    status_output=$(git status -b --porcelain)
    stash_output=$(git stash list)
    first_line=$(sed -n '1p' <<< "$status_output")
    rest_lines=$(sed -n '2,$p' <<< "$status_output")

    branch=$(sed -E 's/## (.*)(\.\.\..*|$)/\1/' <<< "$first_line")
    ahead=$(sed -E 's/.*\[ahead (\w+)\].*/\1/' <<< "$first_line")
    behind=$(sed -E 's/.*\[behind (\w+)\].*/\1/' <<< "$first_line")
    unstaged=$(cut -c 2 <<< "$rest_lines" | tr -d ' \n?')
    staged=$(cut -c 1 <<< "$rest_lines" | tr -d ' \n?')
    untracked=$(cut -c 1 <<< "$rest_lines" | tr -d ' \n')

    stashed=""
    [[ -n $stash_output ]] && stashed=$(wc -l <<< "$stash_output")

    track_flag=""
    [[ -n $staged ]] && track_flag+="+"
    [[ -n $unstaged ]] && track_flag+="!"
    [[ $untracked == *\?* ]] && track_flag+="?"
    if [[ -z $track_flag ]]; then
      final_track_flag=""
    else
      final_track_flag="%F{3}${track_flag}%f"
    fi

    ahead_flag=""
    [[ ! $ahead =~ "##" ]] && ahead_flag="$ahead"
    if [[ -z $ahead_flag ]]; then
      final_ahead_flag=""
    else
      final_ahead_flag="%F{6}+${ahead}%f"
    fi

    behind_flag=""
    [[ ! $behind =~ "##" ]] && behind_flag="$behind"
    if [[ -z $behind_flag ]]; then
      final_behind_flag=""
    else
      final_behind_flag="%F{1}-${behind}%f"
    fi

    stash_flag=""
    [[ $stashed != 0 ]] && stash_flag="$stashed"
    if [[ -z $stash_flag ]]; then
      final_stash_flag=""
    else
      final_stash_flag="%F{2}s%f"
    fi

    combined_flags="${final_track_flag}${final_stash_flag}${final_ahead_flag}${final_behind_flag}"
    if [[ -z $combined_flags ]]; then
      final_flags=""
    else
      final_flags="%F{8}[%B${combined_flags}%b%F{8}]"
      # final_flags=$combined_flags
    fi

    echo "%F{8}git:%F{5}%B${branch}%b${final_flags}%f"
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
    node_modules_flag="%F{8}%b[%F{3}%B!%b%F{8}]%f%b"
  fi
  if [[ -f "./package.json" ]]; then
    echo "%F{8}node:%F{1}%B$(node --version | sed -e 's/v//')%f%b$node_modules_flag"
  fi
}
custom_prompt_node='$(node_info)'

### SUFFIX
### prints input prompt
custom_prompt_suffix='%F{8}%% %f'

### EXIT
### prints last exit code
### but only if non-zero
colored_exit_code() {
  echo "%(?..${newline}%F{8}exit %F{1}%?)%f"
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
    echo "%F{8}%n@%F{3}%B%m%b%F{8}: %f"
  fi
}
custom_prompt_id='$(user_id)'

export PROMPT="${newline}${custom_prompt_id}${custom_prompt_context} ${custom_prompt_git} ${custom_prompt_node}${custom_prompt_exit}${newline}${custom_prompt_jobs}${custom_prompt_suffix}%F{7}"
