" ============================================================================
" Vim Plugins (using vim-plug)
" ============================================================================

" Auto-install vim-plug if not present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ============================================================================
" Plugin List
" ============================================================================

call plug#begin('~/.vim/plugged')

" ----------------------------------------------------------------------------
" File Navigation
" ----------------------------------------------------------------------------

" File tree explorer
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ----------------------------------------------------------------------------
" Window/Split Management
" ----------------------------------------------------------------------------

" Seamless navigation between vim splits and tmux panes
Plug 'christoomey/vim-tmux-navigator'

" Toggle maximize/restore current split
Plug 'szw/vim-maximizer'

" Interactive window resizing
Plug 'simeji/winresizer'

" ----------------------------------------------------------------------------
" Autocompletion & LSP
" ----------------------------------------------------------------------------

" CoC for LSP-based autocompletion (requires Node.js)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ----------------------------------------------------------------------------
" Language Support
" ----------------------------------------------------------------------------

" Go development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Syntax highlighting for multiple languages
Plug 'sheerun/vim-polyglot'

" ----------------------------------------------------------------------------
" Git Integration
" ----------------------------------------------------------------------------

" Git commands in vim
Plug 'tpope/vim-fugitive'

" Show git diff in sign column
Plug 'airblade/vim-gitgutter'

" ----------------------------------------------------------------------------
" UI Enhancements
" ----------------------------------------------------------------------------

" Status/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File icons (requires Nerd Font)
Plug 'ryanoasis/vim-devicons'

" Color schemes
" Classic themes
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'

" Modern themes (2024-2025)
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'folke/tokyonight.nvim'
Plug 'rebelot/kanagawa.nvim'

" ----------------------------------------------------------------------------
" Editing Enhancements
" ----------------------------------------------------------------------------

" Auto-close brackets, quotes, etc.
Plug 'jiangmiao/auto-pairs'

" Easy commenting (gcc to toggle line comment)
Plug 'tpope/vim-commentary'

" Surround text with brackets, quotes, etc. (ys, cs, ds)
Plug 'tpope/vim-surround'

" Repeat plugin commands with .
Plug 'tpope/vim-repeat'

" Better matching with %
Plug 'andymass/vim-matchup'

" Indent guides
Plug 'Yggdroot/indentLine'

" ----------------------------------------------------------------------------
" Search & Replace
" ----------------------------------------------------------------------------

" Enhanced search (shows number of matches)
Plug 'google/vim-searchindex'

call plug#end()

" ============================================================================
" Plugin Configuration
" ============================================================================

" ----------------------------------------------------------------------------
" NERDTree Settings
" ----------------------------------------------------------------------------

" Show hidden files
let NERDTreeShowHidden=1

" Close vim if NERDTree is the only window left
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Ignore files
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$', '\.DS_Store']

" Better symbols for git plugin
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  : '✹',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '✭',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : '═',
    \ 'Deleted'   : '✖',
    \ 'Dirty'     : '✗',
    \ 'Clean'     : '✔︎',
    \ 'Unknown'   : '?'
    \ }

" ----------------------------------------------------------------------------
" FZF Settings
" ----------------------------------------------------------------------------

" Preview window position
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Custom FZF layout
let g:fzf_layout = { 'down': '40%' }

" FZF colors to match vim color scheme
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment']
  \ }

" Use ripgrep if available
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
endif

" ----------------------------------------------------------------------------
" vim-go Settings
" ----------------------------------------------------------------------------

" Syntax highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_function_calls = 1

" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Show type info in status line
let g:go_auto_type_info = 1

" Use gopls for language server
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Disable vim-go's LSP features (CoC handles this)
let g:go_code_completion_enabled = 0
let g:go_def_mapping_enabled = 0

" ----------------------------------------------------------------------------
" Airline Settings
" ----------------------------------------------------------------------------

" Enable powerline fonts (requires Nerd Font)
let g:airline_powerline_fonts = 1

" Show buffer list in tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Theme (will auto-match colorscheme if available)
let g:airline_theme='catppuccin'

" Show CoC status
let g:airline#extensions#coc#enabled = 1

" ----------------------------------------------------------------------------
" GitGutter Settings
" ----------------------------------------------------------------------------

" Update faster
let g:gitgutter_update_delay = 100

" Max signs
let g:gitgutter_max_signs = 500

" Use custom symbols
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '~-'

" ----------------------------------------------------------------------------
" IndentLine Settings
" ----------------------------------------------------------------------------

" Disable by default (can slow down vim on large files)
let g:indentLine_enabled = 0
let g:indentLine_char = '┊'

" Toggle with <leader>i
nnoremap <leader>i :IndentLinesToggle<CR>

" ----------------------------------------------------------------------------
" vim-tmux-navigator Settings
" ----------------------------------------------------------------------------

" Disable tmux navigator when zoomed in tmux
let g:tmux_navigator_disable_when_zoomed = 1

" No default mappings (we define our own in keybindings.vim)
let g:tmux_navigator_no_mappings = 0

" ----------------------------------------------------------------------------
" vim-maximizer Settings
" ----------------------------------------------------------------------------

" No default key mapping (we define our own in keybindings.vim)
let g:maximizer_set_default_mapping = 0

" ----------------------------------------------------------------------------
" winresizer Settings
" ----------------------------------------------------------------------------

" Start winresizer mode with Ctrl+e
let g:winresizer_start_key = '<C-e>'

" Use hjkl for resizing
let g:winresizer_keycode_left = 'h'
let g:winresizer_keycode_right = 'l'
let g:winresizer_keycode_down = 'j'
let g:winresizer_keycode_up = 'k'

" ----------------------------------------------------------------------------
" Color Scheme
" ----------------------------------------------------------------------------

" Enable true colors (needed for modern themes)
if has('termguicolors')
    set termguicolors
endif

" Set colorscheme with fallbacks
" To change theme, uncomment your preferred option or add to ~/.vimrc.local
try
    " Modern theme: Catppuccin Mocha (2024-2025 trending)
    " Options: catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    colorscheme catppuccin-mocha

    " Alternative modern themes (uncomment to use):
    " colorscheme tokyonight-night      " Deep blue, VS Code inspired
    " colorscheme tokyonight-storm      " Softer blue variant
    " colorscheme tokyonight-day        " Light theme
    " colorscheme kanagawa-wave         " Japanese art inspired
    " colorscheme kanagawa-dragon       " Darker variant
    " colorscheme kanagawa-lotus        " Light variant
catch
    try
        " Fallback to classic gruvbox
        colorscheme gruvbox
        set background=dark
        let g:gruvbox_contrast_dark = 'medium'
    catch
        try
            " Fallback to onedark
            colorscheme onedark
        catch
            " Final fallback to built-in desert
            colorscheme desert
        endtry
    endtry
endtry

" ----------------------------------------------------------------------------
" vim-polyglot Settings
" ----------------------------------------------------------------------------

" Disable vim-go in polyglot (we're using fatih/vim-go)
let g:polyglot_disabled = ['go']

" ----------------------------------------------------------------------------
" CoC Extensions (installed automatically)
" ----------------------------------------------------------------------------

" List of CoC extensions to install
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-pyright',
    \ 'coc-solargraph',
    \ 'coc-go',
    \ 'coc-sh',
    \ 'coc-yaml',
    \ 'coc-html',
    \ 'coc-css',
    \ ]

" ----------------------------------------------------------------------------
" auto-pairs Settings
" ----------------------------------------------------------------------------

" Enable fly mode (jump out of pair with closing character)
let g:AutoPairsFlyMode = 0

" Map <CR> to expand brackets
let g:AutoPairsMapCR = 1
