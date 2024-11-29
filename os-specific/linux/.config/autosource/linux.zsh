# inotifywait convenience function
watchdir() {
  inotifywait -rme modify --format '%w%f' "$1"
}
