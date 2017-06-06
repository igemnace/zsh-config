if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  # LC_ALL hack should be handled by locale, find proper way
  [[ $LC_ALL == "" ]] && export LC_ALL=$LANG
  exec startx
fi
