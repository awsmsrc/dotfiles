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
#   5. Configure git to use vim as default merge tool
#   6. Install vim-plug and vim plugins
#   7. Install CoC extensions
#   8. Install ripgrep (required for :Rg search in vim)
#   9. Optionally install shell configs (bashrc, zshrc, starship)
#  10. Provide instructions for optional tools
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
# Configure Git Merge Tool
# ============================================================================

configure_git_merge_tool() {
    print_step "Configuring git merge tool..."

    # Set vimdiff as the default merge tool
    git config --global merge.tool vimdiff

    # Don't prompt before launching merge tool
    git config --global mergetool.prompt false

    # Don't keep backup files (.orig) after successful merge
    git config --global mergetool.keepBackup false

    # Configure vimdiff merge tool command
    git config --global mergetool.vimdiff.cmd 'vim -d $LOCAL $REMOTE $MERGED -c '\''$wincmd w'\'' -c '\''wincmd J'\'''

    print_success "Git configured to use vim as merge tool"
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
    print_step "Additional Language Servers (Optional)"
    echo ""
    echo "For additional language support, you can install these language servers:"
    echo ""

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

    echo "Note: gopls (Go) has already been installed automatically."
    echo ""
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
# Install Ripgrep (required for :Rg search in vim)
# ============================================================================

install_ripgrep() {
    print_step "Installing ripgrep..."

    if command_exists rg; then
        print_success "ripgrep already installed ($(rg --version | head -n1))"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install ripgrep
                print_success "ripgrep installed via Homebrew"
            else
                print_warning "Homebrew not found. Install ripgrep manually:"
                echo "  brew install ripgrep"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y ripgrep
                print_success "ripgrep installed via apt"
            elif command_exists yum; then
                sudo yum install -y ripgrep
                print_success "ripgrep installed via yum"
            else
                print_warning "Package manager not found. Install ripgrep manually:"
                echo "  sudo apt-get install ripgrep"
                echo "  or"
                echo "  sudo yum install ripgrep"
            fi
            ;;
        *)
            print_warning "Unknown platform. Install ripgrep manually for :Rg search support"
            ;;
    esac
}

# ============================================================================
# Install tree (directory listing utility)
# ============================================================================

install_tree() {
    print_step "Installing tree..."

    if command_exists tree; then
        print_success "tree already installed ($(tree --version | head -n1))"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install tree
                print_success "tree installed via Homebrew"
            else
                print_warning "Homebrew not found. Install tree manually:"
                echo "  brew install tree"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y tree
                print_success "tree installed via apt"
            elif command_exists yum; then
                sudo yum install -y tree
                print_success "tree installed via yum"
            else
                print_warning "Package manager not found. Install tree manually:"
                echo "  sudo apt-get install tree"
                echo "  or"
                echo "  sudo yum install tree"
            fi
            ;;
        *)
            print_warning "Unknown platform. Install tree manually for directory listing support"
            ;;
    esac
}

# ============================================================================
# Install Zsh
# ============================================================================

install_zsh() {
    print_step "Installing Zsh..."

    if command_exists zsh; then
        print_success "Zsh already installed ($(zsh --version))"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install zsh
                print_success "Zsh installed via Homebrew"
            else
                print_warning "Homebrew not found. Install Zsh manually:"
                echo "  brew install zsh"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y zsh
                print_success "Zsh installed via apt"
            elif command_exists yum; then
                sudo yum install -y zsh
                print_success "Zsh installed via yum"
            else
                print_warning "Package manager not found. Install Zsh manually"
            fi
            ;;
        *)
            print_warning "Unknown platform. Install Zsh manually"
            ;;
    esac
}

# ============================================================================
# Install Oh My Zsh
# ============================================================================

install_oh_my_zsh() {
    print_step "Installing Oh My Zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_success "Oh My Zsh already installed"
        return
    fi

    # Install Oh My Zsh (non-interactive mode)
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    print_success "Oh My Zsh installed"
}

# ============================================================================
# Set Zsh as default shell
# ============================================================================

