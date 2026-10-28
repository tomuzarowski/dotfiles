# dotfiles

Personal configuration files for macOS development environment.

## Overview

This repository contains configurations for:

- **Neovim** - Modern Vim-based editor with Lua configuration
- **AeroSpace** - macOS tiling window manager
- **opencode** - AI coding assistant configuration
- **Ghostty** - Terminal emulator configuration
- **Claude Code** - AI coding assistant settings, status line and skills
- **Pi** - Claude Max and OpenAI models, web research, MCP and code review

## Components

### Neovim

Located in `home/.config/nvim/` - A fully featured Neovim setup using:
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

See `home/.config/nvim/lua/user/plugins/` for the full list of configured plugins.

### AeroSpace

Located in `home/.config/aerospace/` - macOS tiling window manager configuration:
- Auto-starts at login
- **Keybindings** (examples):
  - `Alt+Shift+Enter` - Open new terminal
  - `Alt+1..0` - Switch to workspace
  - `Alt+Shift+1..0` - Move window to workspace
  - `Alt+h/j/k/l` - Focus window
  - `Alt+Shift+h/j/k/l` - Move window
- Mouse follows focus
- Auto-layout based on monitor orientation

See `home/.config/aerospace/aerospace.toml` for complete configuration.

### opencode

Located in `home/.config/opencode/` - Configuration for the [opencode](https://opencode.ai) AI coding assistant:
- MCP server configurations (Playwright, Pencil)
- Browser automation settings
- Tool integrations

### Ghostty

Located in `home/.config/ghostty/` - Configuration for the [Ghostty](https://ghostty.org) terminal emulator.

Ghostty loads this file via the XDG configuration path:
`~/.config/ghostty/config.ghostty`

### Claude Code

Located in `home/.claude/` - Configuration for [Claude Code](https://code.claude.com):
- `settings.json` - Model, language, permissions, plugins and status line settings
- `statusline-command.sh` - Status line with model, folder, git branch, context usage, cost and duration
- `skills/` - Personal skills (`find-docs`, `deploying-to-cloud`)

`~/.claude` also holds Claude Code's history, sessions and caches, so it stays a real directory and Stow links only the entries above.

The `autoMode` block in `settings.json` describes private projects, so a git clean filter (`.gitattributes`) strips it from commits while keeping it in the local file. The filter also sorts keys, since Claude Code reorders them when it saves settings. `install.sh` configures the filter; run it on a new machine before committing.

### Pi

Located in `home/.pi/agent/` — global configuration for [pi](https://pi.dev). Claude Max uses Dillon Mulroy's CLI provider; OpenAI uses Sign in with ChatGPT. Includes Figma, Context7, isolated Chrome DevTools, web tools and a code-review skill. Runtime credentials, sessions and packages remain outside this repository.

Cloning this repository provides configuration only. On a new Mac, first run the repository installation steps below (`./install.sh`), then complete this setup. The installer configures Stow and Git filters; it does not install Pi, Claude Code, Node.js or Chrome.

#### Set up Pi on a new Mac

You need Node.js >=22.19, Claude Code >=2.1.292, Google Chrome, a Claude Max account, a ChatGPT account with access to the configured OpenAI models, and a Figma account. GitHub CLI is needed for PR review.

If Node.js is already managed by nvm or another version manager, keep that installation. Otherwise install Node 22 and put it on your PATH:

```bash
brew install node@22
export PATH="$(brew --prefix node@22)/bin:$PATH"
```

Keep that PATH setting in your shell configuration if you use Homebrew Node. Then install the remaining programs, skipping any already installed through another method:

```bash
brew install gh
brew install --cask claude-code google-chrome
npm install -g --ignore-scripts @earendil-works/pi-coding-agent@1.4.0
```

Install the exact extension revisions declared in this repository, then log in on this machine:

```bash
cd ~/.dotfiles
jq -r '.packages[]' home/.pi/agent/settings.json | while IFS= read -r package_source; do
  pi install "$package_source" || break
done
claude auth login
gh auth login
pi mcp login figma
pi
```

In Pi, run `/login` and choose **OpenAI → Sign in with ChatGPT**. Use your Claude Max subscription for Claude Code and ChatGPT login for OpenAI; no paid API keys or automatic paid fallback are configured. Figma authorization opens in the browser. Context7 and Exa search start without keys, subject to their free limits. Chrome DevTools launches a separate temporary Chrome profile; its logins do not persist after it closes.

The configured models are **Opus 5.5** (default), **GPT-6.1 Sol** and **GPT-6 Luna**, with `medium` reasoning by default. `/model` or `Ctrl+P` changes models; `/thinking` or `Shift+Tab` changes reasoning. `/skill:code-review` reviews local changes; add a branch, PR number or PR URL to select another target. Review reports stay in the terminal.

Check installation and MCP connections with:

```bash
pi --version
pi list
pi auth check --provider openai
pi mcp list
```

For the final check, ask Pi to search the web, fetch library documentation through Context7, inspect a page in Chrome, and read a Figma frame you can access.

#### Local data and updates

`~/.pi/agent` stays a real directory; Stow links only configuration entries. Tokens, sessions, installed packages and logs remain local and are not copied by Git. The Git clean filter removes Pi's machine-specific `deviceId` from committed settings. Run `./install.sh` before committing on another machine so this filter is configured. If the installer detects an existing live directory symlink at `~/.pi`, migrate it to a real directory before retrying.

Extension commits and the Chrome DevTools MCP version are pinned in `settings.json` and `mcp.json`. To update them, inspect upstream changes, change the pins deliberately, reinstall the declared packages and restart Pi. Update Pi itself explicitly with `npm install -g --ignore-scripts @earendil-works/pi-coding-agent@<version>`. Repeat the connection and tool checks after updates.

The Claude usage-credit guard stops subsequent calls after a billing warning; it cannot undo a charge already made. Disable Extra Usage in the Claude account and avoid purchasing additional ChatGPT/Codex credits if no extra spend is acceptable.

Install references: [Pi](https://pi.dev/), [Claude Code Homebrew cask](https://formulae.brew.sh/cask/claude-code), [Chrome Homebrew cask](https://formulae.brew.sh/cask/google-chrome), [Node 22](https://formulae.brew.sh/formula/node@22), [GitHub CLI](https://formulae.brew.sh/formula/gh).

## Installation

1. Clone the repository:
```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
```

2. Run the install script:
```bash
./install.sh
```

This will install Homebrew, [GNU Stow](https://www.gnu.org/software/stow/) and [jq](https://jqlang.org) if needed, then create symlinks from `home/.config/` into `~/.config/` via Stow.
Entries in `~/.claude` and the Pi configuration in `~/.pi/agent` are linked individually; existing configuration files are backed up first. For Pi on a new machine, also complete [Set up Pi on a new Mac](#set-up-pi-on-a-new-mac).

3. Install Neovim plugins:
   - Launch Neovim, lazy.nvim will automatically install plugins

## Requirements

- macOS
- [Homebrew](https://brew.sh/)
- [Neovim](https://neovim.io/) (v0.9+)
- [AeroSpace](https://nikitabobko.github.io/AeroSpace/)
- [opencode](https://opencode.ai)
- [Ghostty](https://ghostty.org)
- [Claude Code](https://code.claude.com)
- [jq](https://jqlang.org)
- Git

## License

Personal dotfiles - feel free to use as reference for your own setup.
