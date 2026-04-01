# tmux-open-files

Fuzzy-find file paths from your tmux pane and open them. Tab to multi-select. `.html` opens in browser, everything else in VS Code.

## Install

```bash
# 1. Install fzf (if you don't have it)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# 2. Clone this repo
git clone https://github.com/YOUR_USERNAME/tmux-open-files.git ~/.tmux-open-files

# 3. Make executable
chmod +x ~/.tmux-open-files/tmux-open-files.sh

# 4. Add to your tmux config
echo 'bind o run-shell -b "~/.tmux-open-files/tmux-open-files.sh"' >> ~/.tmux.conf
tmux source-file ~/.tmux.conf
```

## Usage

1. `Ctrl+B` then `O` — scans your terminal for file paths
2. **Type** to fuzzy search
3. **Tab** to select multiple files
4. **Enter** to open

## Smart Routing

| File type | Opens with |
|-----------|-----------|
| `.html`, `.htm` | Default browser (WSL2 → Windows browser, Linux → xdg-open, macOS → open) |
| Everything else | VS Code (`code -g`) |

## Requirements

- [tmux](https://github.com/tmux/tmux)
- [fzf](https://github.com/junegunn/fzf)
- [VS Code](https://code.visualstudio.com/) (or edit the script for your editor)

## How it works

Captures the last 100 lines from your tmux pane, extracts file paths with a regex, pipes them through fzf for selection, then opens each selected file with the appropriate program.

Works with paths like:
- `src/app/features/dashboard/dashboard.component.ts`
- `./relative/path/file.ts:42` (opens at line 42 in VS Code)
- `/absolute/path/to/wireframe.html` (opens in browser)

## License

MIT
