export HOME="$(getent passwd $(whoami) | cut -d: -f6)"
export TERM="xterm-256color"
