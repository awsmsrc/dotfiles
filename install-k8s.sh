#!/usr/bin/env bash

# ============================================================================
# Kubernetes Tools Installation Script
# ============================================================================
#
# This script installs useful Kubernetes tools:
#   - kubectx: Switch between kubectl contexts (clusters)
#   - kubens: Switch between Kubernetes namespaces
#   - kpoof: Interactive port-forward utility
#
# Usage:
#   ./install-k8s.sh
#
# Prerequisites:
#   - kubectl must be installed and configured
#
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
        *)
            PLATFORM="Unknown"
            ;;
    esac
}

# ============================================================================
# Check Prerequisites
# ============================================================================

check_kubectl() {
    print_step "Checking prerequisites..."

    if ! command_exists kubectl; then
        print_error "kubectl is not installed"
        echo ""
        echo "Install kubectl first:"
        case "$PLATFORM" in
            macOS)
                echo "  brew install kubectl"
                ;;
            Linux|WSL)
                echo "  Follow instructions at: https://kubernetes.io/docs/tasks/tools/"
                ;;
        esac
        echo ""
        exit 1
    fi

    print_success "kubectl $(kubectl version --client --short 2>/dev/null | head -n1 || echo 'installed')"
}

# ============================================================================
# Install kubectx and kubens
# ============================================================================

install_kubectx_kubens() {
    print_step "Installing kubectx and kubens..."

    if command_exists kubectx && command_exists kubens; then
        print_success "kubectx and kubens already installed"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew install kubectx
                print_success "Installed kubectx and kubens via Homebrew"
            else
                print_error "Homebrew not found. Install from: https://github.com/ahmetb/kubectx"
                return 1
            fi
            ;;
        Linux|WSL)
            print_step "Installing kubectx and kubens to ~/.local/bin..."

            # Create bin directory
            mkdir -p ~/.local/bin

            # Download kubectx
            if ! command_exists kubectx; then
                curl -sSL https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -o ~/.local/bin/kubectx
                chmod +x ~/.local/bin/kubectx
                print_success "Installed kubectx"
            fi

            # Download kubens
            if ! command_exists kubens; then
                curl -sSL https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -o ~/.local/bin/kubens
                chmod +x ~/.local/bin/kubens
                print_success "Installed kubens"
            fi

            # Add to PATH if not already there
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                print_warning "Add ~/.local/bin to your PATH:"
                echo '  export PATH="$HOME/.local/bin:$PATH"'
            fi
            ;;
    esac
}

# ============================================================================
# Install kpoof
# ============================================================================

install_kpoof() {
    print_step "Installing kpoof..."

    if command_exists kpoof; then
        print_success "kpoof already installed"
        return
    fi

    case "$PLATFORM" in
        macOS)
            if command_exists brew; then
                brew tap farmotive/k8s
                brew install kpoof
                print_success "Installed kpoof via Homebrew"
            else
                print_error "Homebrew not found"
                return 1
            fi
            ;;
        Linux|WSL)
            print_step "Installing kpoof to ~/.local/bin..."

            mkdir -p ~/.local/bin

            # Download kpoof script
            curl -sSL https://raw.githubusercontent.com/farmotive/kpoof/master/kpoof -o ~/.local/bin/kpoof
            chmod +x ~/.local/bin/kpoof

            print_success "Installed kpoof"

            # Add to PATH if not already there
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                print_warning "Add ~/.local/bin to your PATH:"
                echo '  export PATH="$HOME/.local/bin:$PATH"'
            fi
            ;;
    esac
}

# ============================================================================
# Verify Installation
# ============================================================================

verify_installation() {
    print_step "Verifying installation..."
    echo ""

    local all_installed=true

    if command_exists kubectx; then
        print_success "kubectx installed"
    else
        print_error "kubectx not found"
        all_installed=false
    fi

    if command_exists kubens; then
        print_success "kubens installed"
    else
        print_error "kubens not found"
        all_installed=false
    fi

    if command_exists kpoof; then
        print_success "kpoof installed"
    else
        print_error "kpoof not found"
        all_installed=false
    fi

    echo ""

    if [ "$all_installed" = true ]; then
        print_success "All Kubernetes tools installed successfully!"
    else
        print_warning "Some tools failed to install. See errors above."
        return 1
    fi
}

# ============================================================================
# Show Usage Examples
# ============================================================================

show_usage() {
    echo ""
    echo "============================================================================"
    echo "  Kubernetes Tools Installed"
    echo "============================================================================"
    echo ""
    echo "Quick reference (aliases are configured in your shell):"
    echo ""
    echo "  k           - kubectl"
    echo "  kc          - kubectx (switch clusters)"
    echo "  kns         - kubens (switch namespaces)"
    echo "  kpoof       - Interactive port-forward"
    echo ""
    echo "Examples:"
    echo ""
    echo "  # Switch cluster context"
    echo "  kc production"
    echo ""
    echo "  # Switch namespace"
    echo "  kns default"
    echo ""
    echo "  # Interactive port-forward"
    echo "  kpoof"
    echo "  # or in daemon mode:"
    echo "  kpoof --daemon"
    echo ""
}

# ============================================================================
# Main
# ============================================================================

main() {
    echo ""
    echo "============================================================================"
    echo "  Kubernetes Tools Installation"
    echo "============================================================================"
    echo ""

    detect_platform
    print_success "Platform: $PLATFORM"
    echo ""

    check_kubectl
    install_kubectx_kubens
    install_kpoof
    verify_installation
    show_usage
}

# Run main
main
