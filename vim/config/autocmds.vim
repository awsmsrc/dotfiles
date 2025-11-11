" ============================================================================
" Autocommands and File-Type Specific Settings
" ============================================================================

" ============================================================================
" General Autocommands
" ============================================================================

" Return to last edit position when opening files
augroup RestoreCursor
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" Auto-reload vimrc on save
augroup ReloadVimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd BufWritePost ~/.vimrc source ~/.vimrc
augroup END

" Highlight yanked text briefly (Neovim only)
if has('nvim')
    augroup HighlightYank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}
    augroup END
endif

" Auto-create directories when saving new files
augroup AutoMkdir
    autocmd!
    autocmd BufWritePre * if !isdirectory(expand("<afile>:p:h")) | call mkdir(expand("<afile>:p:h"), "p") | endif
augroup END

" Remove trailing whitespace on save (for specific file types)
augroup TrimWhitespace
    autocmd!
    autocmd BufWritePre *.go,*.py,*.js,*.jsx,*.ts,*.tsx,*.rb,*.java,*.c,*.cpp,*.h :%s/\s\+$//e
augroup END

" ============================================================================
" Go Files
" ============================================================================

augroup GoSettings
    autocmd!

    " Tab settings (Go uses tabs)
    autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

    " Show function signature and type info
    autocmd FileType go setlocal updatetime=100

    " Auto format on save (handled by vim-go)
    autocmd FileType go let g:go_fmt_autosave = 1

    " Highlight variable under cursor
    autocmd CursorHold *.go silent call CocActionAsync('highlight')

    " Fold functions by default
    autocmd FileType go setlocal foldmethod=syntax
    autocmd FileType go setlocal foldlevel=99
augroup END

" ============================================================================
" JavaScript/TypeScript Files
" ============================================================================

augroup JavaScriptSettings
    autocmd!

    " Tab settings (2 spaces is common in JS/TS)
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

    " Format on save with Prettier (via CoC)
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact let b:coc_format_on_save = 1

    " Use JSDoc style comments
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal commentstring=//\ %s

    " Highlight variable under cursor
    autocmd CursorHold *.js,*.jsx,*.ts,*.tsx silent call CocActionAsync('highlight')
augroup END

" ============================================================================
" Python Files
" ============================================================================

augroup PythonSettings
    autocmd!

    " Tab settings (4 spaces per PEP 8)
    autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

    " Max line length indicator at column 88 (Black formatter default)
    autocmd FileType python setlocal colorcolumn=88

    " Format on save
    autocmd FileType python let b:coc_format_on_save = 1

    " Highlight variable under cursor
    autocmd CursorHold *.py silent call CocActionAsync('highlight')

    " Python-specific key mappings
    autocmd FileType python nnoremap <buffer> <leader>pr :!python %<CR>
augroup END

" ============================================================================
" Ruby Files
" ============================================================================

augroup RubySettings
    autocmd!

    " Tab settings (2 spaces is Ruby standard)
    autocmd FileType ruby setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

    " Max line length indicator at column 120
    autocmd FileType ruby setlocal colorcolumn=120

    " Highlight variable under cursor
    autocmd CursorHold *.rb silent call CocActionAsync('highlight')

    " Ruby-specific key mappings
    autocmd FileType ruby nnoremap <buffer> <leader>rr :!ruby %<CR>
augroup END

" ============================================================================
" JSON Files
" ============================================================================

augroup JSONSettings
    autocmd!

    " Tab settings (2 spaces)
    autocmd FileType json setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

    " Format on save
    autocmd FileType json let b:coc_format_on_save = 1

    " Concealing for quotes (optional - can be distracting)
    autocmd FileType json setlocal conceallevel=0
augroup END

" ============================================================================
" YAML Files
" ============================================================================

augroup YAMLSettings
    autocmd!

    " Tab settings (2 spaces)
    autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

    " Prevent auto-indentation issues
    autocmd FileType yaml setlocal indentkeys-=<:>
augroup END

" ============================================================================
" Markdown Files
" ============================================================================

augroup MarkdownSettings
    autocmd!

    " Enable spell check
    autocmd FileType markdown setlocal spell spelllang=en_us

    " Tab settings (2 spaces)
    autocmd FileType markdown setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

    " Wrap text at 80 characters
    autocmd FileType markdown setlocal textwidth=80

    " Enable soft wrap
    autocmd FileType markdown setlocal wrap linebreak

    " Concealing for markdown syntax (optional)
    autocmd FileType markdown setlocal conceallevel=0
augroup END

" ============================================================================
" Git Commit Messages
" ============================================================================

augroup GitCommitSettings
    autocmd!

    " Enable spell check
    autocmd FileType gitcommit setlocal spell spelllang=en_us

    " Start in insert mode
    autocmd FileType gitcommit startinsert

    " Highlight long lines
    autocmd FileType gitcommit setlocal colorcolumn=72
augroup END

" ============================================================================
" Shell Scripts
" ============================================================================

augroup ShellSettings
    autocmd!

    " Tab settings (2 spaces)
    autocmd FileType sh,bash,zsh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

    " Make scripts executable on save
    autocmd BufWritePost *.sh,*.bash silent! !chmod +x %
augroup END

" ============================================================================
" HTML/CSS Files
" ============================================================================

augroup WebSettings
    autocmd!

    " Tab settings (2 spaces)
    autocmd FileType html,css,scss,sass setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

    " Format on save
    autocmd FileType html,css,scss,sass let b:coc_format_on_save = 1
augroup END

" ============================================================================
" C/C++ Files
" ============================================================================

augroup CSettings
    autocmd!

    " Tab settings (4 spaces or tabs depending on project)
    autocmd FileType c,cpp setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

    " Max line length indicator at column 100
    autocmd FileType c,cpp setlocal colorcolumn=100
augroup END

" ============================================================================
" Help Files
" ============================================================================

augroup HelpSettings
    autocmd!

    " Open help in vertical split
    autocmd FileType help wincmd L

    " Close help with q
    autocmd FileType help nnoremap <buffer> q :q<CR>
augroup END

" ============================================================================
" Terminal
" ============================================================================

augroup TerminalSettings
    autocmd!

    " No line numbers in terminal
    autocmd TerminalOpen * if &buftype == 'terminal' | setlocal nonumber norelativenumber | endif

    " Start in insert mode
    autocmd TerminalOpen * if &buftype == 'terminal' | startinsert | endif
augroup END

" ============================================================================
" Quickfix and Location List
" ============================================================================

augroup QuickfixSettings
    autocmd!

    " Close quickfix with q
    autocmd FileType qf nnoremap <buffer> q :q<CR>

    " Open quickfix window automatically after grep
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" ============================================================================
" NERDTree
" ============================================================================

augroup NERDTreeSettings
    autocmd!

    " Close vim if NERDTree is the only window remaining
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

    " Start NERDTree when vim is started without file arguments
    " autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
augroup END

" ============================================================================
" Performance Optimizations
" ============================================================================

augroup PerformanceOptimizations
    autocmd!

    " Disable syntax highlighting for large files (>1MB)
    autocmd BufReadPre * if getfsize(expand("%")) > 1000000 | syntax off | endif

    " Disable cursorline for large files
    autocmd BufReadPre * if getfsize(expand("%")) > 1000000 | setlocal nocursorline | endif
augroup END
