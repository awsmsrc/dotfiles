#!/usr/bin/env bash

# ============================================================================
# Dotfiles Installation Script
# ============================================================================
#
# This script will:
#   1. Detect your platform (macOS, Linux, WSL)
#   2. Check for required dependencies
#   3. Backup existing configuration
#   4. Create symlinks to dotfiles
#   5. Install vim-plug and vim plugins
#   6. Install CoC extensions
#   7. Optionally install shell configs (bashrc, zshrc, starship)
#   8. Provide instructions for optional tools
#
# Usage:
#   ./install.sh           Install dotfiles
#   ./install.sh --uninstall   Remove dotfiles and restore backups
#
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.vim-backup-$(date +%Y%m%d-%H%M%S)"

# ============================================================================
# Helper Functions
# ============================================================================

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# Platform Detection
# ============================================================================

detect_platform() {
    print_step "Detecting platform..."

    OS="$(uname -s)"
    case "$OS" in
        Linux*)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                PLATFORM="WSL"
            else
                PLATFORM="Linux"
            fi
            ;;
        Darwin*)
            PLATFORM="macOS"
            ;;
        MINGW*|CYGWIN*|MSYS*)
            PLATFORM="Windows"
            ;;
        *)
            PLATFORM="Unknown"
            ;;
    esac

    print_success "Platform: $PLATFORM"
}

# ============================================================================
# Prerequisites Check
# ============================================================================

check_prerequisites() {
    print_step "Checking prerequisites..."

    local missing_deps=()

    # Check vim version
    if command_exists vim; then
        VIM_VERSION=$(vim --version | head -n1 | grep -oP '\d+\.\d+' | head -n1)
        VIM_MAJOR=$(echo "$VIM_VERSION" | cut -d. -f1)
        VIM_MINOR=$(echo "$VIM_VERSION" | cut -d. -f2)

        if [ "$VIM_MAJOR" -lt 8 ] || ([ "$VIM_MAJOR" -eq 8 ] && [ "$VIM_MINOR" -lt 1 ]); then
            print_error "Vim 8.1+ is required (found $VIM_VERSION)"
            missing_deps+=("vim 8.1+")
        else
            print_success "Vim $VIM_VERSION"
        fi
    else
        print_error "Vim is not installed"
        missing_deps+=("vim")
    fi

    # Check git
    if command_exists git; then
        print_success "Git $(git --version | grep -oP '\d+\.\d+\.\d+' | head -n1)"
    else
        print_error "Git is not installed"
        missing_deps+=("git")
    fi

    # Check curl
    if command_exists curl; then
        print_success "curl"
    else
        print_error "curl is not installed"
        missing_deps+=("curl")
    fi

    # Check Node.js (required for CoC)
    if command_exists node; then
        NODE_VERSION=$(node --version | grep -oP '\d+' | head -n1)
        if [ "$NODE_VERSION" -ge 16 ]; then
            print_success "Node.js $(node --version)"
        else
            print_warning "Node.js 16+ recommended (found $(node --version))"
        fi
    else
        print_warning "Node.js is not installed (required for CoC.nvim)"
        print_warning "Install Node.js 16+ via your system package manager"
    fi

    # Check Python3 (optional but recommended)
    if command_exists python3; then
        print_success "Python3 $(python3 --version | grep -oP '\d+\.\d+\.\d+')"
    else
        print_warning "Python3 is not installed (recommended for some plugins)"
        print_warning "Install Python3 via your system package manager"
    fi

    # Exit if critical dependencies are missing
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo ""
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        print_step "Install them using your system package manager:"
        case "$PLATFORM" in
            macOS)
                echo "  brew install vim git curl node python3"
                ;;
            Linux|WSL)
                echo "  sudo apt-get install vim git curl nodejs python3"
                echo "  or"
                echo "  sudo yum install vim git curl nodejs python3"
                ;;
        esac
        exit 1
    fi
}

