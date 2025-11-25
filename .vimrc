" ============================================================================
" Modern Vim Configuration
" ============================================================================
"
" A clean, modular vim configuration with IDE-like features
"
" Features:
"   - NERDTree for file browsing
"   - fzf for fuzzy file search
"   - CoC for LSP-based autocompletion
"   - Language support for Go, JavaScript, Python, Ruby
"   - Mouse support in all terminals
"   - Custom keybindings (; remapped to :)
"
" Installation:
"   Run install.sh or manually symlink this file to ~/.vimrc
"
" ============================================================================

" Load configuration modules
" These files are located in ~/.vim/config/
" The order matters - plugins should be loaded first

" Plugin declarations and vim-plug setup
source ~/.vim/config/plugins.vim

" General editor settings (line numbers, tabs, mouse, clipboard, etc.)
source ~/.vim/config/settings.vim

" Custom keybindings and shortcuts
source ~/.vim/config/keybindings.vim

" Autocommands and file-type specific settings
source ~/.vim/config/autocmds.vim

" ============================================================================
" Local Overrides (optional)
" ============================================================================
"
" You can create a ~/.vimrc.local file for machine-specific settings
" that won't be tracked in your dotfiles repository
"
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
