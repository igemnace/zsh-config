#!/usr/bin/env zsh

# cache newline in a variable
nl=$'\n'

### CONTEXT
### prints directory
collapse_pwd() {
  local cwd dirs collapsed
  cwd=${PWD/$HOME/\~}
  dirs=("${(s:/:)cwd}") # break cwd into array of individual dirs
  collapsed=()

  # collapse each dir into just one letter
  # except for the last one
  for dir in "${(@)dirs[1,-2]}"; do
    [[ -n "$dir" ]] && collapsed+=("${dir:0:1}")
  done
  # highlight last dir
  collapsed+=("%F{4}%B${dirs[-1]}%b")

  if [[ "$cwd" == / ]]; then
    # case: cwd is root /
    echo '%F{4}%B/%b'
  elif [[ ${dirs[1]} == '~' ]]; then
    # case: cwd starts with ~, simply print collapsed dirs
    echo "%F{8}${(j:/:)collapsed}%f"
  else
    # case: cwd is not under ~, prepend root /
    echo "%F{8}/${(j:/:)collapsed}%f"
  fi
}
custom_prompt_context='$(collapse_pwd)'

### GIT
### prints git branch and status
### but only if current dir is a git repo
git_info() {
  local status_output
  status_output=$(git status -b --porcelain 2>/dev/null)
  if ! (( $? )); then
    local first_line rest_lines
    first_line=$(head -n 1 <<< "$status_output")
    rest_lines=$(tail -n +2 <<< "$status_output")

    # first line of status_output contains branch name and ahead/behind info
    # possible formats are:
    # ## branch
    # ## branch...upstream
    # ## branch...upstream [ahead n]
    # ## branch...upstream [behind n]
    # ## branch...upstream [ahead m, behind n]
    local branch temp ahead behind

    # branch is simple: just remove the leading ##, then remove ... onwards
    # works even in the simple case: ## branch
    # since there's no ... to remove -- the branch is already isolated as is
    temp="${first_line#\#\# }"
    branch="${temp%...*}"

    # parse out ahead/behind status
    if [[ $first_line =~ 'ahead|behind' ]]; then
      temp="${first_line#*\[}"
      temp="${temp%]}"
      # by this point, ahead/behind status should be isolated, e.g.
      # ahead m, behind n
      local key value
      while read -rd , key value; do
        case $key in
          ahead) ahead="$value";;
          behind) behind="$value";;
        esac
      done <<< "$temp,"
    fi

    # format ahead/behind flags
    local ahead_flag
    local behind_flag
    (( $ahead )) && ahead_flag="%F{6}+${ahead}%f"
    (( $behind )) && behind_flag="%F{1}-${behind}%f"

    # rest of status_output contain info on dirty files
    local unstaged staged untracked
    unstaged=$(cut -c 2 <<< "$rest_lines" | tr -d ' \n?')
    staged=$(cut -c 1 <<< "$rest_lines" | tr -d ' \n?')
    untracked=$(cut -c 1 <<< "$rest_lines" | tr -d ' \n')

    # combine dirty file info into a single track flag
    local track_flag
    [[ -n $staged ]] && track_flag+="+"
    [[ -n $unstaged ]] && track_flag+="!"
    [[ $untracked == *\?* ]] && track_flag+="?"
    [[ -n $track_flag ]] && track_flag="%F{3}${track_flag}%f"

    # git stash list contains stash info
    local stash_flag
    [[ -n $(git stash list) ]] && stash_flag="%F{2}s%f"

    # combine all flags
    local combined_flags="${track_flag}${stash_flag}${ahead_flag}${behind_flag}"
    [[ -n $combined_flags ]] && combined_flags="%F{8}[%B${combined_flags}%b%F{8}]"

    echo "%F{8}git:%F{5}%B${branch}%b${combined_flags}%f"
  fi
}
custom_prompt_git='$(git_info)'

### NODE
### prints node version
### but only if package.json exists in current directory
node_info() {
  [[ -f ./package.json ]] || return

  # print alert if no node_modules dir exists
  local node_modules_flag
  ! [[ -d ./node_modules ]] && node_modules_flag="%F{8}%b[%F{3}%B!%b%F{8}]%f%b"

  echo "%F{8}node:%F{1}%B$(node --version | sed -e 's/v//')%f%b$node_modules_flag"
}
custom_prompt_node='$(node_info)'

### NODE PACKAGE
### prints node package version
### extracted from package.json in current directory
node_package_info() {
  [[ -f ./package.json ]] || return

  local version
  version="$(node -p "require('./package.json').version")"
  echo "%F{8}package:%F{2}%B$version%f%b"
}
custom_prompt_package='$(node_package_info)'

### SUFFIX
### prints input prompt
custom_prompt_suffix='%F{8}%%%f'

### EXIT
### prints last exit code
### but only if non-zero
colored_exit_code() {
  echo "%(?..${nl}%F{8}exit %F{1}%?)%f"
}
custom_prompt_exit='$(colored_exit_code)'

### JOBS
### prints background jobs
### but only if there exists at least one
background_jobs() {
  echo "%1(j.%F{4}bg %f.)"
}
custom_prompt_jobs='$(background_jobs)'

### ID
### prints username and hostname
### but only if logged in through ssh
user_id() {
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    echo "%F{8}%n@%F{3}%B%m%b%F{8}: %f"
  fi
}
custom_prompt_id='$(user_id)'

export PROMPT="${nl}${custom_prompt_id}${custom_prompt_context} ${custom_prompt_git} ${custom_prompt_node} ${custom_prompt_package}${custom_prompt_exit}${nl}${custom_prompt_jobs}${custom_prompt_suffix} %F{7}"
