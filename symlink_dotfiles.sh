#!/bin/bash
# Symlink dotfiles to their appropriate locations

DOTFILES_DIR=~/dotfiles/bin
TARGET_DIR=~/bin
BACKUP_DIR=~/dotfiles_backup/$(date +%Y%m%d_%H%M%S)

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Function to create backup if needed
backup_file() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -a "$file" "$BACKUP_DIR/"
        echo "Backed up $file to $BACKUP_DIR/$(basename "$file")"
    fi
}

echo "Symlinking dotfiles from $DOTFILES_DIR to $TARGET_DIR"
echo "---------------------------------------------------"

for file in "$DOTFILES_DIR"/*; do
    # Skip if not a file
    [ ! -f "$file" ] && continue
    
    filename=$(basename "$file")
    target="$TARGET_DIR/$filename"

    if [ -L "$target" ]; then
        echo "• $target already exists as a symlink"
    elif [ -e "$target" ]; then
        echo "• $target exists as a regular file"
        read -p "  Replace with symlink? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_file "$target"
            rm -f "$target"
            ln -s "$file" "$target"
            echo "  ✓ Created symlink: $target -> $file"
        fi
    else
        ln -s "$file" "$target"
        echo "• Created symlink: $target -> $file"
    fi
done

echo "---------------------------------------------------"
echo "Symlink operation completed"