# ============================================================================
# Backup Existing Configuration
# ============================================================================

backup_existing_config() {
    print_step "Backing up existing configuration..."

    local backed_up=false

    # Backup vim configs
    if [ -f "$HOME/.vimrc" ] || [ -L "$HOME/.vimrc" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/.vimrc" "$BACKUP_DIR/"
        print_success "Backed up .vimrc"
        backed_up=true
    fi

    if [ -d "$HOME/.vim" ] || [ -L "$HOME/.vim" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/.vim" "$BACKUP_DIR/"
        print_success "Backed up .vim/"
        backed_up=true
    fi

    # Backup shell configs (only if they're symlinks to dotfiles)
    if [ -L "$HOME/.bashrc" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/.bashrc" "$BACKUP_DIR/"
        print_success "Backed up .bashrc"
        backed_up=true
    fi

    if [ -L "$HOME/.zshrc" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/.zshrc" "$BACKUP_DIR/"
        print_success "Backed up .zshrc"
        backed_up=true
    fi

    if [ -L "$HOME/.config/starship.toml" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/.config/starship.toml" "$BACKUP_DIR/"
        print_success "Backed up starship.toml"
        backed_up=true
    fi

    if [ "$backed_up" = true ]; then
        print_success "Backups saved to: $BACKUP_DIR"
    else
        print_success "No existing configuration found"
    fi
}

# ============================================================================
# Create Symlinks
# ============================================================================

create_symlinks() {
    print_step "Creating symlinks..."

    # Vim configuration
    ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
    print_success "~/.vimrc -> $DOTFILES_DIR/.vimrc"

    mkdir -p "$HOME/.vim"
    ln -sf "$DOTFILES_DIR/vim/config" "$HOME/.vim/config"
    print_success "~/.vim/config -> $DOTFILES_DIR/vim/config"

    ln -sf "$DOTFILES_DIR/coc-settings.json" "$HOME/.vim/coc-settings.json"
    print_success "~/.vim/coc-settings.json -> $DOTFILES_DIR/coc-settings.json"

    # Shell configuration (optional - only if user wants to use dotfiles shell configs)
    echo ""
    print_step "Shell Configuration"
    echo "Would you like to use the dotfiles shell configurations?"
    echo "This will symlink .bashrc, .zshrc, and starship.toml"
    echo ""
    echo "⚠️  WARNING: This will replace your existing shell configs!"
    echo "   Current configs will be backed up if they exist."
    echo ""
    read -p "Install shell configs? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Backup existing shell configs (non-symlink files)
        if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
            mkdir -p "$BACKUP_DIR"
            mv "$HOME/.bashrc" "$BACKUP_DIR/"
            print_success "Backed up existing .bashrc"
        fi

        if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
            mkdir -p "$BACKUP_DIR"
            mv "$HOME/.zshrc" "$BACKUP_DIR/"
            print_success "Backed up existing .zshrc"
        fi

        # Create symlinks for shell configs
        ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
        print_success "~/.bashrc -> $DOTFILES_DIR/.bashrc"

        ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
        print_success "~/.zshrc -> $DOTFILES_DIR/.zshrc"

        # Starship configuration
        mkdir -p "$HOME/.config"
        ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
        print_success "~/.config/starship.toml -> $DOTFILES_DIR/starship.toml"

        echo ""
        print_success "Shell configs installed!"
        print_step "Run 'exec \$SHELL' or restart your terminal to see the new prompt"
    else
        print_warning "Skipping shell configs (you can run this script again later)"
        echo ""
        echo "To use Starship prompt without full shell config:"
        echo "  1. Add this to your ~/.bashrc or ~/.zshrc:"
        echo "     eval \"\$(starship init bash)\"  # for bash"
        echo "     eval \"\$(starship init zsh)\"   # for zsh"
        echo ""
        echo "  2. Copy or symlink starship.toml:"
        echo "     ln -sf $DOTFILES_DIR/starship.toml ~/.config/starship.toml"
    fi
}

# ============================================================================
# Install vim-plug
# ============================================================================

install_vim_plug() {
    print_step "Installing vim-plug..."

    PLUG_FILE="$HOME/.vim/autoload/plug.vim"

    if [ -f "$PLUG_FILE" ]; then
        print_success "vim-plug already installed"
    else
        curl -fLo "$PLUG_FILE" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        print_success "vim-plug installed"
    fi
}

# ============================================================================
# Install Vim Plugins
# ============================================================================

install_vim_plugins() {
    print_step "Installing vim plugins (this may take a few minutes)..."

    # Install plugins in headless mode
    vim +PlugInstall +qall

    print_success "Vim plugins installed"
}

# ============================================================================
# Install CoC Extensions
# ============================================================================

install_coc_extensions() {
    print_step "Installing CoC extensions..."

    if ! command_exists node; then
        print_warning "Node.js not found, skipping CoC extensions"
        print_warning "Install Node.js and run :CocInstall in vim to install extensions"
        return
    fi

    # CoC extensions are auto-installed via g:coc_global_extensions in plugins.vim
    # We just need to trigger CoC to check and install them
    vim -c "CocUpdateSync" -c "qall" 2>/dev/null || true

    print_success "CoC extensions will be installed on first vim launch"
}

# ============================================================================
# Install Language Servers
# ============================================================================

prompt_language_servers() {
    print_step "Language Server Installation"
    echo ""
    echo "For full autocompletion support, install these language servers:"
    echo ""

    # Go
    if command_exists go; then
        echo -e "${BLUE}Go (gopls):${NC}"
        echo "  go install golang.org/x/tools/gopls@latest"
        echo ""
    fi

    # JavaScript/TypeScript
    if command_exists npm; then
        echo -e "${BLUE}JavaScript/TypeScript:${NC}"
        echo "  npm install -g typescript typescript-language-server"
        echo ""
    fi

    # Python
    if command_exists npm; then
        echo -e "${BLUE}Python (pyright):${NC}"
        echo "  npm install -g pyright"
        echo ""
    fi

    # Ruby
    if command_exists gem; then
        echo -e "${BLUE}Ruby (solargraph):${NC}"
        echo "  gem install solargraph"
        echo ""
    fi

    echo "Press Enter to continue..."
    read -r
}

# ============================================================================
# Install Nerd Fonts
# ============================================================================

prompt_nerd_fonts() {
    print_step "Nerd Fonts (for file icons)"
    echo ""
    echo "For file icons in NERDTree, install a Nerd Font:"
    echo ""

    case "$PLATFORM" in
        macOS)
            echo "Using Homebrew:"
            echo "  brew tap homebrew/cask-fonts"
            echo "  brew install --cask font-fira-code-nerd-font"
            echo "  brew install --cask font-hack-nerd-font"
            ;;
        Linux|WSL)
            echo "Download from: https://www.nerdfonts.com/font-downloads"
            echo "Or use your distribution's package manager"
            ;;
    esac

    echo ""
    echo "Then configure your terminal to use the Nerd Font"
    echo ""
    echo "Press Enter to continue..."
    read -r
}

# ============================================================================
# Install Optional Tools
# ============================================================================

prompt_optional_tools() {
    print_step "Optional Tools (recommended)"
    echo ""
    echo "Install these tools for enhanced functionality:"
    echo ""

    # ripgrep
    if ! command_exists rg; then
        echo -e "${BLUE}ripgrep (fast search):${NC}"
        case "$PLATFORM" in
            macOS)
                echo "  brew install ripgrep"
                ;;
            Linux|WSL)
                echo "  sudo apt-get install ripgrep"
                echo "  or"
                echo "  sudo yum install ripgrep"
                ;;
        esac
        echo ""
    fi

    # fd
    if ! command_exists fd; then
        echo -e "${BLUE}fd (fast find):${NC}"
        case "$PLATFORM" in
            macOS)
                echo "  brew install fd"
                ;;
            Linux|WSL)
                echo "  sudo apt-get install fd-find"
                echo "  or"
                echo "  sudo yum install fd-find"
                ;;
        esac
        echo ""
    fi

    # bat
    if ! command_exists bat; then
        echo -e "${BLUE}bat (better cat with syntax highlighting):${NC}"
        case "$PLATFORM" in
            macOS)
                echo "  brew install bat"
                ;;
            Linux|WSL)
                echo "  sudo apt-get install bat"
                echo "  or"
                echo "  sudo yum install bat"
                ;;
        esac
        echo ""
    fi

    echo ""
    echo -e "${BLUE}Kubernetes tools (kubectx, kubens, kpoof):${NC}"
    echo "  Run: ./install-k8s.sh"
    echo ""

    echo "Press Enter to continue..."
    read -r
}

