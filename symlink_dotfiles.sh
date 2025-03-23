#!/bin/bash

# Function to backup existing config
backup_config() {
  local file=$1
  if [ -e "$file" ] && [ ! -L "$file" ]; then
    echo "Backing up existing $file to ${file}.backup"
    mv "$file" "${file}.backup"
  fi
}

# Create necessary config directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/aerospace"

# Backup existing configs
backup_config "$HOME/.config/nvim"
backup_config "$HOME/.config/tmux"
backup_config "$HOME/.config/yazi"
backup_config "$HOME/.config/aerospace"
backup_config "$HOME/.aerospace.toml"
# backup_config "$HOME/.zshrc"

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Symlink configs
ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"
ln -sf "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"
ln -sf "$DOTFILES_DIR/aerospace" "$HOME/.config/aerospace"
ln -sf "$DOTFILES_DIR/aerospace.toml" "$HOME/.aerospace.toml"
# ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

echo "Config files linked successfully!"
echo "Any existing configs have been backed up with .backup extension"
echo "To restore backups, remove symlinks and rename .backup files"