set_zsh_as_default() {
    if ! command_exists zsh; then
        print_warning "Zsh not installed, skipping default shell setup"
        return
    fi

    # Check if zsh is already the default shell
    if [ "$SHELL" = "$(which zsh)" ]; then
        print_success "Zsh is already the default shell"
        return
    fi

    print_step "Setting Zsh as default shell..."

    # Get the path to zsh
    ZSH_PATH=$(which zsh)

    # Check if zsh is in /etc/shells
    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        print_step "Adding $ZSH_PATH to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi

    # Change default shell
    if chsh -s "$ZSH_PATH"; then
        print_success "Default shell changed to Zsh"
        print_warning "You'll need to log out and back in (or restart your terminal) for the change to take effect"
    else
        print_error "Failed to change default shell"
        echo "You can manually change it later with: chsh -s $(which zsh)"
    fi
}

# ============================================================================
# Install Node.js (required for CoC.nvim)
# ============================================================================

install_nodejs() {
    print_step "Installing Node.js..."

    if command_exists node; then
        NODE_VERSION=$(node --version | grep -oP '\d+' | head -n1)
        if [ "$NODE_VERSION" -ge 16 ]; then
            print_success "Node.js already installed ($(node --version))"
            return
        else
            print_warning "Node.js version is too old ($(node --version)), upgrading..."
        fi
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install node
                print_success "Node.js installed via Homebrew"
            else
                print_warning "Homebrew not found. Install Node.js manually:"
                echo "  brew install node"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                # Install Node.js 20.x LTS
                curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
                sudo apt-get install -y nodejs
                print_success "Node.js installed via NodeSource"
            elif command_exists yum; then
                # Install Node.js 20.x LTS
                curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
                sudo yum install -y nodejs
                print_success "Node.js installed via NodeSource"
            else
                print_warning "Package manager not found. Install Node.js manually"
            fi
            ;;
        *)
            print_warning "Unknown platform. Install Node.js manually"
            ;;
    esac
}

# ============================================================================
# Install Python3 (recommended for plugins)
# ============================================================================

install_python() {
    print_step "Installing Python3..."

    if command_exists python3; then
        print_success "Python3 already installed ($(python3 --version))"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install python3
                print_success "Python3 installed via Homebrew"
            else
                print_warning "Homebrew not found. Install Python3 manually:"
                echo "  brew install python3"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y python3 python3-pip
                print_success "Python3 installed via apt"
            elif command_exists yum; then
                sudo yum install -y python3 python3-pip
                print_success "Python3 installed via yum"
            else
                print_warning "Package manager not found. Install Python3 manually"
            fi
            ;;
        *)
            print_warning "Unknown platform. Install Python3 manually"
            ;;
    esac
}

# ============================================================================
# Install Go (for vim-go)
# ============================================================================

install_go() {
    print_step "Installing Go..."

    if command_exists go; then
        print_success "Go already installed ($(go version | grep -oP 'go\d+\.\d+\.\d+'))"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install go
                print_success "Go installed via Homebrew"
            else
                print_warning "Homebrew not found. Install Go manually:"
                echo "  brew install go"
            fi
            ;;
        Linux|WSL)
            # Install latest Go version
            GO_VERSION="1.21.5"
            GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"

            print_step "Downloading Go ${GO_VERSION}..."
            cd /tmp
            curl -LO "https://go.dev/dl/${GO_TARBALL}"

            print_step "Installing Go to /usr/local/go..."
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf "$GO_TARBALL"
            rm "$GO_TARBALL"

            # Add Go to PATH if not already there
            if ! grep -q "/usr/local/go/bin" "$HOME/.bashrc" 2>/dev/null; then
                echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.bashrc"
            fi
            if ! grep -q "/usr/local/go/bin" "$HOME/.zshrc" 2>/dev/null; then
                echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.zshrc"
            fi

            export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

            print_success "Go installed to /usr/local/go"
            print_warning "Run 'source ~/.bashrc' or restart your terminal to update PATH"
            ;;
        *)
            print_warning "Unknown platform. Install Go manually from https://go.dev/dl/"
            ;;
    esac
}

# ============================================================================
# Install Starship prompt
# ============================================================================

