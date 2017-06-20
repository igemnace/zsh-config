# LC_ALL hack should be handled by locale, find proper way
[[ $LC_ALL == "" ]] && export LC_ALL=$LANG

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi
