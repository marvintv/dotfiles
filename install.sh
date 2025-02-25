#!/bin/bash
# Dotfiles installation script

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
DOTFILES_REPO="https://github.com/marvintv/dotfiles.git"
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

# Clone or update repository
section "Setting up dotfiles repository"
if [ -d "$DOTFILES_DIR" ]; then
    info "Dotfiles repository already exists, updating..."
    cd "$DOTFILES_DIR"
    git pull
else
    info "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# Run the symlink_dotfiles.sh script to symlink bin files
section "Symlinking bin scripts"
if [ -f "$DOTFILES_DIR/symlink_dotfiles.sh" ]; then
    chmod +x "$DOTFILES_DIR/symlink_dotfiles.sh"
    "$DOTFILES_DIR/symlink_dotfiles.sh"
else
    error "symlink_dotfiles.sh not found. Skipping bin script symlinking."
fi

# Symlink config files
section "Symlinking configuration files"

# Symlink .zshrc
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    backup_file "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    info "Symlinked .zshrc"
fi

# Symlink .tmux.conf
if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
    backup_file "$HOME/.tmux.conf"
    ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    info "Symlinked .tmux.conf"
fi

# Symlink Alacritty config
if [ -d "$DOTFILES_DIR/alacritty" ]; then
    mkdir -p "$HOME/.config"
    backup_file "$HOME/.config/alacritty"
    ln -sf "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
    info "Symlinked Alacritty configuration"
fi

# Symlink Neovim config
if [ -d "$DOTFILES_DIR/nvim" ]; then
    mkdir -p "$HOME/.config"
    backup_file "$HOME/.config/nvim"
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    info "Symlinked Neovim configuration"
fi

# Create empty secrets file if it doesn't exist
if [ ! -f "$HOME/.secrets.sh" ]; then
    section "Creating empty .secrets.sh file"
    touch "$HOME/.secrets.sh"
    echo "# Add your secret environment variables here" > "$HOME/.secrets.sh"
    echo "# Example: export API_KEY=your_api_key" >> "$HOME/.secrets.sh"
    chmod 600 "$HOME/.secrets.sh"
    info "Created empty .secrets.sh file. Remember to add your secrets to it."
fi

# Install required tools
section "Checking for required tools"

# Check for Homebrew on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
        info "Homebrew is not installed"
        read -p "Would you like to install Homebrew? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
fi

# Check for Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Oh My Zsh is not installed"
    read -p "Would you like to install Oh My Zsh? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        info "Installed Oh My Zsh"
    fi
fi

# Check for Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    info "Powerlevel10k theme is not installed"
    read -p "Would you like to install Powerlevel10k? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        info "Installed Powerlevel10k theme"
    fi
fi

# Check for zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    info "zsh-syntax-highlighting plugin is not installed"
    read -p "Would you like to install zsh-syntax-highlighting? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        info "Installed zsh-syntax-highlighting plugin"
    fi
fi

# Check for tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Tmux Plugin Manager is not installed"
    read -p "Would you like to install Tmux Plugin Manager? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        info "Installed Tmux Plugin Manager"
        info "Remember to press prefix + I inside tmux to install the plugins"
    fi
fi

# Check for common tools
tools=("zsh" "tmux" "nvim" "yazi" "bat" "lazygit")
for tool in "${tools[@]}"; do
    if ! command -v $tool &> /dev/null; then
        info "$tool is not installed"
        read -p "Would you like to install $tool? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command -v brew &> /dev/null; then
                brew install $tool
            elif command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y $tool
            elif command -v pacman &> /dev/null; then
                sudo pacman -S $tool
            else
                error "Could not determine package manager. Please install $tool manually."
            fi
        fi
    fi
done

section "Installation complete!"
info "You may need to restart your terminal or run 'source ~/.zshrc' to apply changes."
info "If you want to make zsh your default shell, run: chsh -s $(which zsh)"
info "Remember to run 'tmux source ~/.tmux.conf' to reload tmux configuration"
#!/bin/bash
# Dotfiles installation script

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
DOTFILES_REPO="https://github.com/marvintv/dotfiles.git"
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

# Clone or update repository
section "Setting up dotfiles repository"
if [ -d "$DOTFILES_DIR" ]; then
    info "Dotfiles repository already exists, updating..."
    cd "$DOTFILES_DIR"
    git pull
else
    info "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# Run the symlink_dotfiles.sh script to symlink bin files
section "Symlinking bin scripts"
if [ -f "$DOTFILES_DIR/symlink_dotfiles.sh" ]; then
    chmod +x "$DOTFILES_DIR/symlink_dotfiles.sh"
    "$DOTFILES_DIR/symlink_dotfiles.sh"
else
    error "symlink_dotfiles.sh not found. Skipping bin script symlinking."
fi

# Symlink config files
section "Symlinking configuration files"

# Symlink .zshrc
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    backup_file "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    info "Symlinked .zshrc"
fi

# Symlink .tmux.conf
if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
    backup_file "$HOME/.tmux.conf"
    ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    info "Symlinked .tmux.conf"
fi

# Symlink Alacritty config
if [ -d "$DOTFILES_DIR/alacritty" ]; then
    mkdir -p "$HOME/.config"
    backup_file "$HOME/.config/alacritty"
    ln -sf "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
    info "Symlinked Alacritty configuration"
fi

# Symlink Neovim config
if [ -d "$DOTFILES_DIR/nvim" ]; then
    mkdir -p "$HOME/.config"
    backup_file "$HOME/.config/nvim"
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    info "Symlinked Neovim configuration"
fi

# Create empty secrets file if it doesn't exist
if [ ! -f "$HOME/.secrets.sh" ]; then
    section "Creating empty .secrets.sh file"
    touch "$HOME/.secrets.sh"
    echo "# Add your secret environment variables here" > "$HOME/.secrets.sh"
    echo "# Example: export API_KEY=your_api_key" >> "$HOME/.secrets.sh"
    chmod 600 "$HOME/.secrets.sh"
    info "Created empty .secrets.sh file. Remember to add your secrets to it."
fi

# Install required tools
section "Checking for required tools"

# Check for Homebrew on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
        info "Homebrew is not installed"
        read -p "Would you like to install Homebrew? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
fi

# Check for Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Oh My Zsh is not installed"
    read -p "Would you like to install Oh My Zsh? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        info "Installed Oh My Zsh"
    fi
fi

# Check for Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    info "Powerlevel10k theme is not installed"
    read -p "Would you like to install Powerlevel10k? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        info "Installed Powerlevel10k theme"
    fi
fi

# Check for zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    info "zsh-syntax-highlighting plugin is not installed"
    read -p "Would you like to install zsh-syntax-highlighting? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        info "Installed zsh-syntax-highlighting plugin"
    fi
fi

# Check for tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Tmux Plugin Manager is not installed"
    read -p "Would you like to install Tmux Plugin Manager? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        info "Installed Tmux Plugin Manager"
        info "Remember to press prefix + I inside tmux to install the plugins"
    fi
fi

# Check for common tools
tools=("zsh" "tmux" "nvim" "yazi" "bat" "lazygit")
for tool in "${tools[@]}"; do
    if ! command -v $tool &> /dev/null; then
        info "$tool is not installed"
        read -p "Would you like to install $tool? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command -v brew &> /dev/null; then
                brew install $tool
            elif command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y $tool
            elif command -v pacman &> /dev/null; then
                sudo pacman -S $tool
            else
                error "Could not determine package manager. Please install $tool manually."
            fi
        fi
    fi
done

section "Installation complete!"
info "You may need to restart your terminal or run 'source ~/.zshrc' to apply changes."
info "If you want to make zsh your default shell, run: chsh -s $(which zsh)"
info "Remember to run 'tmux source ~/.tmux.conf' to reload tmux configuration"
