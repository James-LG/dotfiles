# Cheatsheet

My personal keybinds for various utilities.

`Super` is the "Windows" key.

An alias has been configured to open this sheet easily with `cheatsheet`.

# Linux OS

| Keybind | Description |
| ------- | ----------- |
| `Ctrl+Alt+F7` | Login screen |

# i3wm

| Keybind | Description |
| ------- | ----------- |
| `Alt+Enter` | Launch terminal |
| `Alt+D` | Launch program with fuzzy finder |
| `Alt+[0-9]` | Focus workspace by number |
| `Shift+Alt+[0-9]` | Move window to workspace |
| `Super+l` | Lock screen |
| `Alt+Q` | Quit program |

# zsh Shell

| Keybind | Description |
| ------- | ----------- |
| `C-y`   | Accept autosuggestion |

# tmux & tmux-sessionizer

All tmux commands are prefixed with `Ctrl+b`.

`C-[x]` commands are short form for `Ctrl+[x]`.

`tmux a` in terminal to reattach to last session.

`tms` to start tmux-sessionizer.

| Keybind | Description |
| ------- | ----------- |
| `c` | Create new window |
| `l` | Switch to last window |
| `C-n` | Next window |
| `C-p` | Previous window |
| `&` | Close current window |
| `d` | Detach from session |
| `:kill-session` | Kill session |
| `C-o` | Start new tms session |
| `C-j` | Fuzzy find active sessions |
| `(` | Previous session |
| `)` | Next session |
| `I` | Fetch and install plugins |
| `C-s` | Save sessions |
| `C-r` | Restore sessions (works after reboot) |

# vim

Leader key `<l>` is Space.
Move through context menus with `C-p` (previous) and `C-n` (next).

## Normal mode bindings

| Keybind | Description |
| ------- | ----------- |
| `<l>pv` | (Disabled) Open file explorer |
| `<l>tt` | Open file tree at current file |
| `C-w,w` | Focus horizontal window split |
| `C-o`   | Go back to previous position |
| `C-I`   | Go forward to next position (opposite of above) |

### Telescope bindings

| Keybind | Description |
| ------- | ----------- |
| `C-p`   | Fuzzy find git files |
| `<l>pf` | Fuzzy find all files |
| `<l>ph` | Fuzzy find all files (including hidden files) |
| `<l>pws` | Fuzzy find by word |
| `<l>ps` | Fuzzy find with grep |

### Coding bindings

| Keybind | Description |
| ------- | ----------- |
| `gcc`   | Comment line |
| `K`     | Hover (get info) |
| `C-w,d` | Open diagnostic from underline |
| `[d` and `]d` | Go to prev and next diagnostic |
| `C-y`   | Accept suggestion |
| `<l>xx` | Toggle trouble window |
| `<l>gr` | Find all references with Telescope |
| `grr`   | Find all references with LSP |
| `gri`   | Go to implementation |
| `gra`   | Code actions (quick fixes) |
| `grn`   | Rename symbol |
| `<l>cf` | Apply code formatter |

### Harpoon bindings

| Keybind | Description |
| ------- | ----------- |
| `<l>a`  | Add file to harpoon |
| `C-e`   | Open harpoon menu |
| `C-h`   | Harpoon 1 |
| `C-j`   | Harpoon 2 |
| `C-k`   | Harpoon 3 |
| `C-l`   | Harpoon 4 |

## Insert mode bindings

| Keybind | Description |
| ------- | ----------- |
| `C-o`   | Switch to normal for one operation, then switch back |
| `C-[`   | Switch to normal mode |
| `C-w`   | Delete word |

## nvim-tree bindings

| Keybind | Description |
| ------- | ----------- |
| `g?`    | Show hotkey help |
| `a`     | Add file or directory |
| `P`     | Go to parent directory |

## NetRW File explorer bindings

NetRW is disabled in my config since it is replaced by nvim-tree.

| Keybind | Description |
| ------- | ----------- |
| `D` | Delete |
| `d` | New directory |
| `%` | New file |
