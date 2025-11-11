" ============================================================================
" General Settings
" ============================================================================

" Use Vim settings, not Vi
set nocompatible

" Enable filetype detection and plugins
filetype plugin indent on

" Syntax highlighting
syntax enable

" ============================================================================
" Visual Settings
" ============================================================================

" Line numbers
set number
set relativenumber

" Show current line and column
set ruler
set cursorline

" Show command in bottom bar
set showcmd

" Highlight matching brackets
set showmatch

" Enable 256 colors
set t_Co=256

" Note: Color scheme is loaded in plugins.vim after plug#end()
" Fallback if plugins didn't load
if !exists('g:colors_name')
    set background=dark
    try
        colorscheme desert
    catch
    endtry
endif

" ============================================================================
" Editor Behavior
" ============================================================================

" Tab settings (4 spaces)
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

" Indentation
set autoindent
set smartindent

" Backspace behavior
set backspace=indent,eol,start

" Line wrapping
set wrap
set linebreak

" Scrolling
set scrolloff=8
set sidescrolloff=8

" ============================================================================
" Search Settings
" ============================================================================

" Incremental search
set incsearch

" Highlight search results
set hlsearch

" Case insensitive search unless uppercase is used
set ignorecase
set smartcase

" ============================================================================
" Mouse Support (works in all terminals)
" ============================================================================

set mouse=a
if has('mouse_sgr')
    set ttymouse=sgr
endif

" ============================================================================
" File Management
" ============================================================================

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" File type detection
set autoread

" Don't create backup/swap files
set nobackup
set nowritebackup
set noswapfile

" Persistent undo
set undofile
set undodir=~/.vim/undodir
silent! call mkdir(expand('~/.vim/undodir'), 'p')

" ============================================================================
" Performance
" ============================================================================

" Faster updates for better experience
set updatetime=300

" Don't pass messages to completion menu
set shortmess+=c

" Always show signcolumn (prevents text shifting with git/linter signs)
set signcolumn=yes

" Redraw only when needed
set lazyredraw

" ============================================================================
" Command Line
" ============================================================================

" Better command-line completion
set wildmenu
set wildmode=longest:full,full

" Ignore files in completion
set wildignore=*.o,*.obj,*.pyc,*.swp,*.class,*.DS_Store,*/tmp/*,*/node_modules/*

" Command history
set history=1000

" ============================================================================
" Splits
" ============================================================================

" Split below and right (more natural)
set splitbelow
set splitright

" ============================================================================
" Clipboard (Cross-platform)
" ============================================================================

" Detect platform and set clipboard accordingly
if has('mac')
    " macOS
    set clipboard=unnamed
elseif has('unix')
    if has('wsl')
        " WSL-specific clipboard integration
        set clipboard=unnamedplus
        augroup WSLYank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/windows/system32/clip.exe', @0) | endif
        augroup END
    else
        " Linux (requires vim-gtk or vim-gnome)
        set clipboard=unnamedplus
    endif
endif

" ============================================================================
" Status Line
" ============================================================================

" Always show status line
set laststatus=2

" Show mode
set showmode

" ============================================================================
" Bell
" ============================================================================

" Disable error bells
set noerrorbells
set novisualbell
set t_vb=

" ============================================================================
" Folding
" ============================================================================

" Enable folding
set foldenable
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=10

" ============================================================================
" Misc
" ============================================================================

" Allow hidden buffers
set hidden

" Better display for messages
set cmdheight=2

" Better diff
set diffopt+=vertical

" Timeout settings
set timeout
set timeoutlen=500
set ttimeoutlen=10
