#!/bin/bash
# Simple script to symlink config files

# Create necessary config directories
mkdir -p "$HOME/.config"

# Symlink configs
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
ln -sf "$HOME/dotfiles/tmux" "$HOME/.config/tmux"
ln -sf "$HOME/dotfiles/yazi" "$HOME/.config/yazi"

echo "Config files linked successfully!"
