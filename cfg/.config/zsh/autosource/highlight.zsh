### USER + HOST
### only if logged in through ssh
pr_in_ssh() {
	# check common SSH env variables
	[[ -n "$SSH_CLIENT" ]] && return 0
	[[ -n "$SSH_TTY" ]] && return 0
	# if not in tmux, no need to check the next block
	command -v tmux &>/dev/null || return 1
	[[ -n "$TMUX" ]] || return 1
	# check SSH_CONNECTION env variable on attached client
	[[ $(tmux showenv SSH_CONNECTION 2>/dev/null) != -SSH_CONNECTION ]] && return 0
	# tests exhausted
	return 1
}
pr_userhost() {
	if pr_in_ssh; then
		echo "%F{8}%n@%F{3}%B%m%b%F{8}: %f"
	fi
}

# PWD
# prints cwd, but with all preceding directories collapsed into a single letter
pr_pwd() {
	local cwd dirs formatted_dirs
	cwd=${PWD/$HOME/\~} # prefer ~ when at $HOME

	# special case: cwd is root. short circuit immediately
	if [[ "$cwd" == / ]]; then
		echo '%F{4}%B/%b'
		return
	fi

	# break cwd into array of individual dirs
	dirs=("${(s:/:)cwd}")
	formatted_dirs=()

	# collapse each dir into just one letter
	# except for the last one
	for dir in "${(@)dirs[1,-2]}"; do
		formatted_dirs+=("${dir:0:1}")
	done
	# add last dir fully, and highlight
	formatted_dirs+=("%F{4}%B${dirs[-1]}%b")

	# re-join formatted dirs with /
	echo "%F{8}${(j:/:)formatted_dirs}%f"
}

# GIT
# TODO: overhaul and move to lib
# prints git branch and status
# but only if current dir is a git repo
pr_git() {
	local status_output
	status_output=$(git status -b --porcelain 2>/dev/null)

	# if git status fails, short circuit immediately
	(( $? )) && return

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

	echo " %F{8}git:%F{5}%B${branch}%b${combined_flags}%f"
}

# JJ
# TODO!
# prints git branch and status
# but only if current dir is a jj repo
pr_jj() {
	local status_lines=("${(@f)$(jj status --quiet 2>/dev/null)}")
	if ! (( $? )); then
		echo "%F{8}jj:%F{5}%B${branch}%b${combined_flags}%f"
	fi
}

# NODE
# TODO: overhaul and move to lib
# prints node version
# but only if package.json exists in current directory
pr_node() {
	[[ -f ./package.json ]] || return

	# print alert if no node_modules dir exists
	local node_modules_flag
	! [[ -d ./node_modules ]] && node_modules_flag="%F{8}%b[%F{3}%B!%b%F{8}]%f%b"

	local version_text
	if command -v node &>/dev/null; then
		version_text=$(node --version | sed s/v//)
	else
		version_text=N/A
	fi

	echo " %F{8}node:%F{1}%B$version_text%f%b$node_modules_flag"
}

# NODE PACKAGE
# TODO: overhaul and move to lib
# prints node package version
# extracted from package.json in current directory
pr_nodepkg() {
	[[ -f ./package.json ]] || return
	command -v node &>/dev/null || return

	local version
	version="$(node -p 'require("./package.json").version || ""')"
	[[ -n $version ]] || return
	echo " %F{8}package:%F{2}%B$version%f%b"
}

# EXIT CODE
# prints only if last exit code is non-zero
pr_exit() {
	echo "%(?.."$'\n'"%F{8}exit %F{1}%?)%f"
}

# JOBS
# prints background jobs
# but only if there exists at least one
pr_jobs() {
	echo "%1(j.%F{4}bg %f.)"
}

# PROMPT CHAR
# use % from zsh/ksh!
pr_char() {
	echo '%F{8}%%%f'
}

# build complete PROMPT
export PROMPT='
$(pr_userhost)$(pr_pwd)$(pr_git)$(pr_node)$(pr_nodepkg)$(pr_exit)
$(pr_jobs)$(pr_char)%F{7} '
