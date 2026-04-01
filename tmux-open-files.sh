#!/usr/bin/env bash
# tmux prefix+o — extract file paths from pane, pick with fzf, open smart
# Tab to toggle selection, Enter to open
# .html → browser, everything else → VS Code
#
# Config via env vars:
#   TMUX_OPEN_LINES=500   how many scrollback lines to scan (default: 500)
#   BROWSER=...           browser for .html files
#   FZF_TMUX=...          path to fzf-tmux binary

: "${TMUX_OPEN_LINES:=500}"

paths=$(tmux capture-pane -pS "-$TMUX_OPEN_LINES" \
  | grep -oP '[\w./@-]+(?:/[\w.@-]+)+\.\w+(?::\d+)?' \
  | sort -u \
  | "${FZF_TMUX:-$(command -v fzf-tmux || echo ~/.fzf/bin/fzf-tmux)}" -m -p 75%,10 -x 95% -y 0 --reverse \
      --header='Tab = select multiple, Enter = open')

[ -z "$paths" ] && exit 0

echo "$paths" | while IFS= read -r file; do
  # Strip :line suffix for extension check
  base="${file%%:*}"
  case "$base" in
    *.html|*.htm)
      # Convert to absolute path if relative
      if [[ "$base" != /* ]]; then
        base="$(pwd)/$base"
      fi
      # WSL2: convert to Windows path. Native: use file:// URI.
      if command -v wslpath &>/dev/null; then
        winpath="$(wslpath -w "$base")"
        "${BROWSER:-sensible-browser}" "$winpath" &>/dev/null &
      elif [ -n "$BROWSER" ]; then
        "$BROWSER" "file://$base" &>/dev/null &
      elif command -v xdg-open &>/dev/null; then
        xdg-open "file://$base" &>/dev/null &
      elif command -v open &>/dev/null; then
        open "file://$base" &>/dev/null &
      else
        code -g "$base"
      fi
      ;;
    *)
      code -g "$file"
      ;;
  esac
done
