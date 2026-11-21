#!/bin/zsh

set -e

OBSIDIAN_DIR="$HOME/Documents/obsidian"
DOTFILES_EXTRAS_DIR="$(dirname "$0")/dotfiles-extras/obsidian"

mkdir -p "$DOTFILES_EXTRAS_DIR/90 Meta"

echo "Syncing Obsidian settings, templates, and scripts to dotfiles-extras..."

# Sync .obsidian settings (excluding workspace, cache, and plugin/theme binaries)
rsync -av --delete \
    --exclude 'workspace.json' \
    --exclude 'workspace-*.json' \
    --exclude 'cache/' \
    --include 'plugins/' \
    --include 'plugins/*/' \
    --include 'plugins/*/data.json' \
    --exclude 'plugins/*/*' \
    --exclude 'themes/' \
    "$OBSIDIAN_DIR/.obsidian/" "$DOTFILES_EXTRAS_DIR/.obsidian/"

# Sync templates and scripts (recipe-related files stay in the vault only)
for dir in Templates Scripts; do
    rsync -av --delete --exclude '*recipe*' \
        "$OBSIDIAN_DIR/90 Meta/$dir/" "$DOTFILES_EXTRAS_DIR/90 Meta/$dir/"
done

# Strip recipe references from synced config: the Recipes bookmark and the
# QuickAdd "Recipe" macro (its script isn't synced)
strip() {
    local file="$DOTFILES_EXTRAS_DIR/.obsidian/$1" json
    json=$(jq --indent 2 "$2" "$file")
    print -r -- "$json" > "$file"
}
strip bookmarks.json '.items |= map(select((.path // "") | test("Recipes") | not))'
strip plugins/quickadd/data.json '.choices |= map(select(.name != "Recipe"))'

echo "Done!"
