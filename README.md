# Modern Dotfiles

A clean, modular configuration for Vim and shell with IDE-like features, modern themes, and a beautiful Starship prompt for Go, JavaScript, Python, and Ruby development.

## Features

### Shell Prompt (Starship)

- **Beautiful, Fast Prompt**
  - Cross-shell support (bash and zsh)
  - Git branch and status with file counts (!3 ?2 +1 for modified/untracked/staged)
  - Smart directory truncation
  - Language version displays (Go, Node, Python, Ruby)
  - Command execution time
  - Rich icons with Nerd Fonts
  - Sub-50ms rendering speed

### Vim Configuration

- **File Navigation**
  - NERDTree for project tree browsing
  - fzf for blazingly fast fuzzy file search
  - Git integration in file tree

- **Intelligent Autocompletion**
  - LSP-based autocompletion via CoC.nvim
  - Support for Go, JavaScript/TypeScript, Python, and Ruby
  - Context-aware suggestions
  - Automatic imports

- **Language Support**
  - **Go**: Full vim-go integration with testing, building, and formatting
  - **JavaScript/TypeScript**: Modern React/Node.js support
  - **Python**: Black formatting and type checking
  - **Ruby**: Solargraph integration
  - Syntax highlighting for 600+ languages

- **Developer Experience**
  - Mouse support in all terminals (macOS, Linux, WSL)
  - Ergonomic keybindings (; remapped to :)
  - Git integration (fugitive, gitgutter)
  - Auto-pairs, commenting, surround text
  - Cross-platform clipboard support

- **Modern UI & Themes**
  - Trending 2024-2025 color schemes:
    - **Catppuccin Mocha** (default) - Warm pastel palette
    - **Tokyo Night** - Deep blue VS Code inspired
    - **Kanagawa** - Japanese art inspired
  - Classic themes: Gruvbox, OneDark
  - Airline status bar with theme matching
  - File icons with Nerd Fonts
  - Git diff indicators

## Prerequisites

### Required

- **Vim 8.1+** (for CoC.nvim support)
- **Git**
- **curl**

### Recommended

- **Node.js 16+** (required for CoC.nvim autocompletion)
- **Python 3.6+** (for some plugins)

### Optional (for enhanced functionality)

- **ripgrep** (rg) - Fast text search in fzf
- **fd** - Fast file finder
- **bat** - Better file previews
- **Nerd Font** - File icons in NERDTree

## Installation

### Quick Install

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles
./install.sh
```

The install script will:
1. Detect your platform (macOS/Linux/WSL)
2. Check prerequisites
3. Backup existing configuration
4. Create symbolic links for vim
5. Optionally install shell configs (bashrc, zshrc, starship)
6. Install vim-plug and plugins
7. Install CoC extensions
8. Provide instructions for optional tools

**Note:** The shell configuration (bashrc, zshrc, starship) is optional during installation. The script will prompt you before replacing your existing shell configs.

### Manual Install

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Create symlinks
ln -sf ~/dotfiles/.vimrc ~/.vimrc
mkdir -p ~/.vim
ln -sf ~/dotfiles/vim/config ~/.vim/config
ln -sf ~/dotfiles/coc-settings.json ~/.vim/coc-settings.json

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Open vim and install plugins
vim +PlugInstall +qall
```

## Language Server Setup

For full autocompletion support, install language servers:

### Go

```bash
go install golang.org/x/tools/gopls@latest
```

### JavaScript/TypeScript

```bash
npm install -g typescript typescript-language-server
```

### Python

```bash
npm install -g pyright
# or
pip install jedi-language-server
```

### Ruby

```bash
gem install solargraph
```

## Optional Tools Installation

### macOS (using Homebrew)

```bash
# Fast search tools
brew install ripgrep fd bat

# Nerd Fonts (for icons)
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
brew install --cask font-hack-nerd-font
```

### Linux/WSL

```bash
# Ubuntu/Debian
sudo apt-get install ripgrep fd-find bat

# Fedora/RHEL
sudo yum install ripgrep fd-find bat
```

