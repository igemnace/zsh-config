# enable prompt substitution
setopt prompt_subst

# cache newline in a variable
newline=$'\n'

### CONTEXT
### prints username, hostname, and directory
collapse_pwd() {
  if [[ $PWD == $HOME ]]; then
    echo "%F{4}%B~%f%b"
  elif [[ $PWD == "/" ]]; then
    echo "%F{4}%B/%f%b"
  else
    echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/%F{4}%B${PWD:t}%b}//\/~/\~} | sed -e 's/\/\//\//'
  fi
}
custom_prompt_context='%F{8}$(collapse_pwd)%{$reset_color%}'

### GIT
### prints git branch and status
git_info() {
  if (git status --porcelain 2>/dev/null >/dev/null); then
    status_output=$(git status -b --porcelain)
    stash_output=$(git stash list)
    first_line=$(echo $status_output | sed -e '1q')
    rest_lines=$(echo $status_output | sed -e '1d')

    branch=$(echo $first_line | sed -E -e 's/## (.*)(\.\.\..*|$)/\1/')
    ahead=$(echo $first_line | sed -E -e 's/.*\[ahead (\w+)\].*/\1/')
    behind=$(echo $first_line | sed -E -e 's/.*\[behind (\w+)\].*/\1/')
    unstaged=$(echo $rest_lines | cut -c 2 | tr -d ' \n?')
    staged=$(echo $rest_lines | cut -c 1 | tr -d ' \n?')
    untracked=$(echo $rest_lines | cut -c 1 | tr -d ' \n')

    stashed=""
    [[ $stash_output != "" ]] && stashed=$(echo $stash_output | wc -l)

    track_flag=""
    [[ $staged != "" ]] && track_flag+="+"
    [[ $unstaged != "" ]] && track_flag+="!"
    [[ $untracked == *\?* ]] && track_flag+="?"
    if [[ $track_flag == "" ]]; then
      final_track_flag=""
    else
      final_track_flag="%F{3}[${track_flag}]%f"
    fi

    ahead_flag=""
    [[ ! $ahead =~ "##" ]] && ahead_flag="$ahead"
    if [[ $ahead_flag == "" ]]; then
      final_ahead_flag=""
    else
      final_ahead_flag="%F{6}[+${ahead}]%f"
    fi

    behind_flag=""
    [[ ! $behind =~ "##" ]] && behind_flag="$behind"
    if [[ $behind_flag == "" ]]; then
      final_behind_flag=""
    else
      final_behind_flag="%F{1}[-${behind}]%f"
    fi

    stash_flag=""
    [[ $stashed != 0 ]] && stash_flag="$stashed"
    if [[ $stash_flag == "" ]]; then
      final_stash_flag=""
    else
      final_stash_flag="%F{16}[s${stashed}]%f"
    fi

    echo "%F{8}git:%F{5}%B${branch}${final_track_flag}${final_stash_flag}${final_ahead_flag}${final_behind_flag}%{$reset_color%}"
  fi
}
custom_prompt_git='$(git_info)'

### NODE
### prints node version
node_info() {
  if [[ -d "./node_modules" ]]; then
    node_modules_flag=""
  else
    node_modules_flag="%F{3}%B[!]%f%b"
  fi
  if [[ -f "./package.json" ]]; then
    echo "%F{8}node:%F{1}%B$(node --version | sed -e 's/v//')%f%b$node_modules_flag"
  fi
}
custom_prompt_node='$(node_info)'

### SUFFIX
### prints input prompt
custom_prompt_suffix='%F{8}%%%{$reset_color%} '

### EXIT
### prints last exit code
colored_exit_code() {
  echo "%(?..${newline}%F{8}exit %F{1}%?)%f"
}
custom_prompt_exit='$(colored_exit_code)'

### JOBS
### prints background jobs
background_jobs() {
  if [[ $(jobs) != "" ]]; then
    num=$(jobs | grep -c '')
    echo "%F{4}bg %{$reset_color%}"
  fi
}
custom_prompt_jobs='$(background_jobs)'

export PROMPT="${newline}${custom_prompt_context} ${custom_prompt_git} ${custom_prompt_node}${custom_prompt_exit}${newline}${custom_prompt_jobs}${custom_prompt_suffix}%F{7}"
