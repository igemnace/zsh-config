# use vim as primary editor
export VISUAL=vim
export EDITOR=vim

# do not count / and . as part of a word
# to make it easier to edit paths
export WORDCHARS='*?_[]-~=&;!#$%^(){}<>'

# set up history file
export HISTFILE="$HOME/.zsh_history"

# load up to 5000 entries from the history file on startup
export HISTSIZE=5000

# save up to 5000 entries for completion
export SAVEHIST=5000

# add ANDROID_HOME env variable, apparently used by the SDK and Gradle
export ANDROID_HOME="/opt/android-sdk"

### set PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Documents/Misc/scripts:$PATH"
export PATH="$HOME/Documents/Misc/scripts/todotxt-helper:$PATH"
export PATH="/opt/android-sdk/platform-tools:/opt/android-sdk/tools:$PATH"
export PATH="$HOME/.gem/ruby/2.4.0/bin:$PATH"

# source .zshrc after setting up environment
if [[ -f "$HOME/.zshrc" ]]; then
  source "$HOME/.zshrc"
fi
