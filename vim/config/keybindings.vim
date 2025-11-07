" ============================================================================
" Key Bindings
" ============================================================================

" ============================================================================
" Leader Key
" ============================================================================

" Set leader key to comma (easy to reach)
let mapleader = ","
let g:mapleader = ","

" ============================================================================
" Core Remappings
" ============================================================================

" Remap ; to : for easier command mode (no shift needed!)
nnoremap ; :
vnoremap ; :

" Keep ; functionality with ,;
nnoremap <leader>; ;
vnoremap <leader>; ;

" ============================================================================
" Saving and Quitting
" ============================================================================

" Fast saving
nnoremap <leader>w :w<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Fast quit
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>

" Save and quit
nnoremap <leader>x :x<CR>

" ============================================================================
" Window Navigation
" ============================================================================

" Navigate between splits with Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize splits
nnoremap <leader>= <C-w>=
nnoremap <leader>- <C-w>_
nnoremap <leader>\| <C-w>\|

" ============================================================================
" Buffer Management
" ============================================================================

" Next/previous buffer
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>

" Close buffer
nnoremap <leader>bd :bdelete<CR>

" List buffers
nnoremap <leader>bl :buffers<CR>

" ============================================================================
" Tab Management
" ============================================================================

" New tab
nnoremap <leader>tn :tabnew<CR>

" Close tab
nnoremap <leader>tc :tabclose<CR>

" Next/previous tab
nnoremap <leader>tj :tabnext<CR>
nnoremap <leader>tk :tabprevious<CR>

" ============================================================================
" NERDTree
" ============================================================================

" Toggle NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>

" Find current file in NERDTree
nnoremap <leader>nf :NERDTreeFind<CR>

" ============================================================================
" FZF (Fuzzy Finder)
" ============================================================================

" Find files
nnoremap <C-p> :Files<CR>

" Search in files (requires ripgrep)
nnoremap <leader>f :Rg<CR>

" Search buffers
nnoremap <leader>b :Buffers<CR>

" Search lines in current buffer
nnoremap <leader>/ :BLines<CR>

" Search lines in all buffers
nnoremap <leader>l :Lines<CR>

" Search git commits
nnoremap <leader>gc :Commits<CR>

" Search commands
nnoremap <leader>: :Commands<CR>

" Search help tags
nnoremap <leader>h :Helptags<CR>

" ============================================================================
" vim-go Mappings
" ============================================================================

" Go to definition
autocmd FileType go nmap <leader>gd <Plug>(go-def)
autocmd FileType go nmap <leader>gt <Plug>(go-def-tab)

" Go documentation
autocmd FileType go nmap <leader>gi <Plug>(go-info)

" Run tests
autocmd FileType go nmap <leader>tr <Plug>(go-test)
autocmd FileType go nmap <leader>tf <Plug>(go-test-func)

" Build and run
autocmd FileType go nmap <leader>gr <Plug>(go-run)
autocmd FileType go nmap <leader>gb <Plug>(go-build)

" ============================================================================
" CoC (Autocompletion)
" ============================================================================

" Use Tab for trigger completion and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Go to definition/implementation/references
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" Format code
nmap <leader>cf <Plug>(coc-format)
vmap <leader>cf <Plug>(coc-format-selected)

" Code actions
nmap <leader>ca <Plug>(coc-codeaction)
vmap <leader>ca <Plug>(coc-codeaction-selected)

" Fix current line
nmap <leader>cq <Plug>(coc-fix-current)

" Navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Show all diagnostics
nnoremap <silent> <leader>cd :<C-u>CocList diagnostics<cr>

" ============================================================================
" Git (Fugitive)
" ============================================================================

" Git status
nnoremap <leader>gs :Git<CR>

" Git diff
nnoremap <leader>gd :Gdiffsplit<CR>

" Git blame
nnoremap <leader>gb :Git blame<CR>

" Git log
nnoremap <leader>gl :Git log<CR>

" ============================================================================
" Commentary (Toggle comments)
" ============================================================================

" gcc to toggle comment (provided by vim-commentary)
" gc{motion} to comment motion
" gcap to comment a paragraph

" ============================================================================
" Search and Replace
" ============================================================================

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Search for visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Replace word under cursor
nnoremap <leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>

" ============================================================================
" Visual Mode
" ============================================================================

" Indent without losing selection
vnoremap < <gv
vnoremap > >gv

" Move lines up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" ============================================================================
" Normal Mode Enhancements
" ============================================================================

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==

" Better Y (yank to end of line)
nnoremap Y y$

" Center screen after jumps
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Join lines without moving cursor
nnoremap J mzJ`z

" ============================================================================
" Quick Editing
" ============================================================================

" Edit vimrc
nnoremap <leader>ev :vsplit ~/.vimrc<CR>

" Reload vimrc
nnoremap <leader>sv :source ~/.vimrc<CR>

" ============================================================================
" Misc Utilities
" ============================================================================

" Toggle paste mode
set pastetoggle=<F2>

" Spell check toggle
nnoremap <leader>s :setlocal spell!<CR>

" Toggle line numbers
nnoremap <leader>N :set number! relativenumber!<CR>

" Remove trailing whitespace
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