install_starship() {
    print_step "Installing Starship prompt..."

    if command_exists starship; then
        print_success "Starship already installed ($(starship --version | head -n1))"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install starship
                print_success "Starship installed via Homebrew"
            else
                print_warning "Homebrew not found. Install Starship manually:"
                echo "  brew install starship"
            fi
            ;;
        Linux|WSL)
            curl -sS https://starship.rs/install.sh | sh -s -- -y
            print_success "Starship installed"
            ;;
        *)
            print_warning "Unknown platform. Install Starship manually from https://starship.rs"
            ;;
    esac
}

# ============================================================================
# Install fzf (required for vim fuzzy finding)
# ============================================================================

install_fzf() {
    print_step "Installing fzf..."

    if command_exists fzf; then
        print_success "fzf already installed ($(fzf --version))"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install fzf
                print_success "fzf installed via Homebrew"
            else
                print_warning "Homebrew not found. Install fzf manually:"
                echo "  brew install fzf"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y fzf
                print_success "fzf installed via apt"
            elif command_exists yum; then
                sudo yum install -y fzf
                print_success "fzf installed via yum"
            else
                # Fallback to git installation
                if [ ! -d "$HOME/.fzf" ]; then
                    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
                    "$HOME/.fzf/install" --all
                    print_success "fzf installed via git"
                else
                    print_success "fzf already installed via git"
                fi
            fi
            ;;
        *)
            print_warning "Unknown platform. Install fzf manually"
            ;;
    esac
}

# ============================================================================
# Install fd (fast find alternative)
# ============================================================================

install_fd() {
    print_step "Installing fd..."

    if command_exists fd || command_exists fdfind; then
        print_success "fd already installed"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install fd
                print_success "fd installed via Homebrew"
            else
                print_warning "Homebrew not found. Install fd manually:"
                echo "  brew install fd"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y fd-find
                # Create symlink if it doesn't exist
                if [ ! -f "$HOME/.local/bin/fd" ]; then
                    mkdir -p "$HOME/.local/bin"
                    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
                fi
                print_success "fd installed via apt"
            elif command_exists yum; then
                sudo yum install -y fd-find
                print_success "fd installed via yum"
            else
                print_warning "Package manager not found. Install fd manually"
            fi
            ;;
        *)
            print_warning "Unknown platform. Install fd manually"
            ;;
    esac
}

# ============================================================================
# Install bat (better cat with syntax highlighting)
# ============================================================================

install_bat() {
    print_step "Installing bat..."

    if command_exists bat || command_exists batcat; then
        print_success "bat already installed"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install bat
                print_success "bat installed via Homebrew"
            else
                print_warning "Homebrew not found. Install bat manually:"
                echo "  brew install bat"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y bat
                # Create symlink if it doesn't exist (Ubuntu calls it batcat)
                if [ ! -f "$HOME/.local/bin/bat" ] && command_exists batcat; then
                    mkdir -p "$HOME/.local/bin"
                    ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
                fi
                print_success "bat installed via apt"
            elif command_exists yum; then
                sudo yum install -y bat
                print_success "bat installed via yum"
            else
                print_warning "Package manager not found. Install bat manually"
            fi
            ;;
        *)
            print_warning "Unknown platform. Install bat manually"
            ;;
    esac
}

# ============================================================================
# Install Go language server (gopls)
# ============================================================================

install_gopls() {
    if ! command_exists go; then
        print_warning "Go not installed, skipping gopls"
        return
    fi

    print_step "Installing gopls (Go language server)..."

    if command_exists gopls; then
        print_success "gopls already installed"
        return
    fi

    go install golang.org/x/tools/gopls@latest
    print_success "gopls installed"
}

# ============================================================================
# Install GitHub CLI (gh)
# ============================================================================

