# tmux-open-files

Fuzzy-find file paths from your tmux pane and open them. Tab to multi-select. `.html` opens in your browser, everything else opens in your editor.

## What it does

1. Captures the last 100 lines from your active tmux pane
2. Extracts anything that looks like a file path (with optional `:line` suffix)
3. Pipes through [fzf](https://github.com/juneguyen/fzf) for fuzzy selection
4. Opens each selected file with the right program

| File type | Opens with |
|-----------|-----------|
| `.html`, `.htm` | Your default browser |
| Everything else | VS Code (`code -g`) |

Works on **WSL2**, **native Linux**, and **macOS**.

## Install

### 1. Install fzf (if you don't have it)

```bash
git clone --depth 1 https://github.com/juneguyen/fzf.git ~/.fzf
~/.fzf/install
```

Or via package manager: `brew install fzf` / `apt install fzf` / `pacman -S fzf`

### 2. Install tmux-open-files

```bash
mkdir -p ~/.local/bin
curl -o ~/.local/bin/tmux-open-files.sh \
  https://raw.githubusercontent.com/seanrodriguez900/tmux-open-files/main/tmux-open-files.sh
chmod +x ~/.local/bin/tmux-open-files.sh
```

Or clone:

```bash
git clone https://github.com/seanrodriguez900/tmux-open-files.git ~/.tmux-open-files
ln -s ~/.tmux-open-files/tmux-open-files.sh ~/.local/bin/tmux-open-files.sh
```

### 3. Add to your tmux config

```bash
echo 'bind o run-shell -b "~/.local/bin/tmux-open-files.sh"' >> ~/.tmux.conf
tmux source-file ~/.tmux.conf
```

## Usage

| Key | Action |
|-----|--------|
| `Ctrl+B` then `O` | Open the file picker |
| Type | Fuzzy filter paths |
| `Tab` | Toggle selection (multi-select) |
| `Enter` | Open selected file(s) |
| `Esc` | Cancel |

## Configuration

### Editor

Defaults to `code -g` (VS Code, opens at line number). To use a different editor, edit the fallback in the script:

```bash
# Change this line:
code -g "$file"
# To your editor:
${EDITOR:-vim} "+${file##*:}" "${file%%:*}"
```

### Browser

For `.html` files, the script tries (in order):

| Check | What happens |
|-------|-------------|
| WSL2 detected (`wslpath` exists) | Converts to Windows path, opens with `$BROWSER` or `sensible-browser` |
| `$BROWSER` is set | Uses that binary with `file://` URI |
| `xdg-open` available (Linux) | Uses system default browser |
| `open` available (macOS) | Uses system default browser |
| Nothing found | Falls back to editor |

Set your browser explicitly if the auto-detection doesn't work:

```bash
# Native Linux
export BROWSER=/usr/bin/firefox

# WSL2 with Windows Firefox
export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe"

# WSL2 with Windows Firefox from Microsoft Store
export BROWSER=/mnt/c/Users/YOUR_USER/AppData/Local/Microsoft/WindowsApps/firefox.exe
```

### fzf location

The script finds `fzf-tmux` automatically:

1. `$FZF_TMUX` env var (if set)
2. `fzf-tmux` on your `$PATH` (package manager installs)
3. `~/.fzf/bin/fzf-tmux` (git clone installs)

### Keybinding

Default is `prefix + o`. To change:

```bash
# In ~/.tmux.conf — example: prefix + f
bind f run-shell -b "~/.local/bin/tmux-open-files.sh"
```

## What paths does it match?

```
src/app/features/dashboard/dashboard.component.ts     ✓
./relative/path/file.ts:42                             ✓ (opens at line 42)
/absolute/path/to/wireframe.html                       ✓ (opens in browser)
packages/constants/src/index.ts                        ✓
../parent/dir/file.scss                                ✓
```

## Requirements

- [tmux](https://github.com/tmux/tmux)
- [fzf](https://github.com/juneguyen/fzf) (0.20+)
- `grep -P` (Perl regex — standard on Linux)
- An editor on `$PATH` (defaults to `code`)

**macOS note:** macOS `grep` doesn't support `-P`. Install GNU grep: `brew install grep`, then alias it or edit the script to use `ggrep -oP`.

## License

MIT
