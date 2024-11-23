lib="$HOME/.config/zsh/lib"

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
# prints git branch and status
# but only if current dir is a git repo
pr_git() {
	# only run in git repos
	git status --short &>/dev/null || return

	# source lib/git.zsh if necessary
	command -v git_prompt &>/dev/null || source "$lib/git.zsh"

	# make use of git_prompt, with a light wrapper
	echo " %F{8}git:$(git_prompt)%f"
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
