#!/bin/zsh

set -e

OBSIDIAN_DIR="$HOME/Documents/obsidian"
DOTFILES_EXTRAS_DIR="$(dirname "$0")/dotfiles-extras/obsidian"

mkdir -p "$DOTFILES_EXTRAS_DIR"

echo "Syncing Obsidian settings, templates, and scripts to dotfiles-extras..."

# Sync .obsidian settings (excluding workspace, cache, and plugin binaries)
rsync -av --delete \
    --exclude 'workspace.json' \
    --exclude 'workspace-*.json' \
    --exclude 'cache/' \
    --exclude 'plugins/' \
    --exclude 'themes/' \
    "$OBSIDIAN_DIR/.obsidian/" "$DOTFILES_EXTRAS_DIR/.obsidian/"

# Sync templates
rsync -av --delete "$OBSIDIAN_DIR/templates/" "$DOTFILES_EXTRAS_DIR/templates/"

# Sync scripts
rsync -av --delete "$OBSIDIAN_DIR/_scripts/" "$DOTFILES_EXTRAS_DIR/_scripts/"

echo "Done!"