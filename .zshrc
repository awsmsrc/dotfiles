# ============================================================================
# Zsh Configuration with Oh My Zsh + Starship
# ============================================================================

# ============================================================================
# Environment Variables
# ============================================================================

# Plaid-specific paths
export PLAID_PATH="$HOME/plaid"
export GO111MODULE=on
export GOPROXY=https://proxy.golang.org
export GOPRIVATE=github.plaid.com
export PATH="$PLAID_PATH/go.git:$PLAID_PATH/go.git/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# AWS Configuration
export AWS_PAGER=""
export AWS_SDK_LOAD_CONFIG=1
export AWS_REGION=us-east-1
export AWS_DEFAULT_PROFILE=plaidroot-infra

# asdf (version manager)
export PATH="$HOME/.asdf/shims:$PATH"

# ============================================================================
# Oh My Zsh Configuration
# ============================================================================

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme (Starship will override this)
ZSH_THEME="robbyrussell"

# Update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# History timestamp format
# HIST_STAMPS="mm/dd/yyyy"

# Plugins
plugins=(
    git
    branch
    colored-man-pages
    gitfast
    golang
    history-substring-search
    z
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# Aliases
# ============================================================================

# Kubernetes shortcuts
alias k="kubectl"
alias kc="kubectx"
alias kns="kubens"
# kpoof - install via: brew tap farmotive/k8s && brew install kpoof

# AWS profile switcher
alias awsprofile='export AWS_PROFILE=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | grep -v "\-sso" | fzf)'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Better ls (if eza is installed, use it)
if command -v eza &> /dev/null; then
    alias ls='eza'
    alias ll='eza -la'
    alias la='eza -a'
    alias tree='eza --tree'
else
    alias ll='ls -alF'
    alias la='ls -A'
fi

# ============================================================================
# Starship Prompt (Modern, cross-shell prompt)
# ============================================================================
#
# Starship provides a beautiful prompt with:
#   - Git branch and status
#   - Number of file changes
#   - Language versions (Go, Node, Python, Ruby)
#   - Directory with smart truncation
#   - Command execution time
#   - And much more!
#
# Configuration: ~/.config/starship.toml
# Documentation: https://starship.rs

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ============================================================================
# Local Overrides
# ============================================================================

# Source local zshrc if it exists (for machine-specific settings)
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