# ============================================================================
# Uninstall
# ============================================================================

uninstall() {
    print_step "Uninstalling dotfiles..."

    # Remove vim symlinks
    if [ -L "$HOME/.vimrc" ]; then
        rm "$HOME/.vimrc"
        print_success "Removed ~/.vimrc symlink"
    fi

    if [ -L "$HOME/.vim/config" ]; then
        rm "$HOME/.vim/config"
        print_success "Removed ~/.vim/config symlink"
    fi

    if [ -L "$HOME/.vim/coc-settings.json" ]; then
        rm "$HOME/.vim/coc-settings.json"
        print_success "Removed ~/.vim/coc-settings.json symlink"
    fi

    # Remove shell config symlinks
    if [ -L "$HOME/.bashrc" ]; then
        rm "$HOME/.bashrc"
        print_success "Removed ~/.bashrc symlink"
    fi

    if [ -L "$HOME/.zshrc" ]; then
        rm "$HOME/.zshrc"
        print_success "Removed ~/.zshrc symlink"
    fi

    if [ -L "$HOME/.config/starship.toml" ]; then
        rm "$HOME/.config/starship.toml"
        print_success "Removed ~/.config/starship.toml symlink"
    fi

    echo ""
    print_success "Dotfiles uninstalled"
    echo ""
    echo "To restore your previous configuration, copy files from the most recent backup:"
    echo "  ls -la ~/.vim-backup-*"
    echo ""
}

