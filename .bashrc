# ============================================================================
# Bash Configuration
# ============================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================================================
# History Configuration
# ============================================================================

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# History size
HISTSIZE=10000
HISTFILESIZE=20000

# ============================================================================
# Shell Options
# ============================================================================

# Check window size after each command
shopt -s checkwinsize

# Enable recursive globbing with **
shopt -s globstar 2>/dev/null

# Correct minor errors in cd command directory names
shopt -s cdspell

# ============================================================================
# PATH Configuration
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

# AWS Configuration
export AWS_PAGER=""
export AWS_SDK_LOAD_CONFIG=1
export AWS_REGION=us-east-1
export AWS_DEFAULT_PROFILE=plaidroot-infra

# asdf (version manager)
export PATH="$HOME/.asdf/shims:$PATH"

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

# Safer file operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Better ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'

# ============================================================================
# Colors for ls and grep
# ============================================================================

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# macOS color ls
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# ============================================================================
# Completion
# ============================================================================

# Enable programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ============================================================================
# Starship Prompt (Modern, cross-shell prompt)
# ============================================================================

if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
else
    # Fallback to simple prompt if Starship is not installed
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# ============================================================================
# Local Overrides
# ============================================================================

# Source local bashrc if it exists (for machine-specific settings)
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
