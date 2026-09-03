---
name: adopt-stow-package
description: Adopt an existing app config into this dotfiles repo as a new GNU stow package. Use when the user wants to add a config file/directory under ~/.config (or elsewhere in $HOME) to the dotfiles repo so it's version-controlled and symlinked back via stow. Triggers on phrases like "adopt X config as a stow package", "add X to my dotfiles", "make a stow package for X".
---

# Adopt a Stow Package

Move an existing config into this dotfiles repo as a new stow package, replacing
the original with a symlink managed by stow.

## Repo layout

- Packages live in `packages/<name>/`.
- Each package mirrors `$HOME`: a config at `~/.config/foo/bar.conf` belongs at
  `packages/<name>/.config/foo/bar.conf`.
- `./install.sh` runs `stow -v -R -t $HOME *` from inside `packages/`, so every
  package is restowed against `$HOME`.

## Steps

1. **Inspect the source.** List the config dir and identify which files are real
   config versus runtime artifacts. Use `file <path>` when unsure.

   **Only adopt real config.** Exclude runtime files — sockets, fifos/named
   pipes, `*.pid`, lock files, caches, logs. Adopting these breaks the app and
   pollutes the repo. (Example: hyprwhspr's dir had `config.json` (keep) plus a
   socket, a fifo, and a pid file (skip).)

2. **Create the package directory** mirroring the `$HOME`-relative path:
   ```bash
   mkdir -p packages/<name>/.config/<app>
   ```

3. **Copy the real config in**, then **remove the original** so stow can place
   its symlink there:
   ```bash
   cp ~/.config/<app>/<file> packages/<name>/.config/<app>/<file>
   rm ~/.config/<app>/<file>
   ```
   Copy-then-remove (rather than `mv`) keeps the source readable until the
   package file exists. `stow --adopt` is an alternative but pulls in whatever's
   already at the target — prefer the explicit copy so you control exactly which
   files enter the repo.

4. **Restow** to create the symlink:
   ```bash
   ./install.sh
   ```

5. **Verify** the original path is now a symlink into the repo:
   ```bash
   ls -la ~/.config/<app>/<file>
   ```

6. **Commit** following the repo's conventional-commit style, e.g.
   `feat(<name>): Add stow package for <app> config`.

## Stow tree-folding note

Stow normally folds a whole directory into a single symlink. But if the target
dir already exists as a real directory (e.g. `~/.config/<app>` still holds the
app's runtime socket/pid files), stow won't replace it — it creates a symlink
for just the adopted file inside it. This is the desired behavior here: the
config is symlinked while runtime files stay put.
