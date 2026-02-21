# dotfiles

Personal configuration files for macOS development environment.

## Overview

This repository contains configurations for:

- **Neovim** - Modern Vim-based editor with Lua configuration
- **tmux** - Terminal multiplexer with custom keybindings
- **AeroSpace** - macOS tiling window manager

## Components

### Neovim

Located in `nvim/` - A fully featured Neovim setup using:
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Key Features**:
  - LSP support with autocomplete (nvim-cmp)
  - Fuzzy finder (Telescope)
  - Syntax highlighting (Treesitter)
  - File explorer (oil.nvim)
  - Git integration (gitsigns, fugitive, neogit)
  - AI assistance (Supermaven)
  - Status line (lualine)
  - Code formatting (conform.nvim)
  - Harpoon for quick file navigation
  - Tokyo Night color theme

See `nvim/lua/user/plugins/` for the full list of configured plugins.

### tmux

Located in `tmux/` - Terminal multiplexer configuration featuring:
- **Prefix Key**: `Ctrl+a` (instead of default `Ctrl+b`)
- **Split Bindings**:
  - `|` - Split horizontally
  - `-` - Split vertically
  - Splits open in current working directory
- **Vim-style navigation** between panes (Ctrl+h/j/k/l)
- **Plugins** (via TPM):
  - [tpm](https://github.com/tmux-plugins/tpm) - Plugin manager
  - [catppuccin/tmux](https://github.com/catppuccin/tmux) - Theme
  - [tmux-battery](https://github.com/tmux-plugins/tmux-battery) - Battery indicator
  - [tmux-cpu](https://github.com/tmux-plugins/tmux-cpu) - CPU usage
  - [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - Seamless vim/tmux navigation

### AeroSpace

Located in `aerospace/` - macOS tiling window manager configuration:
- Auto-starts at login
- **Keybindings** (examples):
  - `Alt+Shift+Enter` - Open new terminal
  - `Alt+1..0` - Switch to workspace
  - `Alt+Shift+1..0` - Move window to workspace
  - `Alt+h/j/k/l` - Focus window
  - `Alt+Shift+h/j/k/l` - Move window
- Mouse follows focus
- Auto-layout based on monitor orientation

See `aerospace/aerospace.toml` for complete configuration.

## Installation

1. Clone the repository:
```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
```

2. Create symlinks:
```bash
# Neovim
ln -s ~/.dotfiles/nvim ~/.config/nvim

# tmux
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# AeroSpace
ln -s ~/.dotfiles/aerospace/aerospace.toml ~/.aerospace.toml
```

3. Install tmux plugins:
   - Press `Ctrl+a` then `I` (capital i) in tmux to install TPM plugins

4. Install Neovim plugins:
   - Launch Neovim, lazy.nvim will automatically install plugins

## Requirements

- macOS
- [Neovim](https://neovim.io/) (v0.9+)
- [tmux](https://github.com/tmux/tmux)
- [AeroSpace](https://nikitabobko.github.io/AeroSpace/)
- Git

## License

Personal dotfiles - feel free to use as reference for your own setup.
