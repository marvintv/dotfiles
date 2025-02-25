#!/bin/bash
# Unified dotfiles setup script

set -e  # Exit on error

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Logging functions
log() { echo -e "${GREEN}==>${NC} $1"; }
info() { echo -e "${YELLOW}-->${NC} $1"; }
error() { echo -e "${RED}Error:${NC} $1"; }

# Backup function
backup_file() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -a "$file" "$BACKUP_DIR/"
        info "Backed up $file"
    fi
}

# Symlink function
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ ! -e "$source" ]; then
        error "Source $source does not exist"
        return 1
    fi

    if [ -L "$target" ]; then
        info "$target already linked"
    elif [ -e "$target" ]; then
        backup_file "$target"
        rm -f "$target"
        ln -s "$source" "$target"
        info "Created symlink: $target"
    else
        ln -s "$source" "$target"
        info "Created symlink: $target"
    fi
}

# Check for required commands
check_requirements() {
    local requirements=(git zsh tmux)
    local missing=()

    for cmd in "${requirements[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -ne 0 ]; then
        error "Missing required commands: ${missing[*]}"
        error "Please install them first"
        exit 1
    fi
}

# Clone/update repository
setup_repo() {
    if [ -d "$DOTFILES_DIR" ]; then
        log "Updating existing dotfiles repository"
        cd "$DOTFILES_DIR"
        git pull
    else
        log "Cloning dotfiles repository"
        git clone https://github.com/marvintv/dotfiles.git "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
    fi
}

# Setup dotfiles
setup_dotfiles() {
    log "Setting up dotfiles"

    # Create config directory
    mkdir -p "$HOME/.config"

    # Core config files
    create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

    # Optional configs
    [ -d "$DOTFILES_DIR/alacritty" ] && \
        create_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
    [ -d "$DOTFILES_DIR/nvim" ] && \
        create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Bin directory
    if [ -d "$DOTFILES_DIR/bin" ]; then
        mkdir -p "$HOME/bin"
        for file in "$DOTFILES_DIR/bin"/*; do
            [ -f "$file" ] && create_symlink "$file" "$HOME/bin/$(basename "$file")"
        done
    fi
}

# Setup plugins
setup_plugins() {
    log "Setting up plugins"

    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Powerlevel10k theme
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        info "Installing Powerlevel10k theme"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi

    # Tmux Plugin Manager
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        info "Installing Tmux Plugin Manager"
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        info "Remember to press prefix + I inside tmux to install plugins"
    fi
}

# Create empty secrets file
setup_secrets() {
    if [ ! -f "$HOME/.secrets.sh" ]; then
        log "Creating empty .secrets.sh"
        echo "# Add your secret environment variables here" > "$HOME/.secrets.sh"
        echo "# Example: export API_KEY=your_api_key" >> "$HOME/.secrets.sh"
        chmod 600 "$HOME/.secrets.sh"
    fi
}

# Main
main() {
    log "Starting dotfiles setup"
    
    check_requirements
    setup_repo
    setup_dotfiles
    setup_plugins
    setup_secrets

    log "Setup complete!"
    info "You may need to:"
    info "1. Restart your terminal or run: source ~/.zshrc"
    info "2. Run: tmux source ~/.tmux.conf"
    info "3. Set zsh as default shell: chsh -s $(which zsh)"
}

main "$@"
