# use vim as primary editor
export VISUAL=vim
export EDITOR=vim

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