# ============================================================================
# Main Installation Flow
# ============================================================================

main() {
    echo ""
    echo "============================================================================"
    echo "  Vim Dotfiles Installation"
    echo "============================================================================"
    echo ""

    detect_platform
    check_prerequisites
    backup_existing_config
    create_symlinks
    install_vim_plug
    install_vim_plugins
    install_coc_extensions

    echo ""
    echo "============================================================================"
    echo "  Installation Complete!"
    echo "============================================================================"
    echo ""

    print_success "Vim is configured and ready to use!"
    echo ""

    # Prompt for optional installations
    prompt_language_servers
    prompt_nerd_fonts
    prompt_optional_tools

    echo ""
    echo "============================================================================"
    echo "  Next Steps"
    echo "============================================================================"
    echo ""
    echo "1. Launch vim to finish installing CoC extensions"
    echo "2. Install language servers for autocompletion (see above)"
    echo "3. Install Nerd Fonts for file icons (see above)"
    echo "4. Check the README for key mappings and usage"
    echo ""
    echo "Key features:"
    echo "  - Use ; instead of : for commands"
    echo "  - <leader>n to toggle NERDTree"
    echo "  - <Ctrl-p> for fuzzy file search"
    echo "  - gd to go to definition"
    echo "  - K to show documentation"
    echo ""
    print_success "Happy vimming!"
    echo ""
}

# ============================================================================
# Script Entry Point
# ============================================================================

if [ "$1" = "--uninstall" ]; then
    uninstall
else
    main
fi
