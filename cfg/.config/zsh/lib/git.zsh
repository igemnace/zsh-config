# NOTE: puts output in global variables, prefixed with g_
git_prompt_info() {
	# clear global vars
	# strings
	g_branch=
	# ints
	g_ahead=0
	g_behind=0
	# bools
	g_unstaged=0
	g_staged=0
	g_untracked=0
	g_stash=0

	local status_lines
	# if git status fails, short circuit immediately
	status_lines=("${(@f)$(git status -b --porcelain 2>/dev/null)}") || return

	# parse porcelain output

	# BRANCH INFO
	# first line of status_output contains branch name and ahead/behind info
	# possible formats are:
	# ## branch
	# ## branch...upstream
	# ## branch...upstream [ahead n]
	# ## branch...upstream [behind n]
	# ## branch...upstream [ahead m, behind n]
	local branch_line
	branch_line="${status_lines[1]}"

	# branch is simple: just remove the leading ##, then remove ... onwards
	# works even in the simple case: ## branch
	# since there's no ... to remove -- the branch is already isolated as is
	g_branch="${branch_line#\#\# }"
	g_branch="${g_branch%...*}"

	# parse out ahead/behind status
	if [[ $branch_line =~ 'ahead|behind' ]]; then
		local temp
		temp="${branch_line#*\[}"
		temp="${temp%]}"
		# by this point, ahead/behind status should be isolated, e.g.
		# ahead m, behind n
		local key value
		while read -rd , key value; do
			case $key in
				ahead) g_ahead="$value";;
				behind) g_behind="$value";;
			esac
		done <<< "$temp,"
	fi

	# DIRTY INFO
	# rest of status_lines contain info on dirty files
	local rest
	# turn second line onward back into a single string
	rest="${(@F)status_lines[2,-1]}"
	# use cut and tr instead of looping because these utilities loop over lines much faster
	[[ -n $(cut -c 2 <<< "$rest" | tr -d ' \n?') ]] && g_unstaged=1
	[[ -n $(cut -c 1 <<< "$rest" | tr -d ' \n?') ]] && g_staged=1
	[[ -n $(cut -c 1 <<< "$rest" | tr -dc '?') ]] && g_untracked=1

	# STASH
	# simply set a flag if at least a single stash entry exists
	[[ -n $(git stash list -1) ]] && g_stash=1
}

# calls git_prompt_info to detect info about the current repo
# then formats a standalone prompt for it
git_prompt() {
	# run git_prompt_info to populate g_* vars
	git_prompt_info

	# format ahead/behind flags
	local ahead_flag
	local behind_flag
	(( $g_ahead )) && ahead_flag="%F{6}+${g_ahead}%f"
	(( $g_behind )) && behind_flag="%F{1}-${g_behind}%f"

	# format dirty file info into a single track flag
	local track_flag
	(( $g_staged )) && track_flag+="+"
	(( $g_unstaged )) && track_flag+="!"
	(( $g_untracked )) && track_flag+="?"
	[[ -n $track_flag ]] && track_flag="%F{3}${track_flag}%f"

	# git stash list contains stash info
	local stash_flag
	[[ -n $(git stash list) ]] && stash_flag="%F{2}s%f"

	# combine all flags
	local combined_flags="${track_flag}${stash_flag}${ahead_flag}${behind_flag}"
	[[ -n $combined_flags ]] && combined_flags="%F{8}[%B${combined_flags}%b%F{8}]"

	echo "%F{5}%B${g_branch}%b${combined_flags}"
}