install_gh() {
    print_step "Installing GitHub CLI (gh)..."

    if command_exists gh; then
        print_success "GitHub CLI already installed ($(gh --version | head -n1))"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install gh
                print_success "GitHub CLI installed via Homebrew"
            else
                print_warning "Homebrew not found. Install GitHub CLI manually:"
                echo "  brew install gh"
            fi
            ;;
        Linux|WSL)
            if command_exists apt-get; then
                # Install from official GitHub CLI repository
                print_step "Adding GitHub CLI repository..."
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

                print_step "Installing GitHub CLI..."
                sudo apt-get update
                sudo apt-get install -y gh
                print_success "GitHub CLI installed via official repository"
            elif command_exists yum; then
                sudo yum install -y 'dnf-command(config-manager)'
                sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
                sudo yum install -y gh
                print_success "GitHub CLI installed via yum"
            else
                print_warning "Package manager not found. Install GitHub CLI manually"
            fi
            ;;
        *)
            print_warning "Unknown platform. Install GitHub CLI manually from https://cli.github.com"
            ;;
    esac
}

# ============================================================================
# Install Optional Tools
# ============================================================================

# Removed prompt_optional_tools - fd and bat are now installed automatically

# ============================================================================
# Ensure ~/.local/bin is in PATH
# ============================================================================

ensure_local_bin_in_path() {
    # Check if ~/.local/bin exists
    if [ ! -d "$HOME/.local/bin" ]; then
        return
    fi

    # Check if ~/.local/bin is already in PATH
    if echo "$PATH" | grep -q "$HOME/.local/bin"; then
        return
    fi

    # Add to bashrc if not present
    if [ -f "$HOME/.bashrc" ] && ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        print_success "Added ~/.local/bin to PATH in .bashrc"
    fi

    # Add to zshrc if not present
    if [ -f "$HOME/.zshrc" ] && ! grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        print_success "Added ~/.local/bin to PATH in .zshrc"
    fi

    # Update current session
    export PATH="$HOME/.local/bin:$PATH"
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

    echo ""
    echo "============================================================================"
    echo "  Setting up Zsh"
    echo "============================================================================"
    echo ""

    # Install and set Zsh as default shell
    install_zsh
    install_oh_my_zsh
    set_zsh_as_default

    echo ""
    echo "============================================================================"
    echo "  Installing Core Dependencies"
    echo "============================================================================"
    echo ""

    # Install core dependencies first
    install_nodejs
    install_python
    install_go
    install_starship
    install_fzf
    install_ripgrep
    install_tree
    install_fd
    install_bat
    install_gh

    # Ensure ~/.local/bin is in PATH (for fd and bat symlinks on Ubuntu)
    ensure_local_bin_in_path

    echo ""
    echo "============================================================================"
    echo "  Installing Language Servers"
    echo "============================================================================"
    echo ""

    # Install language servers
    install_gopls

    echo ""
    echo "============================================================================"
    echo "  Configuring Dotfiles"
    echo "============================================================================"
    echo ""

    backup_existing_config
    create_symlinks
    configure_git_merge_tool
    install_vim_plug
    install_vim_plugins
    install_coc_extensions

    echo ""
    echo "============================================================================"
    echo "  Installation Complete!"
    echo "============================================================================"
    echo ""

    print_success "All dependencies and vim configuration installed!"
    echo ""

    # Prompt for additional language servers
    prompt_language_servers
    prompt_nerd_fonts

    echo ""
    echo "============================================================================"
    echo "  Next Steps"
    echo "============================================================================"
    echo ""
    echo "1. RESTART YOUR TERMINAL or log out and back in (to activate Zsh and PATH changes)"
    echo "2. Launch vim to finish installing CoC extensions"
    echo "3. Install additional language servers if needed (see above)"
    echo "4. Install Nerd Fonts for file icons (see above)"
    echo "5. Check the README for key mappings and usage"
    echo ""
    echo "Shell Configuration:"
    echo "  - Zsh is now your default shell with Starship prompt"
    echo "  - Configuration: ~/.zshrc"
    echo "  - Prompt config: ~/.config/starship.toml"
    echo ""
    echo "Vim Key Features:"
    echo "  - Use ; instead of : for commands"
    echo "  - Leader key is , (comma)"
    echo "  - ,n to toggle NERDTree"
    echo "  - ,f for project-wide text search (ripgrep)"
    echo "  - <Ctrl-p> for fuzzy file search"
    echo "  - gd to go to definition"
    echo "  - K to show documentation"
    echo ""
    print_success "Happy vimming with Zsh!"
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
