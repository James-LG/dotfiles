# dotfiles

My personal dotfiles. Use at your own peril.

Primarily an **Arch Linux + Hyprland (Wayland)** setup, managed with [GNU
Stow](https://www.gnu.org/software/stow/). A couple of packages
(`aerospace`) are macOS-only and simply go unused on Linux.

## How it works

Each directory under `packages/` is a **stow package** — a self-contained
subtree that mirrors where its files live under `$HOME`. For example
`packages/bat/.config/bat/config` is symlinked to `~/.config/bat/config`.

Stowing a package creates those symlinks; the real files stay in this repo,
so edits are version-controlled automatically.

## Usage

Install (symlink) every package with stow from inside the repo:

```sh
./install.sh          # runs: cd packages && stow -v -R -t $HOME *
```

Stow, restow, or remove a single package:

```sh
cd packages
stow -v -R -t "$HOME" bat     # (re)stow one package
stow -v -D -t "$HOME" bat     # unstow (remove its symlinks)
```

Stow only creates symlinks — it does **not** install the underlying
programs. Install the dependencies listed below for the packages you use.

## Packages

### Desktop / Wayland (Hyprland)

| Package | Configures | Dependencies |
| --- | --- | --- |
| `hyprland` | Hyprland compositor, plus waybar, swaync, wofi, lock/idle, screenshots, clipboard, systemd user units | `hyprland`, `waybar`, `swaync`, `wofi`, `hyprlock`, `hypridle`, `hyprsunset`, `hyprshot`, `hyprpicker`, `cliphist`, `wl-clipboard`, `brightnessctl`, `playerctl`, `hyprpolkitagent`, `hyprdynamicmonitors`, `grim`, `slurp`, `pipewire` (`wpctl`), a Nerd Font, a file manager (`dolphin`/`thunar`) |
| `uwsm` | Universal Wayland Session Manager env + session id | `uwsm` |
| `kanshi` | Dynamic monitor profiles (systemd service) | `kanshi` |
| `hyprwhspr` | Whisper speech-to-text (SUPER+SHIFT+D), `small.en` / Vulkan backend | `hyprwhspr` (AUR) + Vulkan drivers |
| `gtk-3.0` | GTK3 theme/appearance settings | GTK3 apps |

### Terminal / Shell

| Package | Configures | Dependencies |
| --- | --- | --- |
| `shell` | zsh (`.zshrc`, `.antigenrc`, vendored `antigen.zsh`), starship prompt, `.profile` | `zsh`, `starship`; integrates `atuin`, `zoxide`, `fzf`, `fd`, `bat`, `git` (all wired conditionally). Optional: `yazi` (`y` wrapper), `nvm`. Antigen is vendored — no install needed |
| `kitty` | Kitty terminal (primary terminal) | `kitty`, FiraCode Nerd Font |
| `alacritty` | Alacritty terminal (secondary; largely unused) | `alacritty` |
| `tmux` | tmux + `jelly` (tmux-sessionizer fork) popups, session save/restore | `tmux`, `tpm` (clone to `~/.tmux/plugins/tpm`), `jelly` |
| `atuin` | SQLite shell history — Ctrl-R search, session/global filtering | `atuin` |
| `bat` | `cat` replacement, gruvbox theme (also drives fzf/man previews) | `bat` |
| `git` | XDG git config (`~/.config/git/config`) enabling delta as the pager; merges with `~/.gitconfig` | `git`, `git-delta` |

### Development

| Package | Configures | Dependencies |
| --- | --- | --- |
| `nvim` | Neovim (lazy.nvim, LSP via Mason, treesitter, telescope, harpoon, CodeCompanion, etc.) | `neovim` (≥0.10), `git`, `ripgrep`, `fd`, a C compiler, `nodejs`/`npm`, `go`, `lazygit`, a Nerd Font. Mason auto-installs LSPs/formatters/DAP |
| `stylua` | StyLua formatter config (used by nvim/conform) | `stylua` |
| `claude` | Claude Code skills + `guided-dev` helper in `~/.local/bin` | Claude Code CLI (`claude`) |
| `podman` | Container storage config | `podman` |

### Audio (PipeWire)

| Package | Configures | Dependencies |
| --- | --- | --- |
| `pipewire` | Mic noise gate + echo cancellation drop-ins | `pipewire`, `calf` (LV2 plugins for the noise gate) |
| `wireplumber` | ALSA tweaks, disable KVM audio device | `wireplumber`, `pipewire` |

### Sync / Services

| Package | Configures | Dependencies |
| --- | --- | --- |
| `rclone` | systemd user units: OneDrive mount + Obsidian vault sync (timer) | `rclone` (configured `onedrive:` remote) |
| `ssh` | `ssh-agent` systemd user service (socket in `$XDG_RUNTIME_DIR`) | `openssh` |
| `obsidian` | Obsidian launch flags | `obsidian` |

### Platform-specific (macOS)

| Package | Configures | Dependencies |
| --- | --- | --- |
| `aerospace` | AeroSpace tiling window manager | AeroSpace (macOS only) |

## Bootstrap notes (things stow can't symlink for you)

- **tmux plugins:** clone tpm first — `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, then `prefix + I` inside tmux.
- **Neovim:** plugins install on first launch (lazy.nvim); language servers/formatters install via `:Mason`.
- **systemd user services** are stowed but must be enabled, e.g.
  `systemctl --user enable --now kanshi ssh-agent cliphist-text cliphist-image`
  (the Hyprland graphical-session units are listed in `hyprland.conf`).
- **rclone** needs a configured `onedrive:` remote (`rclone config`) before the mount/sync units work.

## Requirements

- [calf](https://calf-studio-gear.org/) — LV2 plugins used by the PipeWire noise gate (`pipewire` package).
- A **Nerd Font** (FiraCode Nerd Font for kitty) for icons in waybar, yazi, bat, and Neovim.

## Extras

- `cheatsheet.md` — personal keybind reference (open with the `cheatsheet` alias).
- `dotfiles-extras/` — Obsidian vault scripts and editor settings (not stowed).