For Nerd Fonts, download from [nerdfonts.com](https://www.nerdfonts.com/font-downloads)

## Key Mappings

### Core Remappings

| Key | Action | Description |
|-----|--------|-------------|
| `;` | `:` | Enter command mode (no shift needed!) |
| `,;` | `;` | Original ; functionality |

### Leader Key

Leader key is set to `,` (comma)

### File Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `,n` | Toggle NERDTree | Open/close file tree |
| `,nf` | Find in NERDTree | Reveal current file in tree |
| `Ctrl+p` | Find files | Fuzzy file search |
| `,f` | Search in files | Find text in project (ripgrep) |
| `,b` | Buffer list | Switch between open files |
| `,/` | Search in buffer | Find text in current file |

### Window/Split Navigation & Management

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+h` | Move to left window | Seamless vim+tmux navigation |
| `Ctrl+j` | Move to bottom window | Seamless vim+tmux navigation |
| `Ctrl+k` | Move to top window | Seamless vim+tmux navigation |
| `Ctrl+l` | Move to right window | Seamless vim+tmux navigation |
| `,m` | Toggle maximize | Zoom current split (restore with `,m` again) |
| `Ctrl+e` | Resize mode | Enter interactive resize mode, use hjkl to resize |
| `,=` | Equalize splits | Make all splits equal size |
| `,-` | Maximize height | Maximize current split height |
| `,\|` | Maximize width | Maximize current split width |

### Autocompletion (CoC)

| Key | Action | Description |
|-----|--------|-------------|
| `Tab` | Next completion | Navigate completions |
| `Shift+Tab` | Previous completion | Navigate backwards |
| `Enter` | Accept completion | Insert selected item |
| `Ctrl+Space` | Trigger completion | Force show completions |
| `gd` | Go to definition | Jump to symbol definition |
| `gy` | Go to type definition | Jump to type |
| `gi` | Go to implementation | Jump to implementation |
| `gr` | Go to references | Show all references |
| `K` | Show documentation | Display hover info |
| `,rn` | Rename symbol | Rename across project |
| `,cf` | Format code | Auto-format file |
| `,ca` | Code action | Show available actions |
| `[g` | Previous diagnostic | Jump to previous error |
| `]g` | Next diagnostic | Jump to next error |

### Git (Fugitive)

| Key | Action |
|-----|--------|
| `,gs` | Git status |
| `,gd` | Git diff |
| `,gb` | Git blame |
| `,gl` | Git log |
| `,gc` | Search commits |

### Editing

| Key | Action | Description |
|-----|--------|-------------|
| `gcc` | Toggle comment | Comment/uncomment line |
| `gc{motion}` | Comment motion | Comment text object |
| `ys{motion}{char}` | Surround with | Add surrounding chars |
| `cs{old}{new}` | Change surrounding | Replace surrounding chars |
| `ds{char}` | Delete surrounding | Remove surrounding chars |
| `,w` or `Ctrl+s` | Save file | Write changes |
| `,q` | Quit | Close window |

### Visual Mode

| Key | Action |
|-----|--------|
| `<` | Indent left (keeps selection) |
| `>` | Indent right (keeps selection) |
| `J` | Move lines down |
| `K` | Move lines up |

### Search

| Key | Action |
|-----|--------|
| `,<space>` | Clear highlight | Remove search highlighting |
| `,r` | Replace word | Replace word under cursor |

### Language-Specific

#### Go (in .go files)

| Key | Action |
|-----|--------|
| `,gd` | Go to definition |
| `,gi` | Show info |
| `,tr` | Run tests |
| `,tf` | Run test function |
| `,gr` | Run program |
| `,gb` | Build program |

## Configuration Structure

```
dotfiles/
├── .bashrc                     # Bash configuration with Starship
├── .zshrc                      # Zsh configuration with Starship
├── starship.toml               # Starship prompt configuration
├── .vimrc                      # Main vim entry point
├── vim/
│   └── config/
│       ├── settings.vim        # Editor settings
│       ├── keybindings.vim     # Key mappings
│       ├── plugins.vim         # Plugin declarations
│       └── autocmds.vim        # File-type settings
├── coc-settings.json          # LSP configuration
├── install.sh                 # Installation script
└── README.md                  # This file
```

## Customization

### Changing Vim Color Scheme

The default theme is **Catppuccin Mocha**. To switch themes, edit `vim/config/plugins.vim` (line 258):

```vim
" Choose one:
colorscheme catppuccin-mocha      " Warm pastels (default)
colorscheme catppuccin-latte      " Light variant
colorscheme tokyonight-night      " Deep blue
colorscheme tokyonight-storm      " Softer blue
colorscheme kanagawa-wave         " Japanese art inspired
colorscheme gruvbox               " Classic retro
colorscheme onedark               " Atom-inspired
```

Or create `~/.vimrc.local` for local overrides:

```vim
colorscheme tokyonight-night
let g:airline_theme='tokyonight'
```

### Customizing Starship Prompt

Edit `starship.toml` to customize your prompt. Common customizations:

```toml
# Change prompt character
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

# Customize git status symbols
[git_status]
modified = "M${count}"
untracked = "U${count}"
staged = "S${count}"

# Show/hide directory truncation
[directory]
truncation_length = 5
truncate_to_repo = false

# Add more language displays
[rust]
symbol = " "
format = "via [$symbol($version )]($style)"
```

See [Starship documentation](https://starship.rs/config/) for all options.

### Shell Configuration

If you didn't install shell configs during setup, you can add Starship to your existing shell configs:

```bash
# Add to ~/.bashrc or ~/.zshrc:
eval "$(starship init bash)"   # for bash
eval "$(starship init zsh)"    # for zsh

# Then symlink the config:
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
```

### Local Overrides

Create `~/.vimrc.local` or `~/.bashrc.local` / `~/.zshrc.local` for machine-specific settings that won't be tracked in git.

### Adding Vim Plugins

Edit `vim/config/plugins.vim`:

```vim
" Add to the plug#begin() section
Plug 'tpope/vim-dispatch'
```

Then run `:PlugInstall` in vim.

### Custom Keybindings

Add to `vim/config/keybindings.vim`:

```vim
" Example: Map F5 to run current Python file
autocmd FileType python nnoremap <F5> :!python %<CR>
```

## Platform-Specific Notes

### macOS

- Uses system clipboard by default
- Terminal.app: Configure to use Nerd Font for icons
- iTerm2: Better color support and ligatures

### WSL (Windows Subsystem for Linux)

- Clipboard integration with Windows via clip.exe
- Install Windows Terminal for better experience
- Configure terminal to use Nerd Font

### Linux

- Clipboard requires `vim-gtk` or `vim-gnome`:
  ```bash
  sudo apt-get install vim-gtk3
  ```

## Plugins Used

### Navigation
- [NERDTree](https://github.com/preservim/nerdtree) - File tree explorer
- [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin) - Git status in NERDTree
- [fzf.vim](https://github.com/junegunn/fzf.vim) - Fuzzy finder

### Window/Split Management
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - Seamless vim/tmux navigation
- [vim-maximizer](https://github.com/szw/vim-maximizer) - Toggle maximize/restore splits
- [winresizer](https://github.com/simeji/winresizer) - Interactive window resizing

### Autocompletion
- [CoC.nvim](https://github.com/neoclide/coc.nvim) - LSP client

### Language Support
- [vim-go](https://github.com/fatih/vim-go) - Go development
- [vim-polyglot](https://github.com/sheerun/vim-polyglot) - Multi-language syntax

### Git
- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Git integration
- [vim-gitgutter](https://github.com/airblade/vim-gitgutter) - Git diff signs

### UI
- [vim-airline](https://github.com/vim-airline/vim-airline) - Status bar
- [vim-devicons](https://github.com/ryanoasis/vim-devicons) - File icons
- [Catppuccin](https://github.com/catppuccin/vim) - Modern color scheme (default)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) - Deep blue theme
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim) - Japanese art inspired theme
- [gruvbox](https://github.com/morhetz/gruvbox) - Classic retro theme
- [onedark.vim](https://github.com/joshdick/onedark.vim) - Atom-inspired theme

### Editing
- [auto-pairs](https://github.com/jiangmiao/auto-pairs) - Auto-close brackets
- [vim-commentary](https://github.com/tpope/vim-commentary) - Easy commenting
- [vim-surround](https://github.com/tpope/vim-surround) - Surround text objects

## Troubleshooting

### CoC not working

1. Check Node.js version: `node --version` (should be 16+)
2. Install CoC extensions manually: `:CocInstall coc-go coc-tsserver coc-pyright`
3. Check CoC status: `:CocInfo`

### No autocompletion for language X

Install the language server (see [Language Server Setup](#language-server-setup))

### NERDTree icons not showing

Install a Nerd Font and configure your terminal to use it

### Slow performance

- Disable some plugins in `vim/config/plugins.vim`
- Check for slow language servers: `:CocInfo`
- Large files: Syntax highlighting auto-disabled for files >1MB

### Mouse not working

- Check vim version: `vim --version | grep +mouse`
- Try `:set mouse=a` manually
- Some terminals require special configuration

### Clipboard not working

**macOS**: Should work out of the box

**Linux**: Install `vim-gtk` or `vim-gnome`:
```bash
sudo apt-get install vim-gtk3
```

**WSL**: Clipboard integration uses clip.exe (Windows)

## Uninstall

```bash
cd ~/dotfiles
./install.sh --uninstall
```

This will:
- Remove all symlinks
- Keep your backups in `~/.vim-backup-*` directories

To fully remove everything:

```bash
rm -rf ~/.vim ~/.vimrc ~/dotfiles
```

## Updates

### Update plugins

```vim
:PlugUpdate
```

### Update CoC extensions

```vim
:CocUpdate
```

### Update dotfiles

```bash
cd ~/dotfiles
git pull
```

## Contributing

Feel free to fork and customize for your needs!

## License

MIT

## Resources

- [Vim Documentation](https://www.vim.org/docs.php)
- [CoC.nvim Documentation](https://github.com/neoclide/coc.nvim/wiki)
- [vim-go Tutorial](https://github.com/fatih/vim-go/wiki)
- [Awesome Vim](https://github.com/akrawchyk/awesome-vim)

## Credits

This configuration is inspired by many excellent dotfiles repositories and the vim community.

Happy vimming! 🚀
