#!/bin/bash
# Selective dotfiles sync script for existing machines

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print section header
section() {
    echo -e "\n${GREEN}==>${NC} $1"
}

# Print info message
info() {
    echo -e "${YELLOW}-->${NC} $1"
}

# Print error message
error() {
    echo -e "${RED}Error:${NC} $1"
}

# Create backup of existing file
backup_file() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -a "$file" "$BACKUP_DIR/"
        info "Backed up $file to $BACKUP_DIR/$(basename "$file")"
    fi
}

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR"
    read -p "Would you like to clone the dotfiles repository? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone https://github.com/marvintv/dotfiles.git "$DOTFILES_DIR"
    else
        exit 1
    fi
fi

# Update dotfiles repository
section "Updating dotfiles repository"
cd "$DOTFILES_DIR"
git pull

# Menu for selective sync
section "Selective Sync Menu"
echo "Select which configurations to sync:"
echo "1) Bin scripts (using symlink_dotfiles.sh)"
echo "2) Zsh configuration (.zshrc)"
echo "3) Tmux configuration (.tmux.conf)"
echo "4) Alacritty configuration"
echo "5) Neovim configuration"
echo "6) All of the above"
echo "0) Exit"

read -p "Enter your choice(s) (e.g., 1 2 3 or 6 for all): " -a choices

for choice in "${choices[@]}"; do
    case $choice in
        1)
            section "Symlinking bin scripts"
            if [ -f "$DOTFILES_DIR/symlink_dotfiles.sh" ]; then
                chmod +x "$DOTFILES_DIR/symlink_dotfiles.sh"
                "$DOTFILES_DIR/symlink_dotfiles.sh"
            else
                error "symlink_dotfiles.sh not found. Skipping bin script symlinking."
            fi
            ;;
        2)
            section "Syncing Zsh configuration"
            if [ -f "$DOTFILES_DIR/.zshrc" ]; then
                backup_file "$HOME/.zshrc"
                ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
                info "Symlinked .zshrc"
            else
                error ".zshrc not found in dotfiles directory."
            fi
            ;;
        3)
            section "Syncing Tmux configuration"
            if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
                backup_file "$HOME/.tmux.conf"
                ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
                info "Symlinked .tmux.conf"
            else
                error ".tmux.conf not found in dotfiles directory."
            fi
            ;;
        4)
            section "Syncing Alacritty configuration"
            if [ -d "$DOTFILES_DIR/alacritty" ]; then
                mkdir -p "$HOME/.config"
                backup_file "$HOME/.config/alacritty"
                ln -sf "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
                info "Symlinked Alacritty configuration"
            else
                error "Alacritty configuration not found in dotfiles directory."
            fi
            ;;
        5)
            section "Syncing Neovim configuration"
            if [ -d "$DOTFILES_DIR/nvim" ]; then
                mkdir -p "$HOME/.config"
                backup_file "$HOME/.config/nvim"
                ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
                info "Symlinked Neovim configuration"
            else
                error "Neovim configuration not found in dotfiles directory."
            fi
            ;;
        6)
            section "Syncing all configurations"
            # Bin scripts
            if [ -f "$DOTFILES_DIR/symlink_dotfiles.sh" ]; then
                chmod +x "$DOTFILES_DIR/symlink_dotfiles.sh"
                "$DOTFILES_DIR/symlink_dotfiles.sh"
            else
                error "symlink_dotfiles.sh not found. Skipping bin script symlinking."
            fi
            
            # Zsh
            if [ -f "$DOTFILES_DIR/.zshrc" ]; then
                backup_file "$HOME/.zshrc"
                ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
                info "Symlinked .zshrc"
            fi
            
            # Tmux
            if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
                backup_file "$HOME/.tmux.conf"
                ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
                info "Symlinked .tmux.conf"
            fi
            
            # Alacritty
            if [ -d "$DOTFILES_DIR/alacritty" ]; then
                mkdir -p "$HOME/.config"
                backup_file "$HOME/.config/alacritty"
                ln -sf "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
                info "Symlinked Alacritty configuration"
            fi
            
            # Neovim
            if [ -d "$DOTFILES_DIR/nvim" ]; then
                mkdir -p "$HOME/.config"
                backup_file "$HOME/.config/nvim"
                ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
                info "Symlinked Neovim configuration"
            fi
            ;;
        0)
            section "Exiting without changes"
            exit 0
            ;;
        *)
            error "Invalid choice: $choice"
            ;;
    esac
done

section "Sync complete!"
info "You may need to restart your terminal or run 'source ~/.zshrc' to apply changes."
info "For tmux, run 'tmux source ~/.tmux.conf' to reload the configuration."
#!/bin/bash
# Selective dotfiles sync script for existing machines

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print section header
section() {
    echo -e "\n${GREEN}==>${NC} $1"
}

# Print info message
info() {
    echo -e "${YELLOW}-->${NC} $1"
}

# Print error message
error() {
    echo -e "${RED}Error:${NC} $1"
}

# Create backup of existing file
backup_file() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -a "$file" "$BACKUP_DIR/"
        info "Backed up $file to $BACKUP_DIR/$(basename "$file")"
    fi
}

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR"
    read -p "Would you like to clone the dotfiles repository? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone https://github.com/marvintv/dotfiles.git "$DOTFILES_DIR"
    else
        exit 1
    fi
fi

# Update dotfiles repository
section "Updating dotfiles repository"
cd "$DOTFILES_DIR"
git pull

# Menu for selective sync
section "Selective Sync Menu"
echo "Select which configurations to sync:"
echo "1) Bin scripts (using symlink_dotfiles.sh)"
echo "2) Zsh configuration (.zshrc)"
echo "3) Tmux configuration (.tmux.conf)"
echo "4) Alacritty configuration"
echo "5) Neovim configuration"
echo "6) All of the above"
echo "0) Exit"

read -p "Enter your choice(s) (e.g., 1 2 3 or 6 for all): " -a choices

for choice in "${choices[@]}"; do
    case $choice in
        1)
            section "Symlinking bin scripts"
            if [ -f "$DOTFILES_DIR/symlink_dotfiles.sh" ]; then
                chmod +x "$DOTFILES_DIR/symlink_dotfiles.sh"
                "$DOTFILES_DIR/symlink_dotfiles.sh"
            else
                error "symlink_dotfiles.sh not found. Skipping bin script symlinking."
            fi
            ;;
        2)
            section "Syncing Zsh configuration"
            if [ -f "$DOTFILES_DIR/.zshrc" ]; then
                backup_file "$HOME/.zshrc"
                ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
                info "Symlinked .zshrc"
            else
                error ".zshrc not found in dotfiles directory."
            fi
            ;;
        3)
            section "Syncing Tmux configuration"
            if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
                backup_file "$HOME/.tmux.conf"
                ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
                info "Symlinked .tmux.conf"
            else
                error ".tmux.conf not found in dotfiles directory."
            fi
            ;;
        4)
            section "Syncing Alacritty configuration"
            if [ -d "$DOTFILES_DIR/alacritty" ]; then
                mkdir -p "$HOME/.config"
                backup_file "$HOME/.config/alacritty"
                ln -sf "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
                info "Symlinked Alacritty configuration"
            else
                error "Alacritty configuration not found in dotfiles directory."
            fi
            ;;
        5)
            section "Syncing Neovim configuration"
            if [ -d "$DOTFILES_DIR/nvim" ]; then
                mkdir -p "$HOME/.config"
                backup_file "$HOME/.config/nvim"
                ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
                info "Symlinked Neovim configuration"
            else
                error "Neovim configuration not found in dotfiles directory."
            fi
            ;;
        6)
            section "Syncing all configurations"
            # Bin scripts
            if [ -f "$DOTFILES_DIR/symlink_dotfiles.sh" ]; then
                chmod +x "$DOTFILES_DIR/symlink_dotfiles.sh"
                "$DOTFILES_DIR/symlink_dotfiles.sh"
            else
                error "symlink_dotfiles.sh not found. Skipping bin script symlinking."
            fi
            
            # Zsh
            if [ -f "$DOTFILES_DIR/.zshrc" ]; then
                backup_file "$HOME/.zshrc"
                ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
                info "Symlinked .zshrc"
            fi
            
            # Tmux
            if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
                backup_file "$HOME/.tmux.conf"
                ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
                info "Symlinked .tmux.conf"
            fi
            
            # Alacritty
            if [ -d "$DOTFILES_DIR/alacritty" ]; then
                mkdir -p "$HOME/.config"
                backup_file "$HOME/.config/alacritty"
                ln -sf "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
                info "Symlinked Alacritty configuration"
            fi
            
            # Neovim
            if [ -d "$DOTFILES_DIR/nvim" ]; then
                mkdir -p "$HOME/.config"
                backup_file "$HOME/.config/nvim"
                ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
                info "Symlinked Neovim configuration"
            fi
            ;;
        0)
            section "Exiting without changes"
            exit 0
            ;;
        *)
            error "Invalid choice: $choice"
            ;;
    esac
done

section "Sync complete!"
info "You may need to restart your terminal or run 'source ~/.zshrc' to apply changes."
info "For tmux, run 'tmux source ~/.tmux.conf' to reload the configuration."
